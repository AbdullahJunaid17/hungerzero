import 'package:flutter/material.dart';

class NGOVolunteersScreen extends StatefulWidget {
  const NGOVolunteersScreen({super.key});

  @override
  State<NGOVolunteersScreen> createState() => _NGOVolunteersScreenState();
}

class _NGOVolunteersScreenState extends State<NGOVolunteersScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Volunteers Management'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 0, label: Text('Active')),
                ButtonSegment(value: 1, label: Text('Pending')),
                ButtonSegment(value: 2, label: Text('All')),
              ],
              selected: {_selectedTab},
              onSelectionChanged: (Set<int> newSelection) {
                setState(() => _selectedTab = newSelection.first);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount:
                  _selectedTab == 0
                      ? 5
                      : _selectedTab == 1
                      ? 3
                      : 8,
              itemBuilder: (context, index) => _buildVolunteerCard(index),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.person_add),
        onPressed: () => _showAddVolunteerDialog(context),
      ),
    );
  }

  Widget _buildVolunteerCard(int index) {
    final status =
        _selectedTab == 0
            ? 'Active'
            : _selectedTab == 1
            ? 'Pending'
            : index % 3 == 0
            ? 'Pending'
            : 'Active';
    final statusColor = status == 'Active' ? Colors.green : Colors.orange;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
            'https://randomuser.me/api/portraits/men/${index + 10}.jpg',
          ),
        ),
        title: Text(
          [
            'Alice',
            'Bob',
            'Charlie',
            'Diana',
            'Eve',
            'Frank',
            'Grace',
            'Henry',
          ][index % 8],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              ['Driver', 'Packager', 'Coordinator', 'Cook', 'Delivery'][index %
                  5],
            ),
            Text(
              'Joined ${['1 month', '2 weeks', '3 months', '6 days', '1 year'][index % 5]} ago',
            ),
          ],
        ),
        trailing: Chip(
          label: Text(status),
          backgroundColor: statusColor.withOpacity(0.1),
          labelStyle: TextStyle(color: statusColor),
        ),
        onTap: () => _showVolunteerDetails(context, index),
      ),
    );
  }

  void _showVolunteerDetails(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                      'https://randomuser.me/api/portraits/men/${10 + index}.jpg',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'Volunteer Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(),
                _buildDetailRow(
                  'Name',
                  [
                    'Alice',
                    'Bob',
                    'Charlie',
                    'Diana',
                    'Eve',
                    'Frank',
                    'Grace',
                    'Henry',
                  ][index % 8],
                ),
                _buildDetailRow(
                  'Role',
                  [
                    'Driver',
                    'Packager',
                    'Coordinator',
                    'Cook',
                    'Delivery',
                  ][index % 5],
                ),
                _buildDetailRow(
                  'Contact',
                  '+1 555-01${index.toString().padLeft(2, '0')}',
                ),
                _buildDetailRow(
                  'Status',
                  _selectedTab == 0
                      ? 'Active'
                      : _selectedTab == 1
                      ? 'Pending'
                      : index % 3 == 0
                      ? 'Pending'
                      : 'Active',
                ),
                _buildDetailRow('Completed Pickups', '${index * 3 + 5}'),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Message'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Volunteer status updated'),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                        ),
                        child: Text(
                          _selectedTab == 0 ? 'Deactivate' : 'Approve',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }

  void _showAddVolunteerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add New Volunteer'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Full Name'),
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Phone'),
                  keyboardType: TextInputType.phone,
                ),
                DropdownButtonFormField(
                  items:
                      ['Driver', 'Packager', 'Coordinator', 'Cook', 'Delivery']
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                  decoration: const InputDecoration(labelText: 'Role'),
                  onChanged: (value) {},
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Volunteer invitation sent')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                ),
                child: const Text('Invite'),
              ),
            ],
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
