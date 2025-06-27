import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class NGOImpactReportsScreen extends StatefulWidget {
  const NGOImpactReportsScreen({super.key});

  @override
  State<NGOImpactReportsScreen> createState() => _NGOImpactReportsScreenState();
}

class _NGOImpactReportsScreenState extends State<NGOImpactReportsScreen> {
  String _timeRange = 'Monthly';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Impact Reports'),
        backgroundColor: Colors.deepOrange,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => setState(() => _timeRange = value),
            itemBuilder:
                (context) => [
                  const PopupMenuItem(value: 'Weekly', child: Text('Weekly')),
                  const PopupMenuItem(value: 'Monthly', child: Text('Monthly')),
                  const PopupMenuItem(value: 'Yearly', child: Text('Yearly')),
                ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Summary Cards
            Row(
              children: [
                _buildImpactCard(
                  '5,240',
                  'Meals Distributed',
                  Icons.restaurant,
                  Colors.blue,
                ),
                const SizedBox(width: 10),
                _buildImpactCard(
                  '1,850',
                  'People Served',
                  Icons.people,
                  Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildImpactCard(
                  '56',
                  'Pickups Completed',
                  Icons.local_shipping,
                  Colors.purple,
                ),
                const SizedBox(width: 10),
                _buildImpactCard(
                  '120',
                  'Volunteer Hours',
                  Icons.access_time,
                  Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Distribution Chart
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Meals Distribution',
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
                          LineSeries<ImpactData, String>(
                            dataSource: [
                              ImpactData('Jan', 420),
                              ImpactData('Feb', 580),
                              ImpactData('Mar', 650),
                              ImpactData('Apr', 720),
                              ImpactData('May', 890),
                              ImpactData('Jun', 980),
                            ],
                            xValueMapper: (ImpactData data, _) => data.month,
                            yValueMapper: (ImpactData data, _) => data.value,
                            color: Colors.deepOrange,
                            markerSettings: const MarkerSettings(
                              isVisible: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Impact by Shelter
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Impact by Shelter',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 300,
              child: SfCircularChart(
                series: <CircularSeries>[
                  PieSeries<ShelterData, String>(
                    dataSource: [
                      ShelterData('Homeless Shelter', 35),
                      ShelterData('Children\'s Home', 25),
                      ShelterData('Women\'s Refuge', 20),
                      ShelterData('Elderly Care', 15),
                      ShelterData('Community Kitchen', 5),
                    ],
                    xValueMapper: (ShelterData data, _) => data.name,
                    yValueMapper: (ShelterData data, _) => data.percentage,
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImpactCard(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(icon, color: color, size: 30),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImpactData {
  final String month;
  final int value;

  ImpactData(this.month, this.value);
}

class ShelterData {
  final String name;
  final int percentage;

  ShelterData(this.name, this.percentage);
}
