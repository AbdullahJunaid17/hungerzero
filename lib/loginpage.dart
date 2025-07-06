import 'package:flutter/material.dart';
import 'package:hungerzero/ngo.dart';
import 'package:hungerzero/signup.dart';
import 'restaurant.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _selectedRole = 'Restaurant';
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      _showSuccessMessage('Login successful!');

      // Navigate based on role
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) =>
                  _selectedRole == 'Restaurant'
                      ? const RestaurantHomePage()
                      : const NGOHomePage(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      _showErrorMessage(e.message ?? 'Login failed. Please try again.');
    } catch (e) {
      _showErrorMessage('Unexpected error. Try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background with subtle food pattern
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

          // Main content
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.1,
              vertical: 40,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo and header
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
                  Text(
                    'HungerZero',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange.shade800,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Connecting surplus to need',
                    style: TextStyle(
                      color: Colors.orange.shade700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Login card
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
                      child: Column(
                        children: [
                          // Role selector
                          DropdownButtonFormField<String>(
                            value: _selectedRole,
                            decoration: InputDecoration(
                              labelText: 'Login as',
                              labelStyle: TextStyle(
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.bold,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.orange.shade300,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.orange.shade50,
                              prefixIcon: Icon(
                                Icons.account_circle,
                                color: Colors.deepOrange,
                              ),
                            ),
                            items:
                                ['Restaurant', 'NGO'].map((role) {
                                  return DropdownMenuItem<String>(
                                    value: role,
                                    child: Text(
                                      role,
                                      style: const TextStyle(
                                        color: Colors.black87,
                                      ),
                                    ),
                                  );
                                }).toList(),
                            onChanged:
                                _isLoading
                                    ? null
                                    : (value) {
                                      if (value != null) {
                                        setState(() => _selectedRole = value);
                                      }
                                    },
                          ),
                          const SizedBox(height: 20),

                          // Username field
                          // Email field
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: Colors.deepOrange,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.deepOrange,
                                  width: 2,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              ).hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                            enabled: !_isLoading,
                          ),

                          const SizedBox(height: 10),
                          // Password field
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: Colors.deepOrange,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.deepOrange,
                                ),
                                onPressed:
                                    _isLoading
                                        ? null
                                        : () {
                                          setState(
                                            () =>
                                                _obscurePassword =
                                                    !_obscurePassword,
                                          );
                                        },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.deepOrange,
                                  width: 2,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                            enabled: !_isLoading,
                          ),
                          const SizedBox(height: 30),

                          // Login button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrange,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 5,
                              ),
                              child:
                                  _isLoading
                                      ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 3,
                                        ),
                                      )
                                      : const Text(
                                        'LOGIN',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Sign up prompt
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      GestureDetector(
                        onTap:
                            _isLoading
                                ? null
                                : () {
                                  _showSuccessMessage('Redirecting to sign up');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const SignupPage(),
                                    ),
                                  );
                                },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: _isLoading ? Colors.grey : Colors.deepOrange,
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
          ),
        ],
      ),
    );
  }
}
