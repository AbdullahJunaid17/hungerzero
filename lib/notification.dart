import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hungerzero/request.dart'; // Make sure this has NGORequestDetailScreen

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final restaurantId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Donation Requests'),
        backgroundColor: Colors.deepOrange,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('requests')
                .where(
                  'restaurantId',
                  isEqualTo: FirebaseAuth.instance.currentUser?.uid,
                )
                .where('status', isEqualTo: 'pending')
                //.orderBy('createdAt', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No requests yet.'));
          }

          final requests = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final data = requests[index].data() as Map<String, dynamic>;

              return FutureBuilder<DocumentSnapshot>(
                future:
                    FirebaseFirestore.instance
                        .collection('ngos')
                        .doc(data['ngoId'])
                        .get(),
                builder: (context, ngoSnapshot) {
                  if (!ngoSnapshot.hasData) {
                    return const SizedBox(); // or shimmer
                  }

                  final ngoData =
                      ngoSnapshot.data!.data() as Map<String, dynamic>?;

                  final ngoName = ngoData?['ngoName'] ?? 'Unknown NGO';
                  final ngoImage =
                      ngoData?['imageUrl'] ??
                      'https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png';
                  final requestText = 'Requested Pickup';
                  final type = data['isUrgent'] == true ? 'Urgent' : 'Regular';
                  final timeAgo = _getTimeAgo(data['createdAt']);

                  return _buildRequestItem(
                    context,
                    ngoName,
                    requestText,
                    timeAgo,
                    ngoImage,
                    type,
                    requestId: requests[index].id,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildRequestItem(
    BuildContext context,
    String ngoName,
    String request,
    String time,
    String imageUrl,
    String type, {
    required String requestId,
  }) {
    Color typeColor = Colors.grey;
    if (type == 'Urgent') typeColor = Colors.red;
    if (type == 'Regular') typeColor = Colors.blue;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => NGORequestDetailScreen(requestId: requestId),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // NGO Image with Type Badge
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: typeColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        type,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
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
                    Text(request),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(time, style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  String _getTimeAgo(Timestamp? timestamp) {
    if (timestamp == null) return 'unknown';
    final now = DateTime.now();
    final time = timestamp.toDate();
    final difference = now.difference(time);

    if (difference.inSeconds < 60) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes} min ago';
    if (difference.inHours < 24) return '${difference.inHours} hr ago';
    return '${difference.inDays} days ago';
  }
}
