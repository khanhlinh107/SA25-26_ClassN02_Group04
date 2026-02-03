import 'package:flutter/material.dart';
import '../../models/book.dart';

class TopBorrowedBooks extends StatelessWidget {
  final List<Book> books;

  const TopBorrowedBooks({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          final rank = index + 1;

          return Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Stack(
              children: [
                Container(
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: book.imageUrl.isNotEmpty
                          ? NetworkImage(book.imageUrl)
                          : const AssetImage('assets/book_placeholder.png')
                      as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                /// 🏆 TOP BADGE
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'TOP $rank',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
