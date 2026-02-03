import 'package:flutter/material.dart';
import '../../models/borrow.dart';
import '../../services/borrow_service.dart';

class AdminStatistics extends StatelessWidget {
  const AdminStatistics({super.key});

  bool _isOverdue(Borrow b) {
    return b.approved &&
        !b.returned &&
        b.returnDate != null &&
        DateTime.now().isAfter(b.returnDate!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: StreamBuilder<List<Borrow>>(
        stream: BorrowService().getAllBorrows(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final borrows = snapshot.data!;

          /// 🔥 CHỈ LẤY BORROW ĐÃ DUYỆT
          final approvedBorrows =
          borrows.where((b) => b.approved).toList();

          if (approvedBorrows.isEmpty) {
            return const Center(
              child: Text(
                'No statistics available',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final total = approvedBorrows.length;

          final returned =
              approvedBorrows.where((b) => b.returned).length;

          final overdue =
              approvedBorrows.where(_isOverdue).length;

          final borrowing = approvedBorrows.where(
                (b) => !b.returned && !_isOverdue(b),
          ).length;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _StatCard('Total Borrows', total, Colors.blue),
                _StatCard('Borrowing', borrowing, Colors.orange),
                _StatCard('Overdue', overdue, Colors.red),
                _StatCard('Returned', returned, Colors.green),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final int value;
  final Color color;

  const _StatCard(this.title, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: color.withOpacity(0.1),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value.toString(),
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 8),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}
