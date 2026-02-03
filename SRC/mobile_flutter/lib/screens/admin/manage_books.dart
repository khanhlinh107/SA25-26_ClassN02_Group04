// import 'package:flutter/material.dart';
// import '../../models/book.dart';
// import '../../services/book_service.dart';
//
// class ManageBooksScreen extends StatefulWidget {
//   const ManageBooksScreen({super.key});
//
//   @override
//   State<ManageBooksScreen> createState() => _ManageBooksScreenState();
// }
//
// class _ManageBooksScreenState extends State<ManageBooksScreen> {
//   final BookService _bookService = BookService();
//
//   void _openBookDialog({Book? book}) {
//     final titleCtrl = TextEditingController(text: book?.title ?? '');
//     final authorCtrl = TextEditingController(text: book?.author ?? '');
//     final categoryCtrl = TextEditingController(text: book?.category ?? '');
//     final quantityCtrl =
//     TextEditingController(text: book?.quantity.toString() ?? '');
//     final imageCtrl = TextEditingController(text: book?.imageUrl ?? '');
//
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text(book == null ? 'Add Book' : 'Edit Book'),
//         content: SingleChildScrollView(
//           child: Column(
//             children: [
//               TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Title')),
//               TextField(controller: authorCtrl, decoration: const InputDecoration(labelText: 'Author')),
//               TextField(controller: categoryCtrl, decoration: const InputDecoration(labelText: 'Category')),
//               TextField(
//                 controller: quantityCtrl,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(labelText: 'Quantity'),
//               ),
//               TextField(controller: imageCtrl, decoration: const InputDecoration(labelText: 'Image URL')),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
//           ElevatedButton(
//             onPressed: () async {
//               final quantity = int.tryParse(quantityCtrl.text) ?? 0;
//
//               final newBook = Book(
//                 id: book?.id ?? '',
//                 title: titleCtrl.text,
//                 author: authorCtrl.text,
//                 category: categoryCtrl.text,
//                 quantity: quantity,
//                 available: book?.available ?? quantity,
//                 imageUrl: imageCtrl.text,
//               );
//
//               if (book == null) {
//                 await _bookService.addBook(newBook);
//               } else {
//                 await _bookService.updateBook(newBook);
//               }
//
//               if (!mounted) return;
//               Navigator.pop(context);
//             },
//             child: const Text('Save'),
//           )
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Manage Books')),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _openBookDialog(),
//         child: const Icon(Icons.add),
//       ),
//       body: StreamBuilder<List<Book>>(
//         stream: _bookService.getBooks(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           final books = snapshot.data ?? [];
//
//           if (books.isEmpty) {
//             return const Center(child: Text('No books yet'));
//           }
//
//           return ListView.builder(
//             itemCount: books.length,
//             itemBuilder: (_, i) {
//               final book = books[i];
//               return ListTile(
//                 leading: book.imageUrl.isNotEmpty
//                     ? Image.network(book.imageUrl, width: 50, fit: BoxFit.cover)
//                     : const Icon(Icons.book),
//                 title: Text(book.title),
//                 subtitle: Text('${book.author} • Available: ${book.available}'),
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.edit),
//                       onPressed: () => _openBookDialog(book: book),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.delete, color: Colors.red),
//                       onPressed: () => _bookService.deleteBook(book.id),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }