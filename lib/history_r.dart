import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DonationHistoryScreen extends StatefulWidget {
  const DonationHistoryScreen({super.key});

  @override
  State<DonationHistoryScreen> createState() => _DonationHistoryScreenState();
}

class _DonationHistoryScreenState extends State<DonationHistoryScreen> {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donation History'),
        backgroundColor: Colors.deepOrange,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => setState(() => _filter = value),
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: 'All',
                    child: Text('All Donations'),
                  ),
                  const PopupMenuItem(
                    value: 'Completed',
                    child: Text('Completed'),
                  ),
                  const PopupMenuItem(
                    value: 'Cancelled',
                    child: Text('Cancelled'),
                  ),
                ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search donations...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) => _buildDonationItem(index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonationItem(int index) {
    final status = index % 3 == 0 ? 'Completed' : 'Cancelled';
    final statusColor = status == 'Completed' ? Colors.green : Colors.red;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
            'https://randomuser.me/api/portraits/women/${(10 + index) % 99 + 1}.jpg',
          ),
        ),
        title: Text('Donation #${1000 + index}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'NGO: ${['Hope Foundation', 'Community Kitchen', 'Street Angels'][index % 3]}',
            ),
            Text(
              'Date: ${DateFormat('MMM dd, yyyy').format(DateTime.now().subtract(Duration(days: index * 2)))}',
            ),
            Text('Meals: ${5 + (index * 3)}'),
          ],
        ),
        trailing: Chip(
          label: Text(status),
          backgroundColor: statusColor.withOpacity(0.1),
          labelStyle: TextStyle(color: statusColor),
        ),
        onTap: () => _showDonationDetails(context, index),
      ),
    );
  }

  void _showDonationDetails(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Donation Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                _buildDetailRow('Donation ID', '#${1000 + index}'),
                _buildDetailRow(
                  'NGO',
                  [
                    'Hope Foundation',
                    'Community Kitchen',
                    'Street Angels',
                  ][index % 3],
                ),
                _buildDetailRow(
                  'Date',
                  DateFormat(
                    'MMM dd, yyyy - hh:mm a',
                  ).format(DateTime.now().subtract(Duration(days: index * 2))),
                ),
                _buildDetailRow(
                  'Items Donated',
                  '${5 + (index * 3)} meals, ${index % 2 + 1} desserts',
                ),
                _buildDetailRow(
                  'Pickup Time',
                  '${index % 12 + 1}:${index % 2 == 0 ? '00' : '30'} PM',
                ),
                _buildDetailRow(
                  'Status',
                  index % 3 == 0 ? 'Completed' : 'Cancelled',
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                    ),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}
