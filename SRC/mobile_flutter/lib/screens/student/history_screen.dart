import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/borrow.dart';
import '../../services/borrow_service.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  // ================= LOGIC =================

  bool _isOverdue(Borrow b) {
    return b.approved &&
        !b.returned &&
        b.returnDate != null &&
        DateTime.now().isAfter(b.returnDate!);
  }

  String _statusText(Borrow b) {
    if (!b.approved) return 'Pending';
    if (b.returned) return 'Returned';
    if (_isOverdue(b)) return 'Overdue';
    return 'Borrowing';
  }

  Color _statusColor(Borrow b) {
    if (!b.approved) return Colors.orange;
    if (b.returned) return Colors.green;
    if (_isOverdue(b)) return Colors.red;
    return Colors.blue;
  }

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/'
          '${d.month.toString().padLeft(2, '0')}/'
          '${d.year}';

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final service = BorrowService();

    return Scaffold(
      appBar: AppBar(title: const Text('Borrow History')),
      body: StreamBuilder<List<Borrow>>(
        stream: service.getUserBorrows(uid),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snap.hasData || snap.data!.isEmpty) {
            return const Center(child: Text('No borrow history'));
          }

          final borrows = snap.data!;

          return ListView.builder(
            itemCount: borrows.length,
            itemBuilder: (_, i) {
              final b = borrows[i];
              final overdue = _isOverdue(b);

              return Card(
                margin:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                color: overdue ? Colors.red.shade50 : null,
                child: ListTile(
                  title: Text(
                    b.bookTitle,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),

                      /// STATUS
                      Text(
                        'Status: ${_statusText(b)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _statusColor(b),
                        ),
                      ),

                      const SizedBox(height: 4),

                      /// REQUEST DATE
                      Text('Requested: ${_fmt(b.createdAt)}'),

                      /// BORROW DATE (NẾU ĐƯỢC DUYỆT)
                      if (b.borrowDate != null)
                        Text('Borrowed: ${_fmt(b.borrowDate!)}'),

                      /// RETURN DATE
                      if (b.returnDate != null)
                        Text('Return: ${_fmt(b.returnDate!)}'),

                      if (overdue)
                        const Text(
                          'OVERDUE',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),

                  trailing: Icon(
                    b.returned
                        ? Icons.check_circle
                        : b.approved
                        ? Icons.menu_book
                        : Icons.hourglass_top,
                    color: _statusColor(b),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
