import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Not logged in')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('User data not found'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final role = data['role'];
          final name = data['name'] ?? '';
          final email = data['email'] ?? '';
          final studentId = data['studentId'];

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),

                /// 👤 AVATAR
                CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.blue.shade100,
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.blue.shade700,
                  ),
                ),

                const SizedBox(height: 16),

                /// NAME
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                /// ROLE
                Chip(
                  label: Text(
                    role.toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor:
                  role == 'admin' ? Colors.red : Colors.green,
                ),

                const SizedBox(height: 30),

                /// INFO CARD
                _infoTile(Icons.email, 'Email', email),

                if (role == 'student')
                  _infoTile(Icons.badge, 'Student ID', studentId ?? '—'),

                _infoTile(
                  Icons.verified_user,
                  'Account Type',
                  role == 'admin' ? 'Administrator' : 'Student',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// 🔹 Info Row
  Widget _infoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Card(
        elevation: 2,
        child: ListTile(
          leading: Icon(icon, color: Colors.blue),
          title: Text(label),
          subtitle: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
