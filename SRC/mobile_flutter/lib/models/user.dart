class AppUser {
  final String uid;
  final String email;
  final String role; // admin | student
  final String name;
  final String? studentId; // null nếu là admin

  AppUser({
    required this.uid,
    required this.email,
    required this.role,
    required this.name,
    this.studentId,
  });

  /// 🔄 FROM FIRESTORE
  factory AppUser.fromMap(Map<String, dynamic> data) {
    return AppUser(
      uid: data['uid'],
      email: data['email'],
      role: data['role'],
      name: data['name'] ?? '',
      studentId: data['studentId'], // có thể null
    );
  }

  /// ⬆️ TO FIRESTORE
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role,
      'name': name,
      'studentId': studentId,
    };
  }
}
