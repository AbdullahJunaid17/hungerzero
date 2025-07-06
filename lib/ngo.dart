import 'package:flutter/material.dart';
import 'package:hungerzero/active.dart';
import 'package:hungerzero/dashboard_n.dart';
import 'package:hungerzero/details.dart';
import 'package:hungerzero/help_n.dart';
import 'package:hungerzero/history_n.dart';
import 'package:hungerzero/impact_n.dart';
import 'package:hungerzero/loginpage.dart';
import 'package:hungerzero/settings_n.dart';
import 'package:hungerzero/volunteer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NGOHomePage extends StatefulWidget {
  const NGOHomePage({Key? key}) : super(key: key);

  @override
  State<NGOHomePage> createState() => _NGOHomePageState();
}

class _NGOHomePageState extends State<NGOHomePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  late Future<DocumentSnapshot> _ngoDataFuture;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  // Profile tab controllers
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _areasController;
  late TextEditingController _regController;
  late TextEditingController _repController;
  bool _notificationsEnabled = true;
  bool _acceptAllDonations = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final userId = _auth.currentUser?.uid;

    // Initialize controllers
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _areasController = TextEditingController();
    _regController = TextEditingController();
    _repController = TextEditingController();

    _ngoDataFuture = _firestore.collection('ngos').doc(userId).get().then((
      doc,
    ) {
      if (doc.exists) {
        final data = doc.data()!;
        _nameController.text = data['ngoName'] ?? '';
        _emailController.text = data['email'] ?? '';
        _phoneController.text = data['phone'] ?? '';
        _addressController.text = data['address'] ?? '';
        _areasController.text = data['areas'] ?? '';
        _regController.text = data['ngoRegistration'] ?? '';
        _repController.text = data['representativeName'] ?? '';
        _notificationsEnabled = data['notificationsEnabled'] ?? true;
        _acceptAllDonations = data['acceptAllDonations'] ?? false;
      }
      return doc;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _areasController.dispose();
    _regController.dispose();
    _repController.dispose();
    super.dispose();
  }

  Future<void> _saveProfileChanges() async {
    setState(() => _isSaving = true);
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await _firestore.collection('ngos').doc(user.uid).update({
        'ngoName': _nameController.text,
        'phone': _phoneController.text,
        'address': _addressController.text,
        'areas': _areasController.text,
        'ngoRegistration': _regController.text,
        'representativeName': _repController.text,
        'notificationsEnabled': _notificationsEnabled,
        'acceptAllDonations': _acceptAllDonations,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving data: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: _ngoDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Scaffold(body: Center(child: Text('No NGO data found')));
        }

        final ngoData = snapshot.data!.data() as Map<String, dynamic>;
        final ngoName = ngoData['ngoName'] ?? 'NGO';
        final joinDate = ngoData['joinDate'] ?? '2022';
        final formattedJoinDate = DateFormat(
          'MMMM yyyy',
        ).format(joinDate is Timestamp ? joinDate.toDate() : DateTime.now());

        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            title: const Text(
              'HungerZero',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            backgroundColor: Colors.deepOrange,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.chat_outlined, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
            ],
          ),
          drawer: _buildAppDrawer(context, ngoName, formattedJoinDate),
          body: PageView(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            children: [
              _buildHomeTab(context, ngoName),
              _buildBrowseTab(),
              _buildProfileTab(),
            ],
          ),
          bottomNavigationBar: _buildBottomAppBar(),
        );
      },
    );
  }

  Widget _buildHomeTab(BuildContext context, String ngoName) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header with stats
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.deepOrange,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepOrange.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1606787366850-de6330128bfc?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  ngoName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatItem(
                      context,
                      '24',
                      'Active Pickups',
                      Icons.local_shipping,
                    ),
                    _buildStatItem(
                      context,
                      '1,240',
                      'People Fed Today',
                      Icons.emoji_food_beverage,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Quick Action Buttons
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  context,
                  'Schedule',
                  Icons.calendar_today,
                  Colors.blue,
                  () {},
                ),
                _buildActionButton(
                  context,
                  'Active Donations',
                  Icons.list_alt,
                  Colors.green,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NGOActiveDonationsScreen(),
                      ),
                    );
                  },
                ),
                _buildActionButton(
                  context,
                  'Volunteers',
                  Icons.people_alt,
                  Colors.purple,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NGOVolunteersScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Urgent Donations Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Urgent Donations',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                    ),
                    TextButton(child: const Text('See All'), onPressed: () {}),
                  ],
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 265,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      _UrgentDonationCard(
                        restaurantName: 'Grand Hotel',
                        foodItems: '50kg rice, 30 curry meals',
                        timePosted: '15 min ago',
                        distance: '1.2 km',
                        imageUrl:
                            'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
                      ),
                      SizedBox(width: 15),
                      _UrgentDonationCard(
                        restaurantName: 'Bakery Corner',
                        foodItems: '40 loaves bread, 20 pastries',
                        timePosted: '25 min ago',
                        distance: '2.7 km',
                        imageUrl:
                            'https://images.unsplash.com/photo-1509440159596-0249088772ff?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Recent Activity
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Activity',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
                const SizedBox(height: 15),
                _buildActivityItem(
                  context,
                  'Pickup Completed',
                  'Collected 25 meals from Bistro Central',
                  '2 hours ago',
                  Icons.check_circle,
                  Colors.green,
                ),
                _buildActivityItem(
                  context,
                  'New Donation',
                  'Grand Hotel posted 50kg rice',
                  '1 hour ago',
                  Icons.notifications,
                  Colors.orange,
                ),
                _buildActivityItem(
                  context,
                  'Delivery Scheduled',
                  'Distributing to 3 shelters tomorrow',
                  'Yesterday',
                  Icons.calendar_today,
                  Colors.blue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrowseTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search donations...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),

          // Filter Chips
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildFilterChip('All', true),
                _buildFilterChip('Nearby', false),
                _buildFilterChip('Vegetarian', false),
                _buildFilterChip('Bakery', false),
                _buildFilterChip('Cooked Meals', false),
              ],
            ),
          ),

          // Live Donation Listings
          Padding(
            padding: const EdgeInsets.all(16),
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('donations')
                      .where(
                        'status',
                        isEqualTo: 'pending',
                      ) // Optional: show only unclaimed donations
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text("No donations available at the moment.");
                }

                return Column(
                  children:
                      snapshot.data!.docs.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        String quantity = data['quantity']?.toString() ?? '';
                        String unit = data['unit'] ?? '';
                        String title = data['title'] ?? '';
                        String food = quantity + ' ' + unit + ' ' + title;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: _DonationListingCard(
                            donationId: doc.id, // 🔥 pass doc.id
                            restaurantId: data['restaurantId'] ?? '',
                            restaurantName:
                                data['restaurantName'] ?? 'Restaurant',
                            foodItems:
                                food.trim().isEmpty ? 'No details' : food,
                            timePosted: _getTimeAgoFromString(data['posted']),
                            distance: data['distance'] ?? 'Unknown',
                            imageUrl:
                                (data['imageURLs'] as List?)?.isNotEmpty == true
                                    ? data['imageURLs'][0]
                                    : 'https://via.placeholder.com/150', // fallback
                          ),
                        );
                      }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getTimeAgoFromString(String? timeStr) {
    if (timeStr == null || timeStr.isEmpty) return 'some time ago';
    try {
      final date = DateTime.parse(timeStr);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inMinutes < 1) return 'just now';
      if (difference.inMinutes < 60) return '${difference.inMinutes} min ago';
      if (difference.inHours < 24) return '${difference.inHours} hours ago';
      return DateFormat('dd MMM').format(date);
    } catch (e) {
      return 'some time ago';
    }
  }

  Widget _buildProfileTab() {
    return FutureBuilder<DocumentSnapshot>(
      future: _ngoDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text('No NGO data found'));
        }

        final ngoData = snapshot.data!.data() as Map<String, dynamic>;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Profile Header
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1606787366850-de6330128bfc?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        ngoData['ngoName'] ?? 'NGO',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        ngoData['address'] ?? 'No address',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // NGO Information Section
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info, color: Colors.deepOrange),
                          const SizedBox(width: 8),
                          Text(
                            'Organization Details',
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildProfileItem(
                        Icons.people,
                        'NGO Name',
                        ngoData['ngoName'] ?? 'Not specified',
                      ),
                      _buildProfileItem(
                        Icons.person,
                        'Representative',
                        ngoData['representativeName'] ?? 'Not specified',
                      ),
                      _buildProfileItem(
                        Icons.email,
                        'Email',
                        ngoData['email'] ?? 'Not specified',
                      ),
                      _buildProfileItem(
                        Icons.phone,
                        'Phone',
                        ngoData['phone'] ?? 'Not specified',
                      ),
                      _buildProfileItem(
                        Icons.location_on,
                        'Address',
                        ngoData['address'] ?? 'Not specified',
                        maxLines: 2,
                      ),
                      _buildProfileItem(
                        Icons.map,
                        'Service Areas',
                        ngoData['areas'] ?? 'Not specified',
                      ),
                      _buildProfileItem(
                        Icons.assignment,
                        'Registration',
                        ngoData['ngoRegistration'] ?? 'Not specified',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Edit Button
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NGOSettingsScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'EDIT PROFILE',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileItem(
    IconData icon,
    String label,
    String value, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.deepOrange),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: maxLines,
                  overflow: maxLines > 1 ? TextOverflow.ellipsis : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ... [Keep all your existing helper methods (_buildFilterChip, _buildActionButton,
  // _buildStatItem, _buildActivityItem, _buildAppDrawer, _buildDrawerItem,
  // _buildBottomAppBar) exactly as they are in your original code]

  // ... [Keep all your existing widget classes (_UrgentDonationCard, _DonationListingCard)]

  // ... [Keep all your existing widget class implementations at the bottom of the file]

  Widget _buildFilterChip(String label, bool selected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (bool value) {},
        selectedColor: Colors.deepOrange,
        checkmarkColor: Colors.white,
        labelStyle: TextStyle(
          color: selected ? Colors.white : Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(icon, size: 30, color: color),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[700],
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String value,
    String label,
    IconData icon,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildActivityItem(
    BuildContext context,
    String title,
    String subtitle,
    String time,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(subtitle),
            const SizedBox(height: 4),
            Text(time, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildAppDrawer(
    BuildContext context,
    String ngoName,
    String joinDate,
  ) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepOrange,
              image: DecorationImage(
                image: const NetworkImage(
                  'https://images.unsplash.com/photo-1606787366850-de6330128bfc?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
                ),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.deepOrange.withOpacity(0.7),
                  BlendMode.srcOver,
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1606787366850-de6330128bfc?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  ngoName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Partner since $joinDate',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(Icons.dashboard, 'Dashboard', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NGODashboardScreen(),
              ),
            );
          }),
          _buildDrawerItem(Icons.history, 'Pickup History', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NGOPickupHistoryScreen(),
              ),
            );
          }),
          _buildDrawerItem(Icons.analytics, 'Impact Reports', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NGOImpactReportsScreen(),
              ),
            );
          }),
          _buildDrawerItem(Icons.group, 'Volunteers', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NGOVolunteersScreen(),
              ),
            );
          }),
          _buildDrawerItem(Icons.settings, 'NGO Settings', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NGOSettingsScreen(),
              ),
            );
          }),
          const Divider(),
          _buildDrawerItem(Icons.help, 'Help Center', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NGOHelpCenterScreen(),
              ),
            );
          }),
          _buildDrawerItem(Icons.logout, 'Sign Out', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepOrange),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _buildBottomAppBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(
              Icons.home,
              color: _currentIndex == 0 ? Colors.deepOrange : Colors.grey,
            ),
            onPressed: () => _pageController.jumpToPage(0),
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              color: _currentIndex == 1 ? Colors.deepOrange : Colors.grey,
            ),
            onPressed: () => _pageController.jumpToPage(1),
          ),
          IconButton(
            icon: Icon(
              Icons.chat,
              color: _currentIndex == 2 ? Colors.deepOrange : Colors.grey,
            ),
            onPressed: () => _pageController.jumpToPage(2),
          ),
          IconButton(
            icon: Icon(
              Icons.person,
              color: _currentIndex == 3 ? Colors.deepOrange : Colors.grey,
            ),
            onPressed: () => _pageController.jumpToPage(3),
          ),
        ],
      ),
    );
  }
}

