import 'package:flutter/material.dart';
import '../../models/book.dart';
import '../../services/book_service.dart';
import '../../widgets/book/book_section.dart';
import '../../widgets/book/add_book_dialog.dart';
import '../../widgets/book/top_borrowed_books.dart';
import '../admin/import_books_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  final bool isAdmin;

  const AdminHomeScreen({
    super.key,
    required this.isAdmin,
  });

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen>
    with TickerProviderStateMixin {
  final TextEditingController searchCtrl = TextEditingController();
  String keyword = '';
  bool showTopBorrowed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      /// 🔝 APP BAR
      appBar: AppBar(
        title: const Text('Library'),
        elevation: 0,
        actions: [
          if (widget.isAdmin)
            IconButton(
              icon: const Icon(Icons.cloud_download),
              tooltip: 'Import books online',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ImportBooksScreen(),
                  ),
                );
              },
            ),
        ],
      ),

      /// ➕ ADD BOOK
      floatingActionButton: widget.isAdmin
          ? FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => const AddBookDialog(),
          );
        },
        child: const Icon(Icons.add),
      )
          : null,

      body: Column(
        children: [
          /// 🔍 SEARCH BAR
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Card(
              elevation: 2,
              shadowColor: Colors.black12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                controller: searchCtrl,
                onChanged: (value) {
                  setState(() {
                    keyword = value.toLowerCase().trim();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search books...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: keyword.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      searchCtrl.clear();
                      setState(() => keyword = '');
                    },
                  )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),

          /// ⭐ MOST BORROWED (CLICKABLE)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  setState(() {
                    showTopBorrowed = !showTopBorrowed;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.local_fire_department,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Most borrowed books',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Top 3 books students borrow the most',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        showTopBorrowed
                            ? Icons.expand_less
                            : Icons.expand_more,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          /// 🎬 TOP 3 WITH ANIMATION
          StreamBuilder<List<Book>>(
            stream: BookService().getBooks(),
            builder: (context, snapshot) {
              final books = snapshot.data ?? [];

              books.sort(
                    (a, b) => b.borrowCount.compareTo(a.borrowCount),
              );

              final top3 = books.take(3).toList();

              return AnimatedSize(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: showTopBorrowed ? 1 : 0,
                  child: showTopBorrowed
                      ? Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: TopBorrowedBooks(books: top3),
                  )
                      : const SizedBox.shrink(),
                ),
              );
            },
          ),

          /// 📚 ALL BOOKS TITLE
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'All books',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          /// 📚 BOOK LIST
          Expanded(
            child: StreamBuilder<List<Book>>(
              stream: BookService().getBooks(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final allBooks = snapshot.data!;

                final books = keyword.isEmpty
                    ? allBooks
                    : allBooks.where((b) {
                  return b.title.toLowerCase().contains(keyword) ||
                      b.author.toLowerCase().contains(keyword) ||
                      b.category.toLowerCase().contains(keyword);
                }).toList();

                if (books.isEmpty) {
                  return const Center(
                    child: Text('No matching books'),
                  );
                }

                final Map<String, List<Book>> grouped = {};
                for (final book in books) {
                  grouped.putIfAbsent(book.category, () => []).add(book);
                }

                return ListView(
                  padding: const EdgeInsets.only(bottom: 12),
                  children: grouped.entries.map((e) {
                    return BookSection(
                      category: e.key,
                      books: e.value,
                      isAdmin: widget.isAdmin,
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
