import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NGOSettingsScreen extends StatefulWidget {
  const NGOSettingsScreen({super.key});

  @override
  State<NGOSettingsScreen> createState() => _NGOSettingsScreenState();
}

class _NGOSettingsScreenState extends State<NGOSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _areasController;
  late TextEditingController _registrationController;
  late TextEditingController _representativeController;

  bool _notificationsEnabled = true;
  bool _autoAcceptDonations = false;
  String _deliveryRadius = '10';
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _areasController = TextEditingController();
    _registrationController = TextEditingController();
    _representativeController = TextEditingController();
    _loadNGOData();
  }

  Future<void> _loadNGOData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final doc = await _firestore.collection('ngos').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          _nameController.text = data['ngoName'] ?? '';
          _emailController.text = data['email'] ?? '';
          _phoneController.text = data['phone'] ?? '';
          _addressController.text = data['address'] ?? '';
          _areasController.text = data['areas'] ?? '';
          _registrationController.text = data['ngoRegistration'] ?? '';
          _representativeController.text = data['representativeName'] ?? '';
          // These fields might not exist in DB, so we provide defaults
          _notificationsEnabled = data['notificationsEnabled'] ?? true;
          _autoAcceptDonations = data['autoAcceptDonations'] ?? false;
          _deliveryRadius = data['deliveryRadius']?.toString() ?? '10';
          _isLoading = false;
        });
      } else {
        // If no document exists, create one with default values
        await _firestore.collection('ngos').doc(user.uid).set({
          'ngoName': '',
          'email': user.email,
          'phone': '',
          'address': '',
          'areas': '',
          'ngoRegistration': '',
          'representativeName': '',
          'notificationsEnabled': true,
          'autoAcceptDonations': false,
          'deliveryRadius': 10,
          'createdAt': FieldValue.serverTimestamp(),
        });
        setState(() => _isLoading = false);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: ${e.toString()}')),
      );
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await _firestore.collection('ngos').doc(user.uid).update({
        'ngoName': _nameController.text,
        'phone': _phoneController.text,
        'address': _addressController.text,
        'areas': _areasController.text,
        'ngoRegistration': _registrationController.text,
        'representativeName': _representativeController.text,
        // These are additional fields we're adding
        'notificationsEnabled': _notificationsEnabled,
        'autoAcceptDonations': _autoAcceptDonations,
        'deliveryRadius': int.parse(_deliveryRadius),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings saved successfully!'),
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
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _areasController.dispose();
    _registrationController.dispose();
    _representativeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NGO Settings'),
        backgroundColor: Colors.deepOrange,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Organization Information
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
                                  Icon(Icons.people, color: Colors.deepOrange),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Organization Information',
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
                              _buildTextFormField(
                                controller: _nameController,
                                label: 'NGO Name',
                                icon: Icons.people,
                                validator:
                                    (value) =>
                                        value!.isEmpty ? 'Required' : null,
                              ),
                              _buildTextFormField(
                                controller: _emailController,
                                label: 'Email',
                                icon: Icons.email,
                                enabled:
                                    false, // Email shouldn't be editable here
                              ),
                              _buildTextFormField(
                                controller: _phoneController,
                                label: 'Phone Number',
                                icon: Icons.phone,
                                keyboardType: TextInputType.phone,
                                validator:
                                    (value) =>
                                        value!.isEmpty ? 'Required' : null,
                              ),
                              _buildTextFormField(
                                controller: _addressController,
                                label: 'Address',
                                icon: Icons.location_on,
                                maxLines: 2,
                                validator:
                                    (value) =>
                                        value!.isEmpty ? 'Required' : null,
                              ),
                              _buildTextFormField(
                                controller: _areasController,
                                label: 'Areas of Operation',
                                icon: Icons.map,
                                validator:
                                    (value) =>
                                        value!.isEmpty ? 'Required' : null,
                              ),
                              _buildTextFormField(
                                controller: _registrationController,
                                label: 'NGO Registration Number',
                                icon: Icons.assignment,
                                validator:
                                    (value) =>
                                        value!.isEmpty ? 'Required' : null,
                              ),
                              _buildTextFormField(
                                controller: _representativeController,
                                label: 'Representative Name',
                                icon: Icons.person,
                                validator:
                                    (value) =>
                                        value!.isEmpty ? 'Required' : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Operation Preferences
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
                                  Icon(
                                    Icons.settings,
                                    color: Colors.deepOrange,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Operation Preferences',
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
                              _buildSwitchTile(
                                value: _notificationsEnabled,
                                onChanged:
                                    (value) => setState(
                                      () => _notificationsEnabled = value,
                                    ),
                                title: 'Enable Notifications',
                                subtitle: 'Receive alerts about new donations',
                              ),
                              _buildSwitchTile(
                                value: _autoAcceptDonations,
                                onChanged:
                                    (value) => setState(
                                      () => _autoAcceptDonations = value,
                                    ),
                                title: 'Auto-Accept Verified Donations',
                                subtitle:
                                    'Automatically accept donations from verified sources',
                              ),
                              const SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Maximum Pickup Radius',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '$_deliveryRadius km',
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                    Slider(
                                      value: double.parse(_deliveryRadius),
                                      min: 1,
                                      max: 30,
                                      divisions: 29,
                                      activeColor: Colors.deepOrange,
                                      inactiveColor: Colors.grey.shade300,
                                      label: _deliveryRadius,
                                      onChanged:
                                          (value) => setState(
                                            () =>
                                                _deliveryRadius =
                                                    value.toInt().toString(),
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

                      // Security Section
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
                                  Icon(
                                    Icons.security,
                                    color: Colors.deepOrange,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Security',
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
                              _buildListTile(
                                icon: Icons.lock,
                                title: 'Change Password',
                                onTap: () => _showChangePasswordDialog(context),
                              ),
                              _buildListTile(
                                icon: Icons.verified_user,
                                title: 'Verification Documents',
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _saveChanges,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child:
                              _isSaving
                                  ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                  : const Text(
                                    'SAVE CHANGES',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hintText,
    int? maxLines = 1,
    bool enabled = true,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          prefixIcon: Icon(icon, color: Colors.deepOrange),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          filled: true,
          fillColor: enabled ? Colors.white : Colors.grey.shade100,
        ),
        maxLines: maxLines,
        enabled: enabled,
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }

  Widget _buildSwitchTile({
    required bool value,
    required ValueChanged<bool> onChanged,
    required String title,
    String? subtitle,
  }) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      visualDensity: VisualDensity.compact,
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
      ),
      subtitle:
          subtitle != null
              ? Text(subtitle, style: Theme.of(context).textTheme.bodySmall)
              : null,
      value: value,
      onChanged: onChanged,
      activeColor: Colors.deepOrange,
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(icon, color: Colors.deepOrange),
          title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          onTap: onTap,
        ),
        const Divider(height: 1),
      ],
    );
  }

  Future<void> _showChangePasswordDialog(BuildContext context) async {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Change Password'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: currentPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Current Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'New Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirm New Password',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                ),
                onPressed: () async {
                  if (newPasswordController.text !=
                      confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Passwords do not match!')),
                    );
                    return;
                  }

                  try {
                    final user = _auth.currentUser;
                    if (user != null) {
                      // Reauthenticate first
                      final cred = EmailAuthProvider.credential(
                        email: user.email!,
                        password: currentPasswordController.text,
                      );
                      await user.reauthenticateWithCredential(cred);

                      // Then update password
                      await user.updatePassword(newPasswordController.text);

                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Password changed successfully!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } on FirebaseAuthException catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: ${e.message}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text('Update'),
              ),
            ],
          ),
    );

    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
  }
}
