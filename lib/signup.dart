import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String _selectedRole = 'Restaurant';
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Restaurant Controllers
  final _restaurantNameController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _addressController = TextEditingController();
  final _fssaiController = TextEditingController();
  final _operatingHoursController = TextEditingController();

  // NGO Controllers
  final _ngoNameController = TextEditingController();
  final _representativeNameController = TextEditingController();
  final _ngoRegController = TextEditingController();
  final _serviceAreasController = TextEditingController();

  @override
  void dispose() {
    _restaurantNameController.dispose();
    _ownerNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _addressController.dispose();
    _fssaiController.dispose();
    _operatingHoursController.dispose();
    _ngoNameController.dispose();
    _representativeNameController.dispose();
    _ngoRegController.dispose();
    _serviceAreasController.dispose();
    super.dispose();
  }

  void _handleSignup() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate signup process
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_selectedRole} account created successfully!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      Navigator.pop(context);
    });
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.deepOrange.shade800),
      prefixIcon: Icon(icon, color: Colors.deepOrange),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.orange.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.deepOrange, width: 2),
      ),
      filled: true,
      fillColor: Colors.orange.shade50,
    );
  }

  Widget _buildRoleSpecificFields() {
    if (_selectedRole == 'Restaurant') {
      return Column(
        children: [
          // Owner/Manager Name
          TextFormField(
            controller: _ownerNameController,
            decoration: _buildInputDecoration(
              'Owner/Manager Name',
              Icons.person,
            ),
            validator: (value) => value!.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 20),

          // FSSAI License
          TextFormField(
            controller: _fssaiController,
            decoration: _buildInputDecoration(
              'FSSAI License Number',
              Icons.assignment,
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) return 'Required';
              if (!RegExp(r'^[0-9]{14}$').hasMatch(value)) {
                return 'Must be 14 digits';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Operating Hours
          TextFormField(
            controller: _operatingHoursController,
            decoration: _buildInputDecoration(
              'Operating Hours (e.g. 9AM-10PM)',
              Icons.access_time,
            ),
            validator: (value) => value!.isEmpty ? 'Required' : null,
          ),
        ],
      );
    } else {
      return Column(
        children: [
          // Representative Name
          TextFormField(
            controller: _representativeNameController,
            decoration: _buildInputDecoration(
              'Representative Name',
              Icons.person,
            ),
            validator: (value) => value!.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 20),

          // NGO Registration
          TextFormField(
            controller: _ngoRegController,
            decoration: _buildInputDecoration(
              'NGO Registration Number',
              Icons.assignment_ind,
            ),
            validator: (value) => value!.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 20),

          // Service Areas
          TextFormField(
            controller: _serviceAreasController,
            decoration: _buildInputDecoration(
              'Areas of Operation (e.g. Mumbai, Delhi)',
              Icons.map,
            ),
            validator: (value) => value!.isEmpty ? 'Required' : null,
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              image: const DecorationImage(
                image: AssetImage('assets/images/food_pattern.png'),
                fit: BoxFit.cover,
                opacity: 0.1,
              ),
            ),
          ),

          SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.1,
              vertical: 40,
            ),
            child: Column(
              children: [
                // Logo
                Hero(
                  tag: 'app-logo',
                  child: Material(
                    color: Colors.transparent,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.deepOrange.withOpacity(0.2),
                      child: Icon(
                        Icons.restaurant_rounded,
                        size: 50,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  'Join HungerZero',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange.shade800,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Reduce waste. Feed communities.',
                  style: TextStyle(color: Colors.orange.shade700, fontSize: 16),
                ),
                const SizedBox(height: 40),

                // Signup Card
                Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Role Selector
                          DropdownButtonFormField<String>(
                            value: _selectedRole,
                            decoration: _buildInputDecoration(
                              'I am a',
                              Icons.account_circle,
                            ),
                            items:
                                ['Restaurant', 'NGO'].map((role) {
                                  return DropdownMenuItem<String>(
                                    value: role,
                                    child: Text(role),
                                  );
                                }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _selectedRole = value);
                              }
                            },
                          ),
                          const SizedBox(height: 20),

                          // Organization Name
                          TextFormField(
                            controller:
                                _selectedRole == 'Restaurant'
                                    ? _restaurantNameController
                                    : _ngoNameController,
                            decoration: _buildInputDecoration(
                              _selectedRole == 'Restaurant'
                                  ? 'Restaurant Name'
                                  : 'NGO Name',
                              Icons.business,
                            ),
                            validator:
                                (value) => value!.isEmpty ? 'Required' : null,
                          ),
                          const SizedBox(height: 20),

                          // Email
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: _buildInputDecoration(
                              'Email',
                              Icons.email,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) return 'Required';
                              if (!RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              ).hasMatch(value)) {
                                return 'Invalid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // Phone
                          TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: _buildInputDecoration(
                              'Phone Number',
                              Icons.phone,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) return 'Required';
                              if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                                return 'Must be 10 digits';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // Address
                          TextFormField(
                            controller: _addressController,
                            decoration: _buildInputDecoration(
                              'Full Address with Pincode',
                              Icons.location_on,
                            ),
                            validator:
                                (value) => value!.isEmpty ? 'Required' : null,
                          ),
                          const SizedBox(height: 20),

                          // Password
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: _buildInputDecoration(
                              'Password',
                              Icons.lock,
                            ).copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.deepOrange,
                                ),
                                onPressed: () {
                                  setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  );
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) return 'Required';
                              if (value.length < 8)
                                return 'Minimum 8 characters';
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // Confirm Password
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            decoration: _buildInputDecoration(
                              'Confirm Password',
                              Icons.lock_outline,
                            ).copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.deepOrange,
                                ),
                                onPressed: () {
                                  setState(
                                    () =>
                                        _obscureConfirmPassword =
                                            !_obscureConfirmPassword,
                                  );
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // Role-specific fields
                          _buildRoleSpecificFields(),
                          const SizedBox(height: 25),

                          // Terms Checkbox
                          Row(
                            children: [
                              Checkbox(
                                value: true,
                                onChanged: (v) {},
                                activeColor: Colors.deepOrange,
                              ),
                              const Text('I agree to the '),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Terms & Conditions',
                                  style: TextStyle(color: Colors.deepOrange),
                                ),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Signup Button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleSignup,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 5,
                              ),
                              child:
                                  _isLoading
                                      ? const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      )
                                      : const Text(
                                        'SIGN UP',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // Login Prompt
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
