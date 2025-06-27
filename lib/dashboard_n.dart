import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class NGODashboardScreen extends StatelessWidget {
  const NGODashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NGO Dashboard'),
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
                  'Active Pickups',
                  '8',
                  Icons.local_shipping,
                  Colors.blue,
                ),
                const SizedBox(width: 10),
                _buildStatCard(
                  'Today\'s Meals',
                  '240',
                  Icons.restaurant,
                  Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildStatCard('Volunteers', '12', Icons.people, Colors.purple),
                const SizedBox(width: 10),
                _buildStatCard('Shelters', '5', Icons.home_work, Colors.teal),
              ],
            ),
            const SizedBox(height: 20),

            // Weekly Distribution Chart
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Weekly Distribution',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 250,
                      child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        series: <CartesianSeries>[
                          ColumnSeries<ChartData, String>(
                            dataSource: [
                              ChartData('Mon', 45),
                              ChartData('Tue', 68),
                              ChartData('Wed', 72),
                              ChartData('Thu', 55),
                              ChartData('Fri', 90),
                              ChartData('Sat', 120),
                              ChartData('Sun', 85),
                            ],
                            xValueMapper: (ChartData data, _) => data.day,
                            yValueMapper: (ChartData data, _) => data.meals,
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

            // Urgent Requirements
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Urgent Requirements',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            _buildRequirementItem('Rice (50kg)', 'Shelter A', Colors.red),
            _buildRequirementItem(
              'Blankets (20)',
              'Night Shelter',
              Colors.orange,
            ),
            _buildRequirementItem(
              'Milk Powder (10kg)',
              'Children\'s Home',
              Colors.blue,
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

  Widget _buildRequirementItem(String item, String location, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.warning_amber, color: color),
        ),
        title: Text(item, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(location),
        trailing: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrange,
            padding: const EdgeInsets.symmetric(horizontal: 12),
          ),
          child: const Text('Request', style: TextStyle(fontSize: 12)),
        ),
      ),
    );
  }
}

class ChartData {
  final String day;
  final int meals;

  ChartData(this.day, this.meals);
}
