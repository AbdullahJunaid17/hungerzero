class Donation {
  final String title;
  final int quantity;
  final DateTime pickupTime;
  final DateTime postedTime;
  final String restaurantId;
  final bool allergens;
  final String specialInstructions;
  final String foodType;
  final String status;
  final String? imageUrl;

  Donation({
    required this.title,
    required this.quantity,
    required this.pickupTime,
    required this.postedTime,
    required this.restaurantId,
    required this.allergens,
    required this.specialInstructions,
    required this.foodType,
    required this.status,
    this.imageUrl,
  });

  factory Donation.fromMap(Map<String, dynamic> data) {
    return Donation(
      title: data['title'] ?? '',
      quantity: data['quantity'] ?? 0,
      pickupTime: DateTime.parse(data['pickupTime']),
      postedTime: DateTime.parse(data['postedTime']),
      restaurantId: data['restaurantId'] ?? '',
      allergens: data['allergens'] ?? false,
      specialInstructions: data['specialInstructions'] ?? '',
      foodType: data['foodType'] ?? 'Veg',
      status: data['status'] ?? 'pending',
      imageUrl: data['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'quantity': quantity,
      'pickupTime': pickupTime.toIso8601String(),
      'postedTime': postedTime.toIso8601String(),
      'restaurantId': restaurantId,
      'allergens': allergens,
      'specialInstructions': specialInstructions,
      'foodType': foodType,
      'status': status,
      'imageUrl': imageUrl,
    };
  }
}
