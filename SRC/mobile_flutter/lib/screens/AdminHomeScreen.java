import 'package:flutter/material.dart';

import '../../services/book_service.dart';
import '../../models/book.dart';
import '../../widgets/book/book_section.dart';
import '../../widgets/book/add_book_dialog.dart';
import 'import_books_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  final bool isAdmin;

  const AdminHomeScreen({
    super.key,
    required this.isAdmin,
  });

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final TextEditingController searchCtrl = TextEditingController();
  String keyword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Library'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.person),
                Text(
                  widget.isAdmin ? 'Admin' : 'Student',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),

      /// ➕ ADD BOOK (ADMIN ONLY)
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
          /// ☁️ ADMIN TOOL – IMPORT ONLINE BOOKS
          if (widget.isAdmin)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.cloud_download),
                  title: const Text('Import books online'),
                  subtitle: const Text('Fetch books from online API'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ImportBooksScreen(),
                      ),
                    );
                  },
                ),
              ),
            ),

          /// 🔍 SEARCH BAR
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: searchCtrl,
              onChanged: (value) {
                setState(() {
                  keyword = value.toLowerCase().trim();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search by title, author, category',
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                isDense: true,
              ),
            ),
          ),

          /// 📚 BOOK LIST
          Expanded(
            child: StreamBuilder<List<Book>>(
              stream: BookService().getBooks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading books'));
                }

                final allBooks = snapshot.data ?? [];

                /// 🔎 FILTER
                final books = keyword.isEmpty
                    ? allBooks
                    : allBooks.where((b) {
                        return b.title.toLowerCase().contains(keyword) ||
                            b.author.toLowerCase().contains(keyword) ||
                            b.category.toLowerCase().contains(keyword);
                      }).toList();

                if (books.isEmpty) {
                  return const Center(child: Text('No matching books'));
                }

                /// 📂 GROUP BY CATEGORY
                final Map<String, List<Book>> grouped = {};
                for (final book in books) {
                  grouped.putIfAbsent(book.category, () => []).add(book);
                }

                return ListView(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  children: grouped.entries.map((entry) {
                    return BookSection(
                      category: entry.key,
                      books: entry.value,
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
