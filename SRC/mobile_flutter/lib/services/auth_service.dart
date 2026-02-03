import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  /* =======================
     REGISTER
     ======================= */
  Future<void> register({
    required String email,
    required String password,
    required String role,
    required String name,
    String? studentId, // chỉ có với student
  }) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = userCredential.user!.uid;

    await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'email': email,
      'name': name,
      'role': role,
      'studentId': role == 'student' ? studentId : null,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /* =======================
     LOGIN
     ======================= */
  Future<User?> login(String email, String password) async {
    final res = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return res.user;
  }

  /* =======================
     GET USER INFO
     ======================= */
  Future<Map<String, dynamic>> getUserInfo(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data()!;
  }

  Future<String> getUserRole(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc['role'];
  }

  /* =======================
     LOGOUT
     ======================= */
  Future<void> logout() async {
    await _auth.signOut();
  }
}
