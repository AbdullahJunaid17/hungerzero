import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hungerzero/activedetails.dart';
import 'package:intl/intl.dart'; // We'll create this next

class NGOActiveDonationsScreen extends StatelessWidget {
  const NGOActiveDonationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ngoId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Donations'),
        backgroundColor: Colors.deepOrange,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('requests')
                .where('ngoId', isEqualTo: ngoId)
                .where('status', isEqualTo: 'accepted')
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_shipping, size: 60, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No active donations',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final request = snapshot.data!.docs[index];
              final requestData = request.data() as Map<String, dynamic>;

              return FutureBuilder(
                future: Future.wait([
                  FirebaseFirestore.instance
                      .collection('donations')
                      .doc(requestData['donationId'])
                      .get(),
                  FirebaseFirestore.instance
                      .collection('restaurants')
                      .doc(requestData['restaurantId'])
                      .get(),
                ]),
                builder: (
                  context,
                  AsyncSnapshot<List<DocumentSnapshot>> snapshot,
                ) {
                  if (!snapshot.hasData) {
                    return const SizedBox(); // or shimmer loading
                  }

                  final donation = snapshot.data![0];
                  final restaurant = snapshot.data![1];
                  final donationData = donation.data() as Map<String, dynamic>;
                  final restaurantData =
                      restaurant.data() as Map<String, dynamic>;

                  final pickupTime =
                      requestData['pickupTime'] != null
                          ? DateTime.parse(requestData['pickupTime'])
                          : null;

                  return _buildActiveDonationCard(
                    context,
                    restaurantData['restaurantName'] ?? 'Restaurant',
                    donationData['title'] ?? 'Donation',
                    pickupTime,
                    restaurantData['address'] ?? 'Address not specified',
                    request.id,
                    requestData['donationId'],
                    requestData['restaurantId'],
                    (donationData['imageURL'] as List?)?.isNotEmpty == true
                        ? donationData['imageURL'][0]
                        : 'https://via.placeholder.com/150',
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildActiveDonationCard(
    BuildContext context,
    String restaurantName,
    String donationTitle,
    DateTime? pickupTime,
    String restaurantAddress,
    String requestId,
    String donationId,
    String restaurantId,
    String imageUrl,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => ActiveDetailsScreen(
                    requestId: requestId,
                    donationId: donationId,
                    restaurantId: restaurantId,
                  ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Restaurant Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[200],
                          child: const Icon(Icons.restaurant),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          restaurantName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          restaurantAddress,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.fastfood, size: 20, color: Colors.deepOrange[400]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      donationTitle,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 20,
                    color: Colors.deepOrange[400],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    pickupTime != null
                        ? 'Pickup by ${DateFormat.MMMd().add_jm().format(pickupTime)}'
                        : 'No pickup time set',
                    style: TextStyle(color: Colors.grey[700], fontSize: 15),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
