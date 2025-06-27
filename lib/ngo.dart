import 'package:flutter/material.dart';
import 'package:hungerzero/dashboard_n.dart';
import 'package:hungerzero/details.dart';
import 'package:hungerzero/help_n.dart';
import 'package:hungerzero/history_n.dart';
import 'package:hungerzero/impact_n.dart';
import 'package:hungerzero/loginpage.dart';
import 'package:hungerzero/settings_n.dart';
import 'package:hungerzero/volunteer.dart';
import 'package:intl/intl.dart';

class NGOHomePage extends StatefulWidget {
  const NGOHomePage({Key? key}) : super(key: key);

  @override
  State<NGOHomePage> createState() => _NGOHomePageState();
}

class _NGOHomePageState extends State<NGOHomePage> {
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
            icon: const Icon(Icons.chat_outlined, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
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
                    'https://images.unsplash.com/photo-1606787366850-de6330128bfc?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Hope Foundation',
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
                  'Vehicles',
                  Icons.directions_car,
                  Colors.green,
                  () {},
                ),
                _buildActionButton(
                  context,
                  'Volunteers',
                  Icons.people_alt,
                  Colors.purple,
                  () {},
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

          // Donation Listings
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: const [
                _DonationListingCard(
                  restaurantName: "Bistro Central",
                  foodItems: "15 meals, 3 desserts",
                  timePosted: "10 min ago",
                  distance: "0.8 km",
                  imageUrl:
                      "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
                ),
                SizedBox(height: 15),
                _DonationListingCard(
                  restaurantName: "Pizza Heaven",
                  foodItems: "12 large pizzas",
                  timePosted: "25 min ago",
                  distance: "1.5 km",
                  imageUrl:
                      "https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
                ),
                SizedBox(height: 15),
                _DonationListingCard(
                  restaurantName: "Green Leaf Cafe",
                  foodItems: "20 vegan meals",
                  timePosted: "1 hour ago",
                  distance: "2.3 km",
                  imageUrl:
                      "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
                ),
              ],
            ),
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
            'NGO Profile',
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
                const Text(
                  'Hope Foundation',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Partner since June 2022',
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
  final String foodItems;
  final String timePosted;
  final String distance;
  final String imageUrl;

  const _DonationListingCard({
    required this.restaurantName,
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
          // Handle card tap
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Restaurant Image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),

              // Details
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
                      foodItems,
                      style: TextStyle(color: Colors.grey[700], fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          timePosted,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.location_on, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          distance,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Action Button
              IconButton(
                icon: const Icon(Icons.chevron_right, color: Colors.deepOrange),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => NGODonationDetailsPage(
                            restaurantName: restaurantName,
                            foodItems: foodItems,
                            timePosted: timePosted,
                            distance: distance,
                            imageUrl: imageUrl,
                          ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
