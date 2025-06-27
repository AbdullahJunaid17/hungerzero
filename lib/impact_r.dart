import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ImpactAnalyticsScreen extends StatefulWidget {
  const ImpactAnalyticsScreen({super.key});

  @override
  State<ImpactAnalyticsScreen> createState() => _ImpactAnalyticsScreenState();
}

class _ImpactAnalyticsScreenState extends State<ImpactAnalyticsScreen> {
  String _timeRange = 'Monthly';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Impact Analytics'),
        backgroundColor: Colors.deepOrange,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => setState(() => _timeRange = value),
            itemBuilder: (context) => [
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
            // Environmental Impact Card
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Environmental Impact',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _buildImpactMetric('56 kg', 'CO₂ Saved'),
                        _buildImpactMetric('120 L', 'Water Saved'),
                        _buildImpactMetric('75 kg', 'Waste Reduced'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 200,
                      child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        series: <CartesianSeries>[
                          LineSeries<ImpactData, String>(
                            dataSource: [
                              ImpactData('Jan', 8),
                              ImpactData('Feb', 12),
                              ImpactData('Mar', 15),
                              ImpactData('Apr', 18),
                              ImpactData('May', 22),
                              ImpactData('Jun', 28),
                            ],
                            xValueMapper: (ImpactData data, _) => data.month,
                            yValueMapper: (ImpactData data, _) => data.value,
                            color: Colors.green,
                            markerSettings: const MarkerSettings(isVisible: true),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Social Impact Card
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Social Impact',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _buildImpactMetric('1,240', 'People Fed'),
                        _buildImpactMetric('8', 'NGOs Supported'),
                        _buildImpactMetric('45 hrs', 'Volunteer Hours'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 200,
                      child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        series: <CartesianSeries>[
                          ColumnSeries<ImpactData, String>(
                            dataSource: [
                              ImpactData('Jan', 120),
                              ImpactData('Feb', 180),
                              ImpactData('Mar', 210),
                              ImpactData('Apr', 250),
                              ImpactData('May', 320),
                              ImpactData('Jun', 400),
                            ],
                            xValueMapper: (ImpactData data, _) => data.month,
                            yValueMapper: (ImpactData data, _) => data.value,
                            color: Colors.blue,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Impact Breakdown
            const Text(
              'Impact Breakdown by NGO',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 300,
              child: SfCircularChart(
                series: <CircularSeries>[
                  PieSeries<NGOData, String>(
                    dataSource: [
                      NGOData('Hope Foundation', 35),
                      NGOData('Community Kitchen', 28),
                      NGOData('Street Angels', 22),
                      NGOData('Food for All', 15),
                    ],
                    xValueMapper: (NGOData data, _) => data.name,
                    yValueMapper: (NGOData data, _) => data.percentage,
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImpactMetric(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class ImpactData {
  final String month;
  final int value;

  ImpactData(this.month, this.value);
}

class NGOData {
  final String name;
  final int percentage;

  NGOData(this.name, this.percentage);
}