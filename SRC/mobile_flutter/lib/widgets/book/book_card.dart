import 'package:flutter/material.dart';
import '../../models/book.dart';
import '../../services/book_service.dart';
import 'book_detail_dialog.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final bool isAdmin;

  const BookCard({
    super.key,
    required this.book,
    required this.isAdmin,
  });

  void _openDetail(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => BookDetailDialog(
        book: book,
        isAdmin: isAdmin,
      ),
    );
  }

  void _deleteBook(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete book'),
        content: Text('Are you sure you want to delete "${book.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await BookService().deleteBook(book.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE (tap mở detail)
          GestureDetector(
            onTap: () => _openDetail(context),
            child: Container(
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[200],
                image: book.imageUrl.isNotEmpty
                    ? DecorationImage(
                  image: NetworkImage(book.imageUrl),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
              child: book.imageUrl.isEmpty
                  ? const Icon(Icons.book, size: 48)
                  : null,
            ),
          ),

          const SizedBox(height: 6),

          /// TITLE
          Text(
            book.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),

          /// AUTHOR
          Text(
            book.author,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),

          const SizedBox(height: 4),

          /// AVAILABLE
          Text(
            'Available: ${book.available}/${book.quantity}',
            style: TextStyle(
              fontSize: 12,
              color: book.available > 0 ? Colors.green : Colors.red,
            ),
          ),

          /// ADMIN ACTIONS
          if (isAdmin)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  /// ✏️ EDIT
                  GestureDetector(
                    onTap: () => _openDetail(context),
                    child: const Icon(Icons.edit, size: 16),
                  ),

                  const SizedBox(width: 12),

                  /// 🗑 DELETE
                  GestureDetector(
                    onTap: () => _deleteBook(context),
                    child: const Icon(Icons.delete, size: 16, color: Colors.red),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
