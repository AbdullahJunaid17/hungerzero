import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Analytics'),
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Quick Stats Row
            Row(
              children: [
                _buildStatCard(
                  'Total Donations',
                  '124',
                  Icons.food_bank,
                  Colors.blue,
                ),
                const SizedBox(width: 10),
                _buildStatCard(
                  'People Fed',
                  '1,240',
                  Icons.people,
                  Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildStatCard(
                  'Active NGOs',
                  '8',
                  Icons.handshake,
                  Colors.purple,
                ),
                const SizedBox(width: 10),
                _buildStatCard('CO₂ Saved (kg)', '56', Icons.eco, Colors.teal),
              ],
            ),
            const SizedBox(height: 20),

            // Monthly Donation Chart
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Monthly Donations',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 300,
                      child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        series: <CartesianSeries>[
                          ColumnSeries<ChartData, String>(
                            dataSource: [
                              ChartData('Jan', 12),
                              ChartData('Feb', 15),
                              ChartData('Mar', 18),
                              ChartData('Apr', 22),
                              ChartData('May', 28),
                              ChartData('Jun', 35),
                            ],
                            xValueMapper: (ChartData data, _) => data.month,
                            yValueMapper: (ChartData data, _) => data.donations,
                            color: Colors.deepOrange,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Recent Activity
            const Text(
              'Recent Activity',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            _buildActivityTile(
              'New donation claimed',
              'Hope Foundation - 15 meals',
              '2 hours ago',
            ),
            _buildActivityTile(
              'Pickup completed',
              'Community Kitchen',
              'Yesterday',
            ),
            _buildActivityTile(
              'New NGO partnership',
              'Street Angels',
              '3 days ago',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityTile(String title, String subtitle, String time) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.deepOrange,
          child: Icon(Icons.notifications, color: Colors.white),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Text(time, style: TextStyle(color: Colors.grey.shade600)),
      ),
    );
  }
}

class ChartData {
  final String month;
  final int donations;

  ChartData(this.month, this.donations);
}
