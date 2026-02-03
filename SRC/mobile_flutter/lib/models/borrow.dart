import 'package:cloud_firestore/cloud_firestore.dart';

class Borrow {
  final String id;
  final String userId;
  final String bookId;
  final String bookTitle;
  final String categoryName;

  final DateTime createdAt;
  final DateTime? borrowDate;   // ✅ NULLABLE
  final DateTime? returnDate;   // ✅ NULLABLE

  final bool approved;
  final bool returned;

  Borrow({
    required this.id,
    required this.userId,
    required this.bookId,
    required this.bookTitle,
    required this.categoryName,
    required this.createdAt,
    this.borrowDate,
    this.returnDate,
    required this.approved,
    required this.returned,
  });

  factory Borrow.fromMap(String id, Map<String, dynamic> data) {
    return Borrow(
      id: id,
      userId: data['userId'],
      bookId: data['bookId'],
      bookTitle: data['bookTitle'],
      categoryName: data['categoryName'] ?? 'Unknown',

      createdAt: (data['createdAt'] as Timestamp).toDate(),

      // ✅ CHECK NULL
      borrowDate: data['borrowDate'] != null
          ? (data['borrowDate'] as Timestamp).toDate()
          : null,

      returnDate: data['returnDate'] != null
          ? (data['returnDate'] as Timestamp).toDate()
          : null,

      approved: data['approved'] ?? false,
      returned: data['returned'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'bookId': bookId,
      'bookTitle': bookTitle,
      'categoryName': categoryName,
      'createdAt': Timestamp.fromDate(createdAt),

      // ✅ CHỈ LƯU KHI CÓ
      'borrowDate': borrowDate != null
          ? Timestamp.fromDate(borrowDate!)
          : null,

      'returnDate': returnDate != null
          ? Timestamp.fromDate(returnDate!)
          : null,

      'approved': approved,
      'returned': returned,
    };
  }
}
