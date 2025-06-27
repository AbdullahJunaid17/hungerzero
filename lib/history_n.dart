import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NGOPickupHistoryScreen extends StatefulWidget {
  const NGOPickupHistoryScreen({super.key});

  @override
  State<NGOPickupHistoryScreen> createState() => _NGOPickupHistoryScreenState();
}

class _NGOPickupHistoryScreenState extends State<NGOPickupHistoryScreen> {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pickup History'),
        backgroundColor: Colors.deepOrange,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => setState(() => _filter = value),
            itemBuilder:
                (context) => [
                  const PopupMenuItem(value: 'All', child: Text('All Pickups')),
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
                hintText: 'Search pickups...',
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
              itemBuilder: (context, index) => _buildPickupItem(index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickupItem(int index) {
    final status = index % 5 == 0 ? 'Cancelled' : 'Completed';
    final statusColor = status == 'Completed' ? Colors.green : Colors.red;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
            'https://randomuser.me/api/portraits/women/${10 + index}.jpg',
          ),
        ),
        title: Text('Pickup #${2000 + index}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'Restaurant: ${['Bistro Central', 'Grand Hotel', 'Pizza Heaven'][index % 3]}',
            ),
            Text(
              'Date: ${DateFormat('MMM dd, yyyy').format(DateTime.now().subtract(Duration(days: index * 2)))}',
            ),
            Text('Meals: ${15 + (index * 5)}'),
          ],
        ),
        trailing: Chip(
          label: Text(status),
          backgroundColor: statusColor.withOpacity(0.1),
          labelStyle: TextStyle(color: statusColor),
        ),
        onTap: () => _showPickupDetails(context, index),
      ),
    );
  }

  void _showPickupDetails(BuildContext context, int index) {
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
                  'Pickup Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                _buildDetailRow('Pickup ID', '#${2000 + index}'),
                _buildDetailRow(
                  'Restaurant',
                  ['Bistro Central', 'Grand Hotel', 'Pizza Heaven'][index % 3],
                ),
                _buildDetailRow(
                  'Date',
                  DateFormat(
                    'MMM dd, yyyy - hh:mm a',
                  ).format(DateTime.now().subtract(Duration(days: index * 2))),
                ),
                _buildDetailRow(
                  'Items Collected',
                  '${15 + (index * 5)} meals, ${index % 2 + 1} desserts',
                ),
                _buildDetailRow(
                  'Collected By',
                  'Volunteer ${['Alice', 'Bob', 'Charlie'][index % 3]}',
                ),
                _buildDetailRow(
                  'Status',
                  index % 5 == 0 ? 'Cancelled' : 'Completed',
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
