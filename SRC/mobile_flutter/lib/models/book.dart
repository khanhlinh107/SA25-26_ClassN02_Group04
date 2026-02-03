class Book {
  final String id;
  final String title;
  final String author;
  final String category;
  final int quantity;
  final int available;
  final String imageUrl;
  final String description;
  final int borrowCount;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.quantity,
    required this.available,
    required this.imageUrl,
    required this.description,
    required this.borrowCount,
  });

  /// 🔄 FROM FIRESTORE
  factory Book.fromMap(String id, Map<String, dynamic> data) {
    return Book(
      id: id,
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      category: data['category'] ?? '',
      quantity: data['quantity'] ?? 0,
      available: data['available'] ?? data['quantity'] ?? 0,
      imageUrl: data['imageUrl'] ?? '',
      description: data['description'] ?? '',
      borrowCount: data['borrowCount'] ?? 0,
    );
  }

  /// 🆕 CREATE (API / ADD BOOK)
  factory Book.create({
    required String title,
    required String author,
    required String category,
    required int quantity,
    String imageUrl = '',
    String description = '',
    int borrowCount = 0,
  }) {
    return Book(
      id: '',
      title: title,
      author: author,
      category: category,
      quantity: quantity,
      available: quantity,
      imageUrl: imageUrl,
      description: description,
      borrowCount: borrowCount,
    );
  }

  /// ⬆️ TO FIRESTORE
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'category': category,
      'quantity': quantity,
      'available': available,
      'imageUrl': imageUrl,
      'description': description,
      'borrowCount': borrowCount,
    };
  }

  /// ✏️ COPY WITH
  Book copyWith({
    String? title,
    String? author,
    String? category,
    int? quantity,
    int? available,
    String? imageUrl,
    String? description,
    int? borrowCount,
  }) {
    return Book(
      id: id,
      title: title ?? this.title,
      author: author ?? this.author,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      available: available ?? this.available,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      borrowCount: borrowCount ?? this.borrowCount,
    );
  }
}
