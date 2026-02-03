import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/borrow.dart';

class BorrowService {
  final _borrowRef = FirebaseFirestore.instance.collection('borrows');
  final _bookRef = FirebaseFirestore.instance.collection('books');

  /* =======================
     STUDENT: gửi yêu cầu mượn
     ======================= */
  Future<void> borrowBook({
    required String userId,
    required String bookId,
    required String bookTitle,
    required String categoryName,
  }) async {
    final now = DateTime.now();

    await _borrowRef.add({
      'userId': userId,
      'bookId': bookId,
      'bookTitle': bookTitle,
      'categoryName': categoryName,

      'createdAt': Timestamp.fromDate(now),

      // chưa mượn thật
      'borrowDate': null,
      'returnDate': null,

      'approved': false,
      'returned': false,
    });
  }

  /* =======================
     ADMIN: xem tất cả borrow
     ======================= */
  Stream<List<Borrow>> getAllBorrows() {
    return _borrowRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (s) => s.docs
          .map((d) => Borrow.fromMap(d.id, d.data()))
          .toList(),
    );
  }

  /* =======================
     STUDENT: lịch sử mượn
     ======================= */
  Stream<List<Borrow>> getUserBorrows(String uid) {
    return _borrowRef
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (s) => s.docs
          .map((d) => Borrow.fromMap(d.id, d.data()))
          .toList(),
    );
  }

  /* =======================
     ADMIN: duyệt mượn ✅ FIX
     ======================= */
  Future<void> approveBorrow(Borrow b) async {
    if (b.approved) return;

    final bookDoc = _bookRef.doc(b.bookId);
    final borrowDoc = _borrowRef.doc(b.id);

    await FirebaseFirestore.instance.runTransaction((tx) async {
      final bookSnap = await tx.get(bookDoc);
      final data = bookSnap.data()!;

      final int available = data['available'];
      if (available <= 0) {
        throw Exception('No available books');
      }

      final now = DateTime.now();

      // ✅ TRỪ SÁCH + TĂNG borrowCount
      tx.update(bookDoc, {
        'available': FieldValue.increment(-1),
        'borrowCount': FieldValue.increment(1),
      });

      // ✅ DUYỆT BORROW
      tx.update(borrowDoc, {
        'approved': true,
        'borrowDate': Timestamp.fromDate(now),
        'returnDate': Timestamp.fromDate(
          now.add(const Duration(days: 7)),
        ),
      });
    });
  }

  /* =======================
     TRẢ SÁCH
     ======================= */
  Future<void> returnBook(Borrow b) async {
    if (!b.approved || b.returned) return;

    final bookDoc = _bookRef.doc(b.bookId);
    final borrowDoc = _borrowRef.doc(b.id);

    await FirebaseFirestore.instance.runTransaction((tx) async {
      final bookSnap = await tx.get(bookDoc);
      final data = bookSnap.data()!;

      final int available = data['available'];
      final int quantity = data['quantity'];

      if (available >= quantity) {
        throw Exception('Available exceeds quantity');
      }

      tx.update(bookDoc, {
        'available': FieldValue.increment(1),
      });

      tx.update(borrowDoc, {
        'returned': true,
      });
    });
  }

  /* =======================
     ADMIN: xoá borrow
     ======================= */
  Future<void> deleteBorrow(String borrowId) {
    return _borrowRef.doc(borrowId).delete();
  }
}
