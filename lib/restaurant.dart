import 'package:flutter/material.dart';
import 'package:hungerzero/community.dart';
import 'package:hungerzero/current.dart';
import 'package:hungerzero/dashboard_r.dart';
import 'package:hungerzero/form_r.dart';
import 'package:hungerzero/help_r.dart';
import 'package:hungerzero/history_r.dart';
import 'package:hungerzero/impact_r.dart';
import 'package:hungerzero/loginpage.dart';
import 'package:hungerzero/notification.dart';
import 'package:hungerzero/previous.dart';
import 'package:hungerzero/settings_r.dart';
import 'package:hungerzero/tax.dart';
import 'package:intl/intl.dart';

class RestaurantHomePage extends StatefulWidget {
  const RestaurantHomePage({Key? key}) : super(key: key);

  @override
  State<RestaurantHomePage> createState() => _RestaurantHomePageState();
}

class _RestaurantHomePageState extends State<RestaurantHomePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('HungerZero', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsScreen()),
              );
            },
          ),
        ],
      ),
      drawer: _buildAppDrawer(context),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        children: [
          _buildHomeTab(context),
          _buildBrowseTab(),
          _buildProfileTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DonationFormStepper()),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomAppBar(),
    );
  }

  Widget _buildHomeTab(BuildContext context) {
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
                    'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Welcome back, Bistro Central!',
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
                      '12',
                      'Active Donations',
                      Icons.local_dining,
                    ),
                    _buildStatItem(
                      context,
                      '124',
                      'People Fed',
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
                  'Current',
                  Icons.list_alt,
                  Colors.blue,
                  () => _navigateToCurrentDonations(context),
                ),
                _buildActionButton(
                  context,
                  'Previous',
                  Icons.history,
                  Colors.green,
                  () => _navigateToPreviousDonations(context),
                ),
                _buildActionButton(
                  context,
                  'Community',
                  Icons.people,
                  Colors.purple,
                  () => _navigateToCommunityFeed(context),
                ),
              ],
            ),
          ),

          // Active Donations Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Active Donations',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 235,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      _DonationCard(
                        ngoName: 'Hope Foundation',
                        foodItems: '15 meals, 3 desserts',
                        pickupTime: 'Today, 4:30 PM',
                        status: 'Scheduled',
                        imageUrl:
                            'https://images.unsplash.com/photo-1606787366850-de6330128bfc?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
                      ),
                      SizedBox(width: 15),
                      _DonationCard(
                        ngoName: 'Community Kitchen',
                        foodItems: '8 meals, 2 salads',
                        pickupTime: 'Tomorrow, 11:00 AM',
                        status: 'Confirmed',
                        imageUrl:
                            'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
                      ),
                      SizedBox(width: 15),
                      _DonationCard(
                        ngoName: 'Street Angels',
                        foodItems: '20 sandwiches',
                        pickupTime: 'Pending confirmation',
                        status: 'Awaiting',
                        imageUrl:
                            'https://images.unsplash.com/photo-1504674900247-0877df9cc836?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Recent Activity
          Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              20,
              16,
              80,
            ), // Added bottom padding to prevent overflow
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recent Activity',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
                const SizedBox(height: 15),
                _buildActivityItem(
                  context,
                  'Donation Completed',
                  '25 meals delivered to Hope Foundation',
                  '2 hours ago',
                  Icons.check_circle,
                  Colors.green,
                ),
                _buildActivityItem(
                  context,
                  'New Request',
                  'Community Kitchen requested 15 meals',
                  'Yesterday',
                  Icons.notifications,
                  Colors.orange,
                ),
                _buildActivityItem(
                  context,
                  'Donation Scheduled',
                  'Pickup confirmed for tomorrow at 3 PM',
                  '2 days ago',
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

  Widget _buildBrowseTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 60,
            color: Colors.deepOrange.withOpacity(0.3),
          ),
          const SizedBox(height: 20),
          Text(
            'Browse NGOs',
            style: TextStyle(
              fontSize: 24,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Find NGOs near you to donate food',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person,
            size: 60,
            color: Colors.deepOrange.withOpacity(0.3),
          ),
          const SizedBox(height: 20),
          Text(
            'Profile Settings',
            style: TextStyle(
              fontSize: 24,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepOrange,
              image: DecorationImage(
                image: const NetworkImage(
                  'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
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
                    'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Bistro Central',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Partner since May 2023',
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
              MaterialPageRoute(builder: (context) => const DashboardScreen()),
            );
          }),
          _buildDrawerItem(Icons.history, 'Donation History', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DonationHistoryScreen(),
              ),
            );
          }),
          _buildDrawerItem(Icons.analytics, 'Impact Analytics', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ImpactAnalyticsScreen(),
              ),
            );
          }),
          _buildDrawerItem(Icons.receipt, 'Tax Documents', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TaxDocumentsScreen(),
              ),
            );
          }),
          _buildDrawerItem(Icons.settings, 'Restaurant Settings', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RestaurantSettingsScreen(),
              ),
            );
          }),
          const Divider(),
          _buildDrawerItem(Icons.help, 'Help Center', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HelpCenterScreen()),
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
          const SizedBox(width: 40),
          IconButton(
            icon: Icon(
              Icons.person,
              color: _currentIndex == 2 ? Colors.deepOrange : Colors.grey,
            ),
            onPressed: () => _pageController.jumpToPage(2),
          ),
        ],
      ),
    );
  }

  void _navigateToCurrentDonations(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CurrentDonationsScreen()),
    );
  }

  void _navigateToPreviousDonations(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PreviousDonationsScreen()),
    );
  }

  void _navigateToCommunityFeed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CommunityFeedScreen()),
    );
  }
}

class _DonationCard extends StatelessWidget {
  final String ngoName;
  final String foodItems;
  final String pickupTime;
  final String status;
  final String imageUrl;

  const _DonationCard({
    required this.ngoName,
    required this.foodItems,
    required this.pickupTime,
    required this.status,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.grey;
    if (status == 'Scheduled') statusColor = Colors.orange;
    if (status == 'Confirmed') statusColor = Colors.green;

    return Container(
      width: 250,
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
          // NGO Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.network(
              imageUrl,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(12),
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
                      pickupTime,
                      style: TextStyle(color: Colors.grey[700], fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
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
