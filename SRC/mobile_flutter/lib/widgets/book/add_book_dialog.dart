import 'package:flutter/material.dart';
import '../../models/book.dart';
import '../../services/book_service.dart';

class AddBookDialog extends StatefulWidget {
  const AddBookDialog({super.key});

  @override
  State<AddBookDialog> createState() => _AddBookDialogState();
}

class _AddBookDialogState extends State<AddBookDialog> {
  final _formKey = GlobalKey<FormState>();

  final _titleCtrl = TextEditingController();
  final _authorCtrl = TextEditingController();
  final _categoryCtrl = TextEditingController();
  final _quantityCtrl = TextEditingController();
  final _imageUrlCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _authorCtrl.dispose();
    _categoryCtrl.dispose();
    _quantityCtrl.dispose();
    _imageUrlCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveBook() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final book = Book.create(
      title: _titleCtrl.text.trim(),
      author: _authorCtrl.text.trim(),
      category: _categoryCtrl.text.trim(),
      quantity: int.parse(_quantityCtrl.text),
      imageUrl: _imageUrlCtrl.text.trim(),
      description: _descriptionCtrl.text.trim(),
    );

    await BookService().addBook(book);

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add New Book',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              _field(_titleCtrl, 'Title'),
              _field(_authorCtrl, 'Author'),
              _field(_categoryCtrl, 'Category'),

              _field(
                _quantityCtrl,
                'Quantity',
                keyboard: TextInputType.number,
              ),

              _field(_imageUrlCtrl, 'Image URL'),

              _field(
                _descriptionCtrl,
                'Description',
                maxLines: 3,
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _loading
                        ? null
                        : () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _loading ? null : _saveBook,
                    child: _loading
                        ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(
      TextEditingController controller,
      String label, {
        int maxLines = 1,
        TextInputType keyboard = TextInputType.text,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboard,
        validator: (v) =>
        v == null || v.trim().isEmpty ? 'Required' : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
