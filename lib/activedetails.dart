import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ActiveDetailsScreen extends StatelessWidget {
  final String requestId;
  final String donationId;
  final String restaurantId;

  const ActiveDetailsScreen({
    super.key,
    required this.requestId,
    required this.donationId,
    required this.restaurantId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donation Details'),
        backgroundColor: Colors.deepOrange,
      ),
      body: FutureBuilder(
        future: Future.wait([
          FirebaseFirestore.instance
              .collection('donations')
              .doc(donationId)
              .get(),
          FirebaseFirestore.instance
              .collection('restaurants')
              .doc(restaurantId)
              .get(),
          FirebaseFirestore.instance
              .collection('requests')
              .doc(requestId)
              .get(),
        ]),
        builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final donation = snapshot.data![0];
          final restaurant = snapshot.data![1];
          final request = snapshot.data![2];

          if (!donation.exists || !restaurant.exists || !request.exists) {
            return const Center(child: Text('Data not found'));
          }

          final donationData = donation.data() as Map<String, dynamic>;
          final restaurantData = restaurant.data() as Map<String, dynamic>;
          final requestData = request.data() as Map<String, dynamic>;

          final title = donationData['title'] ?? 'No Title';
          final quantity =
              "${donationData['quantity']} ${donationData['unit']}";
          final foodType = donationData['foodType'] ?? 'N/A';
          final allergens = donationData['allergens'] == true;
          final instructions = donationData['instructions'] ?? 'None';
          final pickupTime =
              requestData['pickupTime'] != null
                  ? DateFormat.yMMMMd().add_jm().format(
                    DateTime.parse(requestData['pickupTime']),
                  )
                  : 'Not specified';
          final restaurantName =
              restaurantData['restaurantName'] ?? 'Unknown Restaurant';
          final restaurantAddress = restaurantData['address'] ?? 'No address';
          final restaurantPhone = restaurantData['phone'] ?? 'No phone';
          final imageUrl =
              (donationData['imageURLs'] as List?)?.isNotEmpty == true
                  ? donationData['imageURLs'][0]
                  : 'https://via.placeholder.com/150';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Header
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Food Information
                _buildSectionTitle(context, 'Donation Details'),
                _buildDetailItem(Icons.fastfood, 'Food Item:', title),
                _buildDetailItem(Icons.numbers, 'Quantity:', quantity),
                _buildDetailItem(Icons.category, 'Food Type:', foodType),
                _buildDetailItem(Icons.schedule, 'Pickup Time:', pickupTime),
                if (allergens)
                  _buildDetailItem(
                    Icons.warning,
                    'Allergens:',
                    'May contain allergens',
                  ),
                _buildDetailItem(
                  Icons.note,
                  'Special Instructions:',
                  instructions,
                ),

                const SizedBox(height: 24),

                // Restaurant Info
                _buildSectionTitle(context, 'Restaurant Details'),
                _buildDetailItem(Icons.store, 'Restaurant:', restaurantName),
                _buildDetailItem(
                  Icons.location_on,
                  'Address:',
                  restaurantAddress,
                ),
                _buildDetailItem(Icons.phone, 'Phone:', restaurantPhone),

                const SizedBox(height: 32),

                // Mark as Completed Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => _markAsCompleted(context, requestId),
                    child: const Text(
                      'MARK AS COMPLETED',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _markAsCompleted(BuildContext context, String requestId) async {
    try {
      await FirebaseFirestore.instance
          .collection('requests')
          .doc(requestId)
          .update({
            'status': 'completed',
            'completedAt': FieldValue.serverTimestamp(),
          });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Donation marked as completed!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back after a short delay
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.deepOrange,
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.deepOrange),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
