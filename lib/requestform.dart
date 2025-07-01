import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hungerzero/ngo.dart';

class NGORequestFormScreen extends StatefulWidget {
  final String restaurantName;
  final String foodItems;
  final String imageUrl;

  const NGORequestFormScreen({
    Key? key,
    required this.restaurantName,
    required this.foodItems,
    required this.imageUrl,
  }) : super(key: key);

  @override
  _NGORequestFormScreenState createState() => _NGORequestFormScreenState();
}

class _NGORequestFormScreenState extends State<NGORequestFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pickupTimeController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isSubmitting = false;
  String? _selectedVehicle;

  Future<void> _selectDateTime(BuildContext context) async {
    try {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 30)),
      );

      if (pickedDate != null) {
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );

        if (pickedTime != null) {
          setState(() {
            _selectedDate = pickedDate;
            _selectedTime = pickedTime;
            _pickupTimeController.text =
                '${DateFormat('MMM d, yyyy').format(pickedDate)} at ${pickedTime.format(context)}';
          });
        }
      }
    } catch (e) {
      _showErrorMessage('Failed to select date/time: ${e.toString()}');
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedVehicle == null) {
      _showErrorMessage('Please select a vehicle type');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // If successful, show confirmation
      _showSuccessDialog(context);
    } catch (e) {
      _showErrorMessage('Submission failed: ${e.toString()}');
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Request Pickup',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Donation Summary Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Donation from ${widget.restaurantName}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      Icons.fastfood,
                      'Food Items:',
                      widget.foodItems,
                    ),
                    const Divider(height: 24),
                    _buildDetailRow(
                      Icons.access_time,
                      'Posted:',
                      DateFormat('MMM d, h:mm a').format(DateTime.now()),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Request Form
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Request Details',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Pickup Time
                  TextFormField(
                    controller: _pickupTimeController,
                    decoration: InputDecoration(
                      labelText: 'Preferred Pickup Time',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.calendar_today),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed:
                            _isSubmitting
                                ? null
                                : () => _selectDateTime(context),
                      ),
                    ),
                    readOnly: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select pickup time';
                      }
                      return null;
                    },
                    onTap:
                        _isSubmitting ? null : () => _selectDateTime(context),
                  ),
                  const SizedBox(height: 16),

                  // Requested Amount
                  TextFormField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      labelText: 'Requested Amount (kg)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.scale),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter amount';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter valid number';
                      }
                      if (double.parse(value) <= 0) {
                        return 'Amount must be greater than 0';
                      }
                      return null;
                    },
                    enabled: !_isSubmitting,
                  ),
                  const SizedBox(height: 16),

                  // Special Instructions
                  TextFormField(
                    controller: _instructionsController,
                    decoration: InputDecoration(
                      labelText: 'Special Instructions',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.note_add),
                    ),
                    maxLines: 3,
                    enabled: !_isSubmitting,
                  ),
                  const SizedBox(height: 24),

                  // Vehicle Type Selection
                  const Text(
                    'Vehicle Type',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildVehicleChip('Bike'),
                      _buildVehicleChip('Car'),
                      _buildVehicleChip('Truck'),
                      _buildVehicleChip('Van'),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child:
                          _isSubmitting
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                              : const Text(
                                'Submit Request',
                                style: TextStyle(fontSize: 16),
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
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
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleChip(String label) {
    return ChoiceChip(
      label: Text(label),
      selected: _selectedVehicle == label,
      onSelected:
          _isSubmitting
              ? null
              : (selected) {
                setState(() => _selectedVehicle = selected ? label : null);
              },
      selectedColor: Colors.deepOrange.withOpacity(0.2),
      labelStyle: TextStyle(
        color: _selectedVehicle == label ? Colors.deepOrange : Colors.black,
      ),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.deepOrange),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirm Request'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pickup Time: ${_pickupTimeController.text}'),
                Text('Amount: ${_amountController.text} kg'),
                Text('Vehicle: $_selectedVehicle'),
                if (_instructionsController.text.isNotEmpty)
                  Text('Instructions: ${_instructionsController.text}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _submitForm();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                ),
                child: const Text('Confirm'),
              ),
            ],
          ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 60,
            ),
            content: const Text(
              'Request submitted successfully!',
              textAlign: TextAlign.center,
            ),
            actions: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => NGOHomePage()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                  ),
                  child: const Text('Return to Home'),
                ),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _pickupTimeController.dispose();
    _amountController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }
}
