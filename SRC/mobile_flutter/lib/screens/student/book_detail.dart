// import 'package:flutter/material.dart';
// import '../../models/book.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../../services/borrow_service.dart';
//
//
// class BookDetailScreen extends StatelessWidget {
//   final Book book;
//   const BookDetailScreen({super.key, required this.book});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(book.title)),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: book.imageUrl.isNotEmpty
//                   ? Image.network(book.imageUrl, height: 200)
//                   : const Icon(Icons.book, size: 120),
//             ),
//             const SizedBox(height: 16),
//             Text('Author: ${book.author}', style: Theme.of(context).textTheme.titleMedium),
//             const SizedBox(height: 8),
//             Text('Category: ${book.category}'),
//             const SizedBox(height: 8),
//             Text('Available: ${book.available}'),
//             const Spacer(),
//             ElevatedButton(
//               onPressed: book.available > 0
//                   ? () async {
//                 final uid = FirebaseAuth.instance.currentUser!.uid;
//                 await BorrowService().borrowBook(
//                   userId: uid,
//                   bookId: book.id,
//                   bookTitle: book.title,
//                 );
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Borrow request sent')),
//                 );
//               }
//                   : null,
//               child: const Text('Borrow Book'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
