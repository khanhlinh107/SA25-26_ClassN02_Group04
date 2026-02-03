import 'package:flutter/material.dart';
import '../../models/book.dart';
import 'book_card.dart';

class BookSection extends StatelessWidget {
  final String category;
  final List<Book> books;
  final bool isAdmin;

  const BookSection({
    super.key,
    required this.category,
    required this.books,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// CATEGORY TITLE
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              category,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 8),

          /// 🔥 BOOK LIST (HORIZONTAL)
          SizedBox(
            height: 260, // ⚠️ BẮT BUỘC
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: books.length,
              itemBuilder: (context, index) {
                return BookCard(
                  book: books[index],
                  isAdmin: isAdmin,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
