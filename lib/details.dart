import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:hungerzero/chat.dart';
import 'package:hungerzero/requestform.dart';

class NGODonationDetailsPage extends StatelessWidget {
  final String donationId;
  final String restaurantId;
  final String imageUrl;

  const NGODonationDetailsPage({
    Key? key,
    required this.donationId,
    required this.restaurantId,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final donationRef = FirebaseFirestore.instance
        .collection('donations')
        .doc(donationId);
    final restaurantRef = FirebaseFirestore.instance
        .collection('restaurants')
        .doc(restaurantId);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Donation Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepOrange,
        leading: BackButton(color: Colors.white),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: donationRef.get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          final title = data['title'] ?? 'No Title';
          final quantity = "${data['quantity']} ${data['unit']}";
          final foodType = data['foodType'] ?? 'N/A';
          final allergens = data['allergens'] == true;
          final preparedAt =
              data['preparedAt'] != null
                  ? DateFormat.yMMMMd().add_jm().format(
                    DateTime.parse(data['preparedAt']),
                  )
                  : 'Not specified';

          final instructions = data['instructions'] ?? 'None';
          final pickupTime =
              data['pickup'] != null
                  ? DateFormat.yMMMMd().add_jm().format(
                    DateTime.parse(data['pickup']),
                  )
                  : 'Not specified';
          final restaurantName = data['restaurantName'] ?? 'Unknown Restaurant';
          final restaurantAddress = data['restaurantAddress'] ?? 'No address';
          final posted =
              data['posted'] != null
                  ? DateFormat.yMMMMd().add_jm().format(
                    DateTime.parse(data['posted']),
                  )
                  : 'Not specified';

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
                _buildDetailItem(Icons.timer, 'Prepared', preparedAt),
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
                _buildDetailItem(Icons.access_time, 'Posted On:', posted),

                const SizedBox(height: 24),

                // Location Info
                _buildSectionTitle(context, 'Restaurant Details'),
                _buildDetailItem(Icons.store, 'Restaurant:', restaurantName),
                _buildDetailItem(
                  Icons.location_on,
                  'Address:',
                  restaurantAddress,
                ),

                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.chat),
                        label: const Text('Chat'),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => ChatScreen(
                                    donationId: donationId,
                                    currentUserType: 'ngo',
                                    otherPartyName: restaurantName,
                                    otherPartyImage: imageUrl,
                                  ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.local_shipping),
                        label: const Text('Request Pickup'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => NGORequestFormScreen(
                                    restaurantName: restaurantName,
                                    foodItems: title,
                                    imageUrl: imageUrl,
                                    donationId: donationId,
                                    restaurantId: restaurantId,
                                  ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                // Restaurant Reviews Section
                Text(
                  'Restaurant Reviews',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
                const SizedBox(height: 16),
                _buildReviewCard(
                  'Community Kitchen',
                  'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
                  'Always fresh and well-packaged food. Very reliable!',
                  '2 days ago',
                  5,
                ),
                _buildReviewCard(
                  'Hope Foundation',
                  'https://images.unsplash.com/photo-1606787366850-de6330128bfc?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
                  'Great variety of meals, but sometimes arrives late',
                  '1 week ago',
                  4,
                ),
                _buildReviewCard(
                  'Food Rescue',
                  'https://images.unsplash.com/photo-1504674900247-0877df9cc836?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
                  'Excellent quality and generous portions',
                  '2 weeks ago',
                  5,
                ),
              ], // This closes the children list
            ),
          );
        },
      ),
    );
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

  Widget _buildReviewCard(
    String ngoName,
    String imageUrl,
    String review,
    String date,
    int rating,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(imageUrl),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ngoName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          size: 16,
                          color: Colors.amber,
                        );
                      }),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(review),
            const SizedBox(height: 8),
            Text(date, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
