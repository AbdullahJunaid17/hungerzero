import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaxDocumentsScreen extends StatelessWidget {
  const TaxDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tax Documents'),
        backgroundColor: Colors.deepOrange,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {},
            tooltip: 'Download All',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildYearSection('2023', [
            _buildDocumentItem(
              'Q1 Donation Receipt',
              'Jan-Mar 2023',
              'PDF',
              '2.4 MB',
            ),
            _buildDocumentItem(
              'Q2 Donation Receipt',
              'Apr-Jun 2023',
              'PDF',
              '3.1 MB',
            ),
          ]),
          _buildYearSection('2022', [
            _buildDocumentItem('Annual Summary', '2022', 'PDF', '4.5 MB'),
            _buildDocumentItem(
              'Q3 Donation Receipt',
              'Jul-Sep 2022',
              'PDF',
              '2.8 MB',
            ),
            _buildDocumentItem(
              'Q4 Donation Receipt',
              'Oct-Dec 2022',
              'PDF',
              '3.0 MB',
            ),
          ]),
          _buildYearSection('2021', [
            _buildDocumentItem('Annual Summary', '2021', 'PDF', '4.2 MB'),
          ]),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.request_page),
        onPressed: () => _showRequestForm(context),
      ),
    );
  }

  Widget _buildYearSection(String year, List<Widget> documents) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            year,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ...documents,
        const Divider(),
      ],
    );
  }

  Widget _buildDocumentItem(
    String title,
    String period,
    String type,
    String size,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
        title: Text(title),
        subtitle: Text('$period • $type • $size'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.visibility), onPressed: () {}),
            IconButton(icon: const Icon(Icons.download), onPressed: () {}),
          ],
        ),
      ),
    );
  }

  void _showRequestForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Request Tax Document',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Document Type',
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                  onTap: () => _showDocumentTypePicker(context),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Time Period',
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                  onTap: () => _showDateRangePicker(context),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Additional Notes',
                    border: OutlineInputBorder(),
                    hintText: 'Special requests or details',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Request submitted successfully!'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                    ),
                    child: const Text('Submit Request'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
    );
  }

  void _showDocumentTypePicker(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => SimpleDialog(
            title: const Text('Select Document Type'),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  // Update the text field
                },
                child: const Text('Quarterly Donation Receipt'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  // Update the text field
                },
                child: const Text('Annual Summary'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  // Update the text field
                },
                child: const Text('Tax Deduction Certificate'),
              ),
            ],
          ),
    );
  }

  void _showDateRangePicker(BuildContext context) {
    showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value != null) {
        // Update the text field
      }
    });
  }
}
