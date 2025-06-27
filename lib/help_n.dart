import 'package:flutter/material.dart';

class NGOHelpCenterScreen extends StatelessWidget {
  const NGOHelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Center'),
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search help articles...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // FAQ Section
            const Text(
              'Frequently Asked Questions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildFAQItem(
              'How do I schedule a pickup?',
              'Tap on the donation listing you want to collect, then select "Request Pickup" and choose your preferred time.',
            ),
            _buildFAQItem(
              'What if I need to cancel a pickup?',
              'Go to your scheduled pickups, select the one you want to cancel, and tap "Cancel Pickup". Please provide a reason.',
            ),
            _buildFAQItem(
              'How are restaurants verified?',
              'All restaurants undergo food safety checks and document verification before joining our platform.',
            ),
            const SizedBox(height: 20),

            // Contact Section
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Need More Help?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      leading: const Icon(
                        Icons.email,
                        color: Colors.deepOrange,
                      ),
                      title: const Text('Email Support'),
                      subtitle: const Text('ngo-support@hungerzero.org'),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.phone,
                        color: Colors.deepOrange,
                      ),
                      title: const Text('Call NGO Helpline'),
                      subtitle: const Text('+1 (800) 987-6543'),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.chat, color: Colors.deepOrange),
                      title: const Text('Live Chat'),
                      subtitle: const Text('Available 8AM-8PM, Mon-Sat'),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Resources Section
            const Text(
              'NGO Resources',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildResourceChip(
                  'Food Safety Guide',
                  Icons.health_and_safety,
                ),
                _buildResourceChip(
                  'Pickup Best Practices',
                  Icons.local_shipping,
                ),
                _buildResourceChip('Volunteer Handbook', Icons.people),
                _buildResourceChip('Tax Documentation', Icons.receipt),
                _buildResourceChip('Impact Reporting', Icons.analytics),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(answer),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceChip(String label, IconData icon) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: () {},
    );
  }
}