class _UrgentDonationCard extends StatelessWidget {
  final String restaurantName;
  final String foodItems;
  final String timePosted;
  final String distance;
  final String imageUrl;

  const _UrgentDonationCard({
    required this.restaurantName,
    required this.foodItems,
    required this.timePosted,
    required this.distance,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Restaurant Image with Urgent Badge
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                child: Image.network(
                  imageUrl,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'URGENT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(12),
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
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.fastfood, size: 16, color: Colors.deepOrange),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        foodItems,
                        style: TextStyle(color: Colors.grey[700], fontSize: 13),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: Colors.deepOrange),
                    const SizedBox(width: 5),
                    Text(
                      timePosted,
                      style: TextStyle(color: Colors.grey[700], fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.deepOrange),
                    const SizedBox(width: 5),
                    Text(
                      distance,
                      style: TextStyle(color: Colors.grey[700], fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Request Pickup',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DonationListingCard extends StatelessWidget {
  final String restaurantName;
  final String restaurantId;
  final String donationId;
  final String foodItems;
  final String timePosted;
  final String distance;
  final String imageUrl;

  const _DonationListingCard({
    required this.restaurantName,
    required this.restaurantId,
    required this.donationId,
    required this.foodItems,
    required this.timePosted,
    required this.distance,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => NGODonationDetailsPage(
                    donationId: donationId,
                    restaurantId: restaurantId,
                    imageUrl: imageUrl,
                  ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Restaurant Image with error fallback
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),

              // Expanded column to avoid overflow
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      foodItems,
                      style: TextStyle(color: Colors.grey[700], fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          timePosted,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            distance,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Arrow icon
              Icon(Icons.chevron_right, color: Colors.deepOrange),
            ],
          ),
        ),
      ),
    );
  }
}
