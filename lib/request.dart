import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'chat.dart';

class NGORequestDetailScreen extends StatelessWidget {
  final String requestId;

  const NGORequestDetailScreen({super.key, required this.requestId});

  @override
  Widget build(BuildContext context) {
    final requestRef = FirebaseFirestore.instance
        .collection('requests')
        .doc(requestId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Details'),
        backgroundColor: Colors.deepOrange,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.deepOrange.shade700, Colors.deepOrange.shade400],
            ),
          ),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: requestRef.get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final requestData = snapshot.data!.data() as Map<String, dynamic>;
          final isUrgent = requestData['isUrgent'] ?? false;
          final createdAt =
              requestData['createdAt'] != null
                  ? DateFormat.yMMMMd().add_jm().format(
                    (requestData['createdAt'] as Timestamp).toDate(),
                  )
                  : 'Not specified';
          final pickupTime =
              requestData['pickupTime'] != null
                  ? DateFormat.yMMMMd().add_jm().format(
                    DateTime.parse(requestData['pickupTime']),
                  )
                  : 'Not specified';

          // Fetch donation details
          final donationFuture =
              FirebaseFirestore.instance
                  .collection('donations')
                  .doc(requestData['donationId'])
                  .get();

          // Fetch NGO details
          final ngoFuture =
              FirebaseFirestore.instance
                  .collection('ngos')
                  .doc(requestData['ngoId'])
                  .get();

          return FutureBuilder(
            future: Future.wait([donationFuture, ngoFuture]),
            builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final donationData =
                  snapshot.data![0].data() as Map<String, dynamic>;
              final ngoData = snapshot.data![1].data() as Map<String, dynamic>;

              final title = donationData['title'] ?? 'No Title';
              final quantity =
                  "${donationData['quantity']} ${donationData['unit']}";
              final foodType = donationData['foodType'] ?? 'N/A';
              final allergens = donationData['allergens'] == true;
              final instructions = donationData['instructions'] ?? 'None';
              final restaurantName =
                  donationData['restaurantName'] ?? 'Unknown Restaurant';
              final restaurantAddress =
                  donationData['restaurantAddress'] ?? 'No address';
              final imageUrl =
                  (donationData['imageURLs'] as List?)?.isNotEmpty == true
                      ? donationData['imageURLs'][0]
                      : 'https://via.placeholder.com/150';

              final ngoName = ngoData['ngoName'] ?? 'Unknown NGO';
              final ngoAddress = ngoData['address'] ?? 'No address';
              final ngoImage =
                  'https://via.placeholder.com/150'; // Default NGO image
              final ratingAverage =
                  (ngoData['ratingAverage'] as num?)?.toDouble() ?? 0;
              final ratingCount = ngoData['ratingCount'] ?? 0;

              Color typeColor = isUrgent ? Colors.red : Colors.blue;
              String type = isUrgent ? 'Urgent' : 'Regular';

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // NGO Profile Section
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      shadowColor: Colors.deepOrange.withOpacity(0.2),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.white, Colors.grey.shade50],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              // NGO Header
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.deepOrange.withOpacity(
                                          0.3,
                                        ),
                                        width: 2,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(ngoImage),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          ngoName,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.deepOrange,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              size: 16,
                                              color: Colors.deepOrange,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              ngoAddress,
                                              style: TextStyle(
                                                color: Colors.grey.shade700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: typeColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: typeColor.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Text(
                                      type,
                                      style: TextStyle(
                                        color: typeColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // NGO Stats
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildNGOStat(
                                      '24',
                                      'Pickups',
                                      Icons.local_shipping,
                                    ),
                                    _buildNGOStat(
                                      ratingAverage.toStringAsFixed(1),
                                      'Rating',
                                      Icons.star,
                                    ),
                                    _buildNGOStat(
                                      '98%',
                                      'Reliability',
                                      Icons.verified,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Chat Button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.chat, size: 20),
                                  label: const Text(
                                    'Chat with NGO',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepOrange,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 2,
                                    shadowColor: Colors.deepOrange.withOpacity(
                                      0.3,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => ChatScreen(
                                              donationId:
                                                  requestData['donationId'],
                                              currentUserType: 'restaurant',
                                              otherPartyName: ngoName,
                                              otherPartyImage: ngoImage,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Request Details Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'DONATION REQUEST',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      shadowColor: Colors.deepOrange.withOpacity(0.1),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.white, Colors.grey.shade50],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildRequestDetailRow(
                                Icons.fastfood,
                                'Requested Items',
                                title,
                              ),
                              const Divider(height: 24, thickness: 0.5),
                              _buildRequestDetailRow(
                                Icons.access_time,
                                'Request Time',
                                createdAt,
                              ),
                              const Divider(height: 24, thickness: 0.5),
                              _buildRequestDetailRow(
                                Icons.calendar_today,
                                'Pickup Window',
                                pickupTime,
                              ),
                              const Divider(height: 24, thickness: 0.5),
                              _buildRequestDetailRow(
                                Icons.note,
                                'Special Instructions',
                                instructions.isNotEmpty
                                    ? instructions
                                    : 'No special instructions',
                              ),
                              const Divider(height: 24, thickness: 0.5),
                              _buildRequestDetailRow(
                                Icons.category,
                                'Food Type',
                                foodType,
                              ),
                              if (allergens)
                                const Divider(height: 24, thickness: 0.5),
                              if (allergens)
                                _buildRequestDetailRow(
                                  Icons.warning,
                                  'Allergens',
                                  'Contains allergens',
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              _showRejectConfirmation(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: Colors.red.shade400,
                                  width: 1.5,
                                ),
                              ),
                              elevation: 2,
                              shadowColor: Colors.red.withOpacity(0.2),
                            ),
                            child: const Text(
                              'Reject',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              _showAcceptConfirmation(context, requestId);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade600,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                              shadowColor: Colors.green.withOpacity(0.3),
                            ),
                            child: const Text(
                              'Accept',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildNGOStat(String value, String label, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.deepOrange.withOpacity(0.1),
          ),
          child: Icon(icon, size: 20, color: Colors.deepOrange),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildRequestDetailRow(IconData icon, String label, String value) {
    return Row(
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
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showRejectConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    size: 48,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Reject Request?',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Are you sure you want to reject this donation request?',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              await FirebaseFirestore.instance
                                  .collection('requests')
                                  .doc(requestId)
                                  .update({
                                    'status': 'rejected',
                                  });

                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Request rejected'),
                                  backgroundColor: Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                              Navigator.pop(
                                context,
                              ); // Go back to notifications
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error rejecting request: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Reject'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void _showAcceptConfirmation(BuildContext context, String requestId) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green.withOpacity(0.1),
                    ),
                    child: const Icon(
                      Icons.check_circle_outline,
                      size: 48,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Accept Request?',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Confirm you will fulfill this donation request',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              await FirebaseFirestore.instance
                                  .collection('requests')
                                  .doc(requestId)
                                  .update({
                                    'status': 'accepted',
                                    'pickupConfirmedByRestaurant': true,
                                    'confirmedAt': FieldValue.serverTimestamp(),
                                  });

                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Request accepted!'),
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                              Navigator.pop(
                                context,
                              ); // Go back to notifications
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error accepting request: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Accept'),
                        ),
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
