import 'package:flutter/material.dart';
import '../../models/book.dart';
import '../../services/book_api_service.dart';
import '../../services/book_service.dart';

class ImportBooksScreen extends StatefulWidget {
  const ImportBooksScreen({super.key});

  @override
  State<ImportBooksScreen> createState() => _ImportBooksScreenState();
}

class _ImportBooksScreenState extends State<ImportBooksScreen> {
  final _searchCtrl = TextEditingController();
  final _api = BookApiService();
  final _bookService = BookService();

  List<Book> results = [];
  bool loading = false;

  Future<void> _search() async {
    setState(() => loading = true);
    results = await _api.searchBooks(_searchCtrl.text.trim());
    setState(() => loading = false);
  }

  Future<void> _import(Book b) async {
    await _bookService.importBook(b);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Imported "${b.title}"')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Import Books Online')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Search book (e.g. Flutter, Java)',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _search,
                ),
              ],
            ),

            const SizedBox(height: 12),

            if (loading) const CircularProgressIndicator(),

            Expanded(
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (_, i) {
                  final b = results[i];
                  return Card(
                    child: ListTile(
                      leading: b.imageUrl.isNotEmpty
                          ? Image.network(b.imageUrl, width: 40)
                          : const Icon(Icons.book),
                      title: Text(b.title),
                      subtitle: Text(b.author),
                      trailing: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => _import(b),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
