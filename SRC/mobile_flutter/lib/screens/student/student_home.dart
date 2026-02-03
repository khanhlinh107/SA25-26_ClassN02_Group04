import 'package:flutter/material.dart';
import '../admin/admin_home_screen.dart';
import 'history_screen.dart';
import '../shared/profile_screen.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({super.key});

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  int index = 0;

  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();
    screens = const [
      /// 📚 BOOK HOME (DÙNG CHUNG VỚI ADMIN)
      AdminHomeScreen(isAdmin: false),

      /// 📜 HISTORY
      HistoryScreen(),

      /// 👤 PROFILE
      ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Books',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
