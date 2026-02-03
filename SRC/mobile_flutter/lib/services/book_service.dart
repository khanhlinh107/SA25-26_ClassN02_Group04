import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book.dart';

class BookService {
  final _ref = FirebaseFirestore.instance.collection('books');

  /* =======================
     📚 Lấy danh sách sách
     ======================= */
  Stream<List<Book>> getBooks() {
    return _ref.snapshots().map(
          (snap) => snap.docs
          .map((d) => Book.fromMap(d.id, d.data()))
          .toList(),
    );
  }

  /* =======================
     ➕ ADMIN thêm sách (tay)
     ======================= */
  Future<void> addBook(Book book) {
    return _ref.add({
      'title': book.title,
      'author': book.author,
      'category': book.category,
      'quantity': book.quantity,
      'available': book.quantity,
      'borrowCount': 0,
      'imageUrl': book.imageUrl,
      'description': book.description,
    });
  }

  /* =======================
     🔄 IMPORT sách (API / +)
     ======================= */
  Future<void> importBook(Book book) async {
    final query = await _ref
        .where('title', isEqualTo: book.title)
        .where('author', isEqualTo: book.author)
        .limit(1)
        .get();

    // ✅ ĐÃ TỒN TẠI → tăng số lượng
    if (query.docs.isNotEmpty) {
      final doc = query.docs.first;

      await _ref.doc(doc.id).update({
        'quantity': FieldValue.increment(1),
        'available': FieldValue.increment(1),
      });
    }
    // ❌ CHƯA CÓ → thêm mới
    else {
      await _ref.add({
        'title': book.title,
        'author': book.author,
        'category': book.category,
        'quantity': 1,
        'available': 1,
        'borrowCount': 0,
        'imageUrl': book.imageUrl,
        'description': book.description,
      });
    }
  }

  /* =======================
     ✏️ ADMIN sửa sách
     ======================= */
  Future<void> updateBook(Book book) {
    return _ref.doc(book.id).update({
      'title': book.title,
      'author': book.author,
      'category': book.category,
      'quantity': book.quantity,
      'imageUrl': book.imageUrl,
      'description': book.description,
    });
  }

  /* =======================
     🗑 ADMIN xoá sách
     ======================= */
  Future<void> deleteBook(String id) {
    return _ref.doc(id).delete();
  }

  /* =======================
     📉 MƯỢN SÁCH (đã duyệt)
     ======================= */
  Future<void> borrowBook(String bookId) async {
    final docRef = _ref.doc(bookId);

    await FirebaseFirestore.instance.runTransaction((tx) async {
      final snap = await tx.get(docRef);
      final data = snap.data()!;

      final int available = data['available'];

      if (available <= 0) {
        throw Exception('No available books');
      }

      tx.update(docRef, {
        'available': FieldValue.increment(-1),
        'borrowCount': FieldValue.increment(1), // ✅ CHỈ tăng ở đây
      });
    });
  }

  /* =======================
     📈 TRẢ SÁCH
     ======================= */
  Future<void> returnBook(String bookId) async {
    final docRef = _ref.doc(bookId);

    await FirebaseFirestore.instance.runTransaction((tx) async {
      final snap = await tx.get(docRef);
      final data = snap.data()!;

      final int available = data['available'];
      final int quantity = data['quantity'];

      if (available < quantity) {
        tx.update(docRef, {
          'available': FieldValue.increment(1),
        });
      }
    });
  }

  /* =======================
     🏆 TOP sách mượn nhiều
     ======================= */
  Stream<List<Book>> getTopBorrowedBooks() {
    return _ref
        .orderBy('borrowCount', descending: true)
        .limit(3)
        .snapshots()
        .map(
          (snap) => snap.docs
          .map((d) => Book.fromMap(d.id, d.data()))
          .toList(),
    );
  }
}
