import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:ghost_type/custom_app/screens/SplashScreen.dart';

class SignUpScreen extends StatefulWidget {
  final List<MorphingTextData>? initialTextItems;
  final List<bool>? initialTextStates;
  final List<double>? initialFloatOffsets;
  const SignUpScreen({
    super.key,
    this.initialTextItems,
    this.initialTextStates,
    this.initialFloatOffsets,
  });

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with TickerProviderStateMixin {
  late AnimationController _formController;
  late Animation<double> _scaleAnimation;
  late AnimationController _glassController;
  late Animation<double> _blurAnimation;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isObscure = true;

  @override
  void initState() {
    super.initState();
    _formController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _formController, curve: Curves.easeOutBack),
    );

    _glassController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _blurAnimation = Tween<double>(begin: 0.0, end: 8.0).animate(
      CurvedAnimation(parent: _glassController, curve: Curves.easeOutBack),
    );

    Future.delayed(Duration.zero, () {
      if (mounted) {
        _formController.forward();
        _glassController.forward();
      }
    });
  }

  @override
  void dispose() {
    _formController.dispose();
    _glassController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    // Placeholder for signup logic (implement as needed)
  }

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to dynamically adjust based on screen orientation and size
    final screenWidth = MediaQuery.of(context).size.width;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    // Use Scaffold with resizeToAvoidBottomInset to handle keyboard overflow
    return Scaffold(
      resizeToAvoidBottomInset: true, // Automatically adjust for keyboard
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Cosmic background (already optimized in SplashScreen)
          GhostTypeSplashScreen(
            enableNavigation: false,
            presetTextItems: widget.initialTextItems,
            initialTextStates: widget.initialTextStates,
            initialFloatOffsets: widget.initialFloatOffsets,
          ),
          // Glassmorphism overlay with subtle blur for modern aesthetic
          AnimatedBuilder(
            animation: _blurAnimation,
            builder: (context, child) {
              return BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: _blurAnimation.value, // Optimized blur for performance
                  sigmaY: _blurAnimation.value,
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.05), // Subtle overlay for glass effect
                ),
              );
            },
          ),
          // Use SingleChildScrollView to handle overflow in both vertical (keyboard) and horizontal (cropping) layouts
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20), // Responsive padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Maintain top-left alignment for welcome text
              children: [
                // Welcome text at top left, outside the centered form
                Padding(
                  padding: const EdgeInsets.only(left: 0, top: 30), // Adjust padding for top-left positioning
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome to',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            shadows: [
                              Shadow(
                                blurRadius: 12,
                                color: Colors.blueAccent.withOpacity(0.4),
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'GhostType',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 35,
                            shadows: [
                              Shadow(
                                blurRadius: 12,
                                color: Colors.blueAccent.withOpacity(0.4),
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 75), // Space between welcome text and centered form
                // Centered form container with modern, aesthetic design, now responsive to screen orientation
                Center(
                  child: ScaleTransition(
                    scale: _scaleAnimation, // Maintain smooth form entrance animation
                    child: Container(
                      padding: const EdgeInsets.all(24.0),
                      // Dynamic width based on screen orientation and size for responsiveness
                      constraints: BoxConstraints(
                        maxWidth: isLandscape ? screenWidth * 0.8 : 400, // 80% of screen width in landscape, 400px in portrait
                        maxHeight: double.infinity, // Allow flexible height for scrolling
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(color: Colors.white.withOpacity(0.1), width: 0.5),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.cyan.withOpacity(0.1),
                            Colors.purple.withOpacity(0.1),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueAccent.withOpacity(0.2),
                            blurRadius: 20.0,
                            spreadRadius: -5.0,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min, // Minimize height for centering and scrolling
                          children: [
                            Text(
                              'Create an Account',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                shadows: [
                                  Shadow(
                                    blurRadius: 12,
                                    color: Colors.blueAccent.withOpacity(0.4),
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 30),
                            // Email field
                            _buildInputField(
                              controller: _emailController,
                              label: 'Email Address',
                              icon: Icons.email,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16.0),
                            // Username field
                            _buildInputField(
                              controller: _usernameController,
                              label: 'Username',
                              icon: Icons.person,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your username';
                                }
                                if (value.length < 3) {
                                  return 'Username must be at least 3 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16.0),
                            // Password field
                            _buildInputField(
                              controller: _passwordController,
                              label: 'Password',
                              icon: Icons.lock,
                              obscureText: _isObscure,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscure ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                },
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
                            ),
                            const SizedBox(height: 24.0),
                            // Sign Up button
                            _buildButton(
                              text: 'Sign Up',
                              onTap: _submit,
                            ),
                            const SizedBox(height: 16.0),
                            // Login redirect
                            TextButton(
                              onPressed: () {
                                // Navigate to login screen (implement as needed)
                                Navigator.pushNamed(context, '/login');
                              },
                              child: Text(
                                'Already have an account? Log In',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: 'Poppins',
                                  color: Colors.white.withOpacity(0.7),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300), // Smooth transition for performance
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.7)),
          suffixIcon: suffixIcon,
          labelStyle: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontFamily: 'Poppins',
            fontSize: 16.0,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
          ),
          filled: true,
          fillColor: Colors.black.withOpacity(0.1), // Glass-like fill
        ),
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Poppins',
          fontSize: 16.0,
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildButton({required String text, required VoidCallback onTap}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Material(
        borderRadius: BorderRadius.circular(15.0),
        elevation: 4.0,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15.0),
          onHover: (hovering) {
            // No state change needed, animation handles it
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.cyan.withOpacity(0.8),
                  Colors.purple.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.withOpacity(0.3),
                  blurRadius: 10.0,
                  spreadRadius: -2.0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 8,
                      color: Colors.blueAccent.withOpacity(0.3),
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}