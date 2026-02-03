import 'package:flutter/material.dart';
import '../../models/book.dart';
import '../../services/book_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/borrow_service.dart';


class BookDetailDialog extends StatelessWidget {
  final Book book;
  final bool isAdmin;

  const BookDetailDialog({
    super.key,
    required this.book,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    final descCtrl = TextEditingController(text: book.description);
    final service = BookService();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              /// IMAGE
              Center(
                child: book.imageUrl.isNotEmpty
                    ? Image.network(book.imageUrl, height: 180)
                    : const Icon(Icons.book, size: 100),
              ),

              const SizedBox(height: 12),

              Text(
                book.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text('Author: ${book.author}'),
              Text('Category: ${book.category}'),
              Text('Available: ${book.available}/${book.quantity}'),

              const SizedBox(height: 12),

              /// DESCRIPTION
              isAdmin
                  ? TextField(
                controller: descCtrl,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              )
                  : Text(
                book.description.isEmpty
                    ? 'No description'
                    : book.description,
              ),

              const SizedBox(height: 16),

              /// ACTIONS
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),

                  /// ADMIN SAVE
                  if (isAdmin)
                    ElevatedButton(
                      onPressed: () async {
                        await service.updateBook(
                          book.copyWith(
                            description: descCtrl.text.trim(),
                          ),
                        );
                        Navigator.pop(context);
                      },
                      child: const Text('Save'),
                    ),

                  /// ADMIN DELETE
                  if (isAdmin)
                    const SizedBox(width: 8),

                  if (isAdmin)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () async {
                        final ok = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Delete book'),
                            content: const Text(
                                'Are you sure you want to delete this book?'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () =>
                                    Navigator.pop(context, true),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );

                        if (ok == true) {
                          await service.deleteBook(book.id);
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Delete'),
                    ),

                  /// STUDENT BORROW
                  if (!isAdmin && book.available > 0)
                    ElevatedButton(
                      onPressed: () async {
                        await BorrowService().borrowBook(
                          userId: FirebaseAuth.instance.currentUser!.uid,
                          bookId: book.id,
                          bookTitle: book.title,
                          categoryName: book.category,
                        );

                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Borrow request sent. Waiting for admin approval.'),
                          ),
                        );
                      },
                      child: const Text('Borrow'),
                    ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
