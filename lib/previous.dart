import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PreviousDonationsScreen extends StatelessWidget {
  const PreviousDonationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Previous Donations'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          // Month Selector
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {},
                ),
                const Text(
                  'June 2023',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          // Stats Cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildStatCard('24', 'Donations'),
                const SizedBox(width: 10),
                _buildStatCard('180', 'Meals'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Donations List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildDonationItem(
                  'Hope Foundation',
                  '15 meals',
                  'June 15, 2023',
                  'Completed',
                  Colors.green,
                  'https://images.unsplash.com/photo-1606787366850-de6330128bfc?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
                ),
                _buildDonationItem(
                  'Community Kitchen',
                  '8 meals',
                  'June 10, 2023',
                  'Completed',
                  Colors.green,
                  'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
                ),
                _buildDonationItem(
                  'Street Angels',
                  '20 sandwiches',
                  'June 5, 2023',
                  'Cancelled',
                  Colors.red,
                  'https://images.unsplash.com/photo-1504674900247-0877df9cc836?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              Text(label, style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDonationItem(
    String ngoName,
    String foodItems,
    String date,
    String status,
    Color statusColor,
    String imageUrl,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
        title: Text(ngoName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text(foodItems), Text(date)],
        ),
        trailing: Chip(
          label: Text(status),
          backgroundColor: statusColor.withOpacity(0.1),
          labelStyle: TextStyle(color: statusColor),
        ),
      ),
    );
  }
}
