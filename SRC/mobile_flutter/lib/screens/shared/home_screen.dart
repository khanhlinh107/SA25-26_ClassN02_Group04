// import 'package:flutter/material.dart';
// import '../../widgets/bottom_nav.dart';
// import '../student/book_list.dart';
// import '../student/history_screen.dart';
// import 'profile_screen.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   int _index = 0;
//
//   final List<Widget> _pages = const [
//     Center(child: Text('Library Home')),
//     BookListScreen(),
//     HistoryScreen(),
//     ProfileScreen(),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: AnimatedSwitcher(
//         duration: const Duration(milliseconds: 400),
//         child: _pages[_index],
//       ),
//       bottomNavigationBar: BottomNav(
//         currentIndex: _index,
//         onTap: (i) => setState(() => _index = i),
//       ),
//     );
//   }
// }
