import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CurrentDonationsScreen extends StatelessWidget {
  const CurrentDonationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Current Donations'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildStatusFilter(),
          const SizedBox(height: 20),
          _buildDonationItem(
            context,
            'Hope Foundation',
            '15 meals, 3 desserts',
            'Today, 4:30 PM',
            'Scheduled',
            Colors.orange,
            'https://images.unsplash.com/photo-1606787366850-de6330128bfc?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
          ),
          _buildDonationItem(
            context,
            'Community Kitchen',
            '8 meals, 2 salads',
            'Tomorrow, 11:00 AM',
            'Confirmed',
            Colors.green,
            'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
          ),
          _buildDonationItem(
            context,
            'Street Angels',
            '20 sandwiches',
            'Pending confirmation',
            'Awaiting',
            Colors.grey,
            'https://images.unsplash.com/photo-1504674900247-0877df9cc836?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.add),
        onPressed: () {
          // Navigate to donation form
        },
      ),
    );
  }

  Widget _buildStatusFilter() {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip('All', true),
          _buildFilterChip('Scheduled', false),
          _buildFilterChip('Confirmed', false),
          _buildFilterChip('Awaiting', false),
          _buildFilterChip('Completed', false),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool selected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (bool value) {},
        selectedColor: Colors.blue,
        checkmarkColor: Colors.white,
        labelStyle: TextStyle(
          color: selected ? Colors.white : Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildDonationItem(
    BuildContext context,
    String ngoName,
    String foodItems,
    String pickupTime,
    String status,
    Color statusColor,
    String imageUrl,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          _showDonationDetails(context, ngoName, foodItems, pickupTime, status);
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // NGO Image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ngoName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(foodItems, style: TextStyle(color: Colors.grey[700])),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          pickupTime,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Action Button
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  _showActionMenu(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDonationDetails(
    BuildContext context,
    String ngoName,
    String foodItems,
    String pickupTime,
    String status,
  ) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Donation Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                _buildDetailRow('NGO', ngoName),
                _buildDetailRow('Food Items', foodItems),
                _buildDetailRow('Pickup Time', pickupTime),
                _buildDetailRow('Status', status),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  void _showActionMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Edit Donation'),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to edit screen
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.cancel),
                  title: const Text('Cancel Donation'),
                  onTap: () {
                    Navigator.pop(context);
                    // Show cancel confirmation
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.chat),
                  title: const Text('Message NGO'),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to chat
                  },
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
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
