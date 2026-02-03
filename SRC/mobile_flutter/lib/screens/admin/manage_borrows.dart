import 'package:flutter/material.dart';
import '../../models/borrow.dart';
import '../../services/borrow_service.dart';

class ManageBorrows extends StatelessWidget {
  const ManageBorrows({super.key});

  @override
  Widget build(BuildContext context) {
    final service = BorrowService();

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Borrows')),
      body: StreamBuilder<List<Borrow>>(
        stream: service.getAllBorrows(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snap.hasData || snap.data!.isEmpty) {
            return const Center(child: Text('No borrow records'));
          }

          final borrows = snap.data!;

          return ListView.builder(
            itemCount: borrows.length,
            itemBuilder: (context, i) {
              final b = borrows[i];

              final overdue =
                  b.approved &&
                      !b.returned &&
                      b.returnDate != null &&
                      DateTime.now().isAfter(b.returnDate!);

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

                      /// CATEGORY
                      Text(
                        'Category: ${b.categoryName}',
                        style:
                        const TextStyle(fontStyle: FontStyle.italic),
                      ),

                      Text('User ID: ${b.userId}'),

                      /// REQUEST TIME
                      Text('Requested: ${_fmt(b.createdAt)}'),

                      /// BORROW INFO (CHỈ HIỆN KHI CÓ)
                      if (b.borrowDate != null)
                        Text('Borrow: ${_fmt(b.borrowDate!)}'),

                      if (b.returnDate != null)
                        Text('Return: ${_fmt(b.returnDate!)}'),

                      const SizedBox(height: 4),

                      /// STATUS
                      Text(
                        'Status: ${_statusText(b)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _statusColor(b),
                        ),
                      ),

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

                  trailing: Wrap(
                    spacing: 8,
                    children: [
                      /// APPROVE
                      if (!b.approved)
                        IconButton(
                          icon: const Icon(Icons.check,
                              color: Colors.green),
                          onPressed: () async {
                            try {
                              await service.approveBorrow(b);
                            } catch (e) {
                              _showError(context, e.toString());
                            }
                          },
                        ),

                      /// RETURN
                      if (b.approved && !b.returned)
                        IconButton(
                          icon: const Icon(Icons.assignment_return,
                              color: Colors.blue),
                          onPressed: () async {
                            try {
                              await service.returnBook(b);
                            } catch (e) {
                              _showError(context, e.toString());
                            }
                          },
                        ),

                      /// DELETE
                      IconButton(
                        icon: const Icon(Icons.delete,
                            color: Colors.red),
                        onPressed: () async {
                          final ok =
                          await _confirmDelete(context);
                          if (ok) {
                            await service.deleteBorrow(b.id);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // ================= HELPERS =================

  static String _fmt(DateTime d) =>
      d.toLocal().toString().split(' ')[0];

  static String _statusText(Borrow b) {
    if (!b.approved) return 'Pending';
    if (b.returned) return 'Returned';
    return 'Borrowing';
  }

  static Color _statusColor(Borrow b) {
    if (!b.approved) return Colors.orange;
    if (b.returned) return Colors.green;
    return Colors.blue;
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete record'),
        content: const Text(
            'Are you sure you want to delete this record?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    ) ??
        false;
  }

  void _showError(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }
}
