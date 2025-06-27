import 'package:flutter/material.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

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
              'How do I create a new donation listing?',
              'To create a new donation, tap the + button on the home screen and fill in the details about the food you want to donate.',
            ),
            _buildFAQItem(
              'What types of food can I donate?',
              'You can donate any non-perishable food items and prepared foods that are still safe for consumption.',
            ),
            _buildFAQItem(
              'How are NGOs verified on the platform?',
              'All NGOs undergo a strict verification process including document checks and site visits before being approved.',
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
                      title: const Text('Email Us'),
                      subtitle: const Text('support@hungerzero.org'),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.phone,
                        color: Colors.deepOrange,
                      ),
                      title: const Text('Call Support'),
                      subtitle: const Text('+1 (800) 123-4567'),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.chat, color: Colors.deepOrange),
                      title: const Text('Live Chat'),
                      subtitle: const Text('Available 9AM-6PM, Mon-Fri'),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Resources Section
            const Text(
              'Helpful Resources',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildResourceChip('Getting Started Guide', Icons.book),
                _buildResourceChip('Video Tutorials', Icons.video_library),
                _buildResourceChip(
                  'Food Safety Guidelines',
                  Icons.health_and_safety,
                ),
                _buildResourceChip('Tax Benefits', Icons.monetization_on),
                _buildResourceChip('Community Forum', Icons.forum),
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
