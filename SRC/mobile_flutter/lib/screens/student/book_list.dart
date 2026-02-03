// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../../models/book.dart';
// import '../../services/book_service.dart';
// import '../../services/borrow_service.dart';
// import '../../widgets/book/book_card.dart';
//
// class BookListScreen extends StatefulWidget {
//   const BookListScreen({super.key});
//
//   @override
//   State<BookListScreen> createState() => _BookListScreenState();
// }
//
// class _BookListScreenState extends State<BookListScreen> {
//   String keyword = '';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Library'),
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(56),
//           child: Padding(
//             padding: const EdgeInsets.all(8),
//             child: TextField(
//               decoration: const InputDecoration(
//                 hintText: 'Search book...',
//                 filled: true,
//                 prefixIcon: Icon(Icons.search),
//               ),
//               onChanged: (v) => setState(() => keyword = v.toLowerCase()),
//             ),
//           ),
//         ),
//       ),
//       body: StreamBuilder<List<Book>>(
//         stream: BookService().getBooks(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           final books = snapshot.data!
//               .where((b) =>
//           b.title.toLowerCase().contains(keyword) ||
//               b.author.toLowerCase().contains(keyword))
//               .toList();
//
//           return ListView.builder(
//             itemCount: books.length,
//             itemBuilder: (_, i) {
//               final book = books[i];
//               return BookCard(
//                 book: book,
//                 onBorrow: () async {
//                   await BorrowService().borrowBook(
//                     userId: FirebaseAuth.instance.currentUser!.uid,
//                     bookId: book.id,
//                     bookTitle: book.title,
//                   );
//
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Borrow request sent, waiting for approval'),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
