import 'package:flutter/material.dart';
import 'package:hungerzero/restaurant.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';

class DonationFormStepper extends StatefulWidget {
  const DonationFormStepper({Key? key}) : super(key: key);

  @override
  _DonationFormStepperState createState() => _DonationFormStepperState();
}

class _DonationFormStepperState extends State<DonationFormStepper> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  List<XFile> _imageFiles = [];
  bool _isSubmitting = false;
  bool _isSubmissionComplete = false;
  final List<Uint8List> _webImages = [];

  // Form data
  String _foodType = 'Cooked Meals';
  String _foodDescription = '';
  String _unit = 'kg';
  int _quantity = 1;
  DateTime? _pickupTime;
  DateTime? _preparedAt;
  String _specialInstructions = '';
  bool _hasAllergens = false;

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'New Food Donation',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:
          _isSubmissionComplete
              ? _buildSuccessScreen()
              : Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Step Progress Indicator
                    Container(
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: List.generate(4, (index) {
                          return Expanded(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              height: 4,
                              decoration: BoxDecoration(
                                color:
                                    index <= _currentStep
                                        ? Colors.deepOrange
                                        : Colors.grey[300],
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    // Step Content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: Colors.deepOrange,
                            ),
                            inputDecorationTheme: InputDecorationTheme(
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                          ),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: _buildCurrentStep(),
                          ),
                        ),
                      ),
                    ),

                    // Navigation Buttons
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.white,
                      child: Row(
                        children: [
                          if (_currentStep > 0)
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  side: const BorderSide(
                                    color: Colors.deepOrange,
                                  ),
                                ),
                                onPressed: _cancel,
                                child: const Text(
                                  'Back',
                                  style: TextStyle(
                                    color: Colors.deepOrange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          if (_currentStep > 0) const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrange,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: _isSubmitting ? null : _continue,
                              child:
                                  _isSubmitting
                                      ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                      : Text(
                                        _currentStep == 3
                                            ? 'Submit Donation'
                                            : 'Continue',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
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

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildFoodDetailsStep();
      case 1:
        return _buildPickupDetailsStep();
      case 2:
        return _buildAdditionalInfoStep();
      case 3:
        return _buildReviewStep();
      default:
        return Container();
    }
  }

  Widget _buildFoodDetailsStep() {
    return Column(
      key: const ValueKey(0),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'What are you donating?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _foodType,
          decoration: const InputDecoration(
            labelText: 'Food Type',
            hintText: 'Select food category',
          ),
          items:
              [
                    'Cooked Meals',
                    'Packaged Food',
                    'Fresh Produce',
                    'Bakery Items',
                    'Dairy Products',
                    'Other',
                  ]
                  .map(
                    (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ),
                  )
                  .toList(),
          onChanged: (value) => setState(() => _foodType = value!),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: _foodDescription,
          decoration: const InputDecoration(
            labelText: 'Food Description',
            hintText: 'E.g. "Vegetable Biryani", "Mixed Fruit Basket"',
          ),
          validator: (value) {
            if (value == null || value.isEmpty)
              return 'Please describe the food';
            return null;
          },
          onChanged: (value) => setState(() => _foodDescription = value),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                initialValue: _quantity.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  hintText: 'Amount',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  final num = int.tryParse(value);
                  if (num == null) return 'Enter valid number';
                  if (num <= 0) return 'Must be at least 1';
                  if (num > 1000) return 'Maximum 1000';
                  return null;
                },
                onChanged:
                    (value) =>
                        setState(() => _quantity = int.tryParse(value) ?? 1),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: DropdownButtonFormField<String>(
                value: _unit,
                decoration: const InputDecoration(labelText: 'Unit'),
                items:
                    ['kg', 'liters', 'pieces', 'plates', 'packets', 'boxes']
                        .map(
                          (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ),
                        )
                        .toList(),
                onChanged: (value) => setState(() => _unit = value!),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPickupDetailsStep() {
    return Column(
      key: const ValueKey(1),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        GestureDetector(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now().subtract(const Duration(days: 1)),
              lastDate: DateTime.now(),
              builder:
                  (context, child) => Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: Colors.deepOrange,
                      ),
                    ),
                    child: child!,
                  ),
            );
            if (date != null) {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
                builder:
                    (context, child) => Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: Colors.deepOrange,
                        ),
                      ),
                      child: child!,
                    ),
              );
              if (time != null) {
                setState(() {
                  _preparedAt = DateTime(
                    date.year,
                    date.month,
                    date.day,
                    time.hour,
                    time.minute,
                  );
                });
              }
            }
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.schedule, color: Colors.deepOrange),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Prepared At',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _preparedAt == null
                          ? 'Select preparation time'
                          : DateFormat(
                            'EEE, MMM d • h:mm a',
                          ).format(_preparedAt!),
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),
        Text(
          'Pickup Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 7)),
              builder:
                  (context, child) => Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: Colors.deepOrange,
                      ),
                    ),
                    child: child!,
                  ),
            );
            if (date != null) {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
                builder:
                    (context, child) => Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: Colors.deepOrange,
                        ),
                      ),
                      child: child!,
                    ),
              );
              if (time != null) {
                setState(() {
                  _pickupTime = DateTime(
                    date.year,
                    date.month,
                    date.day,
                    time.hour,
                    time.minute,
                  );
                });
              }
            }
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.deepOrange),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pickup Time',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _pickupTime == null
                          ? 'Select date and time'
                          : DateFormat(
                            'EEE, MMM d • h:mm a',
                          ).format(_pickupTime!),
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Contains Allergens',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
              Switch(
                value: _hasAllergens,
                onChanged: (value) => setState(() => _hasAllergens = value),
                activeColor: Colors.deepOrange,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalInfoStep() {
    return Column(
      key: const ValueKey(2),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'Additional Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 24),
        TextFormField(
          maxLines: 4,
          initialValue: _specialInstructions,
          decoration: const InputDecoration(
            labelText: 'Special Instructions',
            hintText: 'E.g. "Vegetarian only", "Contains nuts"',
            alignLabelWithHint: true,
          ),
          onChanged: (value) => setState(() => _specialInstructions = value),
        ),
        /*const SizedBox(height: 24),
        Text(
          'Food Photos (Optional)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Add clear photos to help NGOs understand what you\'re donating',
          style: TextStyle(color: Colors.grey[600]),
        ),
        const SizedBox(height: 16),
        _imageFiles.isEmpty && _webImages.isEmpty
            ? GestureDetector(
              onTap: _pickImages,
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 1.5,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt, size: 36, color: Colors.grey[400]),
                    const SizedBox(height: 8),
                    Text(
                      'Tap to add photos',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            )
            : Column(
              children: [
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: kIsWeb ? _webImages.length : _imageFiles.length,
                    itemBuilder:
                        (context, index) => Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child:
                                    kIsWeb
                                        ? Image.memory(
                                          _webImages[index],
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        )
                                        : Image.file(
                                          File(_imageFiles[index].path),
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        ),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: GestureDetector(
                                  onTap:
                                      () => setState(() {
                                        if (kIsWeb) {
                                          _webImages.removeAt(index);
                                        } else {
                                          _imageFiles.removeAt(index);
                                        }
                                      }),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    child: const Icon(
                                      Icons.close,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: _pickImages,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.deepOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.deepOrange.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add_photo_alternate,
                          color: Colors.deepOrange,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Add more photos',
                          style: TextStyle(
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),*/
      ],
    );
  }

  Widget _buildReviewStep() {
    return Column(
      key: const ValueKey(3),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Center(
          child: Column(
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: 60,
                color: Colors.green,
              ),
              const SizedBox(height: 16),
              Text(
                'Review Your Donation',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please confirm all details before submitting',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
        _buildReviewItem('Food', '$_foodType - $_foodDescription'),
        _buildReviewItem('Quantity', '$_quantity $_unit'),
        _buildReviewItem(
          'Pickup Time',
          _pickupTime == null
              ? 'Not set'
              : DateFormat('EEE, MMM d • h:mm a').format(_pickupTime!),
        ),
        _buildReviewItem(
          'Allergens',
          _hasAllergens ? 'Contains allergens' : 'No allergens',
        ),
        if (_specialInstructions.isNotEmpty)
          _buildReviewItem('Special Instructions', _specialInstructions),
        if ((kIsWeb && _webImages.isNotEmpty) ||
            (!kIsWeb && _imageFiles.isNotEmpty)) ...[
          const SizedBox(height: 16),
          /*Text(
            'Photos',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),*/
          /*const SizedBox(height: 8),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: kIsWeb ? _webImages.length : _imageFiles.length,
              itemBuilder:
                  (context, index) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child:
                          kIsWeb
                              ? Image.memory(
                                _webImages[index],
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              )
                              : Image.file(
                                File(_imageFiles[index].path),
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                    ),
                  ),
            ),
          ),*/
        ],
      ],
    );
  }

  Widget _buildSuccessScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                size: 80,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Donation Posted!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Your food donation is now visible to NGOs in your area. '
              'They will contact you shortly to arrange pickup.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
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
                onPressed:
                    () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RestaurantHomePage(),
                      ),
                      (route) => false,
                    ),
                child: const Text(
                  'Back to Home',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => _resetForm(),
              child: const Text(
                'Post Another Donation',
                style: TextStyle(
                  color: Colors.deepOrange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.circle, size: 8, color: Colors.deepOrange),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Replace your _pickImages method with this improved version

  Future<void> _pickImages() async {
    try {
      final images = await _picker.pickMultiImage(
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (images != null && images.isNotEmpty) {
        final currentImageCount =
            kIsWeb ? _webImages.length : _imageFiles.length;

        if (currentImageCount + images.length > 5) {
          showError("Maximum 5 photos allowed");
          return;
        }

        if (kIsWeb) {
          for (final image in images) {
            try {
              final bytes = await image.readAsBytes();

              // Validate image size (max 5MB)
              if (bytes.lengthInBytes > 5 * 1024 * 1024) {
                showError("Image too large. Maximum size is 5MB.");
                continue;
              }

              _webImages.add(bytes);
            } catch (e) {
              debugPrint('Error reading image: $e');
              showError("Failed to process image");
            }
          }
        } else {
          for (final image in images) {
            try {
              final file = File(image.path);
              final fileSize = await file.length();

              // Validate image size (max 5MB)
              if (fileSize > 5 * 1024 * 1024) {
                showError("Image too large. Maximum size is 5MB.");
                continue;
              }

              _imageFiles.add(image);
            } catch (e) {
              debugPrint('Error validating image: $e');
              showError("Failed to process image");
            }
          }
        }

        setState(() {});
      }
    } catch (e) {
      debugPrint('Error picking images: $e');
      showError("Failed to pick images: ${e.toString()}");
    }
  }

  void _continue() {
    switch (_currentStep) {
      case 0:
        if (!_formKey.currentState!.validate()) return;
        break;
      case 1:
        if (_pickupTime == null) {
          showError("Please select pickup time");
          return;
        }
        break;
    }

    if (_currentStep < 3) {
      setState(() => _currentStep += 1);
    } else {
      _submitDonation();
    }
  }

  void _cancel() {
    if (_currentStep > 0) setState(() => _currentStep -= 1);
  }

  void _resetForm() {
    setState(() {
      _currentStep = 0;
      _isSubmitting = false;
      _isSubmissionComplete = false;
      _foodType = 'Cooked Meals';
      _foodDescription = '';
      _unit = 'kg';
      _quantity = 1;
      _pickupTime = null;
      _specialInstructions = '';
      _hasAllergens = false;
      _imageFiles = [];
      _webImages.clear();
    });
  }

  Future<void> _submitDonation() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        showError("You must be logged in to submit a donation");
        setState(() => _isSubmitting = false);
        return;
      }

      final restaurantId = user.uid;
      debugPrint('Submitting donation for restaurant: $restaurantId');

      // Fetch restaurant info
      final restaurantDoc =
          await FirebaseFirestore.instance
              .collection('restaurants')
              .doc(restaurantId)
              .get();

      if (!restaurantDoc.exists) {
        showError("Restaurant information not found");
        setState(() => _isSubmitting = false);
        return;
      }

      final restaurantData = restaurantDoc.data();
      final restaurantName =
          restaurantData?['restaurantName'] ?? 'Unknown Restaurant';
      final restaurantAddress =
          restaurantData?['address'] ?? 'Address not available';

      debugPrint('Restaurant data: $restaurantName, $restaurantAddress');

      // Upload images if available with proper error handling
      List<String> imageUrls = [];
      if (kIsWeb ? _webImages.isNotEmpty : _imageFiles.isNotEmpty) {
        try {
          debugPrint(
            'Uploading ${kIsWeb ? _webImages.length : _imageFiles.length} images',
          );

          if (kIsWeb) {
            // Web upload
            for (int i = 0; i < _webImages.length; i++) {
              try {
                final fileName = '${const Uuid().v4()}_$i.jpg';
                final ref = FirebaseStorage.instance
                    .ref()
                    .child('donation_images')
                    .child(fileName);

                debugPrint(
                  'Uploading web image $i, size: ${_webImages[i].lengthInBytes} bytes',
                );

                final uploadTask = ref.putData(
                  _webImages[i],
                  SettableMetadata(
                    contentType: 'image/jpeg',
                    customMetadata: {'uploaded_by': restaurantId},
                  ),
                );

                // Add timeout and progress tracking
                final snapshot = await uploadTask.timeout(
                  const Duration(minutes: 2),
                  onTimeout: () {
                    throw Exception('Upload timeout for image $i');
                  },
                );

                final downloadUrl = await snapshot.ref.getDownloadURL();
                imageUrls.add(downloadUrl);
                debugPrint('Web image $i uploaded successfully: $downloadUrl');
              } catch (e) {
                debugPrint('Failed to upload web image $i: $e');
                // Continue with other images instead of failing completely
                showError(
                  'Failed to upload image ${i + 1}, continuing with others',
                );
              }
            }
          } else {
            // Mobile upload
            for (int i = 0; i < _imageFiles.length; i++) {
              try {
                final file = File(_imageFiles[i].path);
                final fileName = '${const Uuid().v4()}_$i.jpg';
                final ref = FirebaseStorage.instance
                    .ref()
                    .child('donation_images')
                    .child(fileName);

                debugPrint(
                  'Uploading mobile image $i from path: ${_imageFiles[i].path}',
                );

                final uploadTask = ref.putFile(
                  file,
                  SettableMetadata(
                    contentType: 'image/jpeg',
                    customMetadata: {'uploaded_by': restaurantId},
                  ),
                );

                // Add timeout and progress tracking
                final snapshot = await uploadTask.timeout(
                  const Duration(minutes: 2),
                  onTimeout: () {
                    throw Exception('Upload timeout for image $i');
                  },
                );

                final downloadUrl = await snapshot.ref.getDownloadURL();
                imageUrls.add(downloadUrl);
                debugPrint(
                  'Mobile image $i uploaded successfully: $downloadUrl',
                );
              } catch (e) {
                debugPrint('Failed to upload mobile image $i: $e');
                // Continue with other images instead of failing completely
                showError(
                  'Failed to upload image ${i + 1}, continuing with others',
                );
              }
            }
          }

          if (imageUrls.isEmpty &&
              (kIsWeb ? _webImages.isNotEmpty : _imageFiles.isNotEmpty)) {
            showError('All image uploads failed. Submitting without images.');
          }
        } catch (e) {
          debugPrint('Image upload process failed: $e');
          showError(
            'Image upload failed, but continuing submission without images',
          );
          imageUrls = []; // Clear any partial uploads
        }
      }

      // Create donation document
      final donationData = {
        'title': _foodDescription,
        'quantity': _quantity,
        'allergens': _hasAllergens,
        'foodType': _foodType,
        'imageURLs': imageUrls,
        'instructions': _specialInstructions,
        'pickup': _pickupTime?.toIso8601String(),
        'preparedAt': _preparedAt?.toIso8601String(),
        'posted': DateTime.now().toIso8601String(),
        'restaurantId': restaurantId,
        'restaurantName': restaurantName,
        'restaurantAddress': restaurantAddress,
        'status': 'pending',
        'unit': _unit,
      };

      debugPrint('Submitting donation data: $donationData');

      // Submit to Firestore with timeout
      final docRef = await FirebaseFirestore.instance
          .collection('donations')
          .add(donationData)
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw Exception('Firestore submission timeout');
            },
          );

      debugPrint('Donation submitted with ID: ${docRef.id}');

      showSuccess('Donation posted successfully!');
      setState(() {
        _isSubmitting = false;
        _isSubmissionComplete = true;
      });
    } catch (e) {
      debugPrint('Error submitting donation: $e');
      showError('Failed to submit donation: ${e.toString()}');
      setState(() => _isSubmitting = false);
    }
  }
}
