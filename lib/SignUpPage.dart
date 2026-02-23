import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/LoginScreen.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>
    with SingleTickerProviderStateMixin {
  bool _obscurePassword = true;
  bool _isLoading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _slideAnim = Tween<Offset>(
      begin: Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String pass = passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || pass.isEmpty) {
      _showSnackBar('Please fill in all fields', Color(0xFFD4A843));
      return;
    }
    if (pass.length < 6) {
      _showSnackBar(
          'Password must be at least 6 characters', Color(0xFFD4A843));
      return;
    }

    setState(() => _isLoading = true);
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      await auth.createUserWithEmailAndPassword(email: email, password: pass);
      await FirebaseFirestore.instance.collection('users').doc(email).set({
        'name': name,
        'email': email,
        'password': pass,
      });
      _showSnackBar('Account created successfully!', Color(0xFF4CAF50));
      Future.delayed(Duration(milliseconds: 500), () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }
      });
    } catch (e) {
      _showSnackBar('Sign up failed: ${e.toString()}', Color(0xFF8B1A1A));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF8F0),
              Color(0xFFFFF1E6),
              Color(0xFFFFE8D6),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Curved header shape
            ClipPath(
              clipper: _WaveClipper2(),
              child: Container(
                height: screenHeight * 0.35,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFD4A843),
                      Color(0xFFC49535),
                      Color(0xFFB8892E),
                    ],
                  ),
                ),
              ),
            ),

            // Decorative shapes on header
            Positioned(
              top: -20,
              left: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: -30,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.07),
                ),
              ),
            ),
            // Small diamond decoration
            Positioned(
              top: 100,
              right: 50,
              child: Transform.rotate(
                angle: pi / 4,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),

            // Main content
            SafeArea(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: Column(
                      children: [
                        SizedBox(height: 24),

                        // Logo
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.12),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(10),
                          child: Image.asset(
                            'assets/Splashimage.jpg',
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Join the Bistro family',
                          style: TextStyle(fontSize: 13, color: Colors.white70),
                        ),

                        SizedBox(height: screenHeight * 0.06),

                        // Sign Up Card
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 24),
                          padding: EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFD4A843).withOpacity(0.1),
                                blurRadius: 30,
                                offset: Offset(0, 10),
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              _buildTextField(
                                controller: nameController,
                                hint: 'Full Name',
                                icon: Icons.person_outline,
                              ),
                              SizedBox(height: 16),
                              _buildTextField(
                                controller: emailController,
                                hint: 'Email Address',
                                icon: Icons.email_outlined,
                                inputType: TextInputType.emailAddress,
                              ),
                              SizedBox(height: 16),
                              _buildTextField(
                                controller: passwordController,
                                hint: 'Password',
                                icon: Icons.lock_outline,
                                isPassword: true,
                              ),
                              SizedBox(height: 28),

                              // Sign Up button (gold)
                              SizedBox(
                                width: double.infinity,
                                height: 54,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _signUp,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFD4A843),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 6,
                                    shadowColor:
                                        Color(0xFFD4A843).withOpacity(0.3),
                                  ),
                                  child: _isLoading
                                      ? SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                          ),
                                        )
                                      : Text(
                                          'CREATE ACCOUNT',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 2,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 28),

                        // Already have account
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: TextStyle(color: Color(0xFF666666)),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        LoginScreen(),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      return SlideTransition(
                                        position: Tween<Offset>(
                                          begin: Offset(-1.0, 0.0),
                                          end: Offset.zero,
                                        ).animate(CurvedAnimation(
                                            parent: animation,
                                            curve: Curves.easeOutCubic)),
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  color: Color(0xFF8B1A1A),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    TextInputType inputType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? _obscurePassword : false,
      keyboardType: inputType,
      style: TextStyle(color: Color(0xFF333333), fontSize: 15),
      cursorColor: Color(0xFFD4A843),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Color(0xFFAAAAAA)),
        prefixIcon:
            Icon(icon, color: Color(0xFFD4A843).withOpacity(0.7), size: 22),
        suffixIcon: isPassword
            ? GestureDetector(
                onTap: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
                child: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Color(0xFFAAAAAA),
                  size: 22,
                ),
              )
            : null,
        filled: true,
        fillColor: Color(0xFFF8F4F0),
        contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Color(0xFFD4A843), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Color(0xFFE0D5C5)),
        ),
      ),
    );
  }
}

class _WaveClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);

    var controlPoint = Offset(size.width * 0.5, size.height + 20);
    var endPoint = Offset(size.width, size.height - 50);
    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
