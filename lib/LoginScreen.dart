import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/homescreen.dart';
import 'Admin/AdminLogin.dart';
import 'SignUpPage.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  bool _obscurePassword = true;
  bool _isLoading = false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (email.text.trim().isEmpty || password.text.trim().isEmpty) {
      _showSnackBar('Please fill in all fields', Color(0xFFD4A843));
      return;
    }
    setState(() => _isLoading = true);
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyApp()));
    } catch (e) {
      _showSnackBar(
          'Login failed. Please check your credentials.', Color(0xFF8B1A1A));
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
              clipper: _WaveClipper(),
              child: Container(
                height: screenHeight * 0.38,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF8B1A1A),
                      Color(0xFFA52A2A),
                      Color(0xFFB33A3A),
                    ],
                  ),
                ),
              ),
            ),

            // Decorative circles on header
            Positioned(
              top: -30,
              right: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),
            Positioned(
              top: 60,
              left: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.06),
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
                        SizedBox(height: 30),

                        // Logo on header
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(12),
                          child: Image.asset(
                            'assets/Splashimage.jpg',
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Welcome Back!',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Sign in to continue',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.08),

                        // Login Card
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 24),
                          padding: EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF8B1A1A).withOpacity(0.08),
                                blurRadius: 30,
                                offset: Offset(0, 10),
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Email field
                              _buildTextField(
                                controller: email,
                                hint: 'Email Address',
                                icon: Icons.email_outlined,
                                inputType: TextInputType.emailAddress,
                              ),
                              SizedBox(height: 18),
                              // Password field
                              _buildTextField(
                                controller: password,
                                hint: 'Password',
                                icon: Icons.lock_outline,
                                isPassword: true,
                              ),
                              SizedBox(height: 28),

                              // Login button
                              SizedBox(
                                width: double.infinity,
                                height: 54,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF8B1A1A),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 6,
                                    shadowColor:
                                        Color(0xFF8B1A1A).withOpacity(0.3),
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
                                          'LOGIN',
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

                        SizedBox(height: 24),

                        // Sign Up
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: TextStyle(color: Color(0xFF666666)),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        SignUpPage(),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      return SlideTransition(
                                        position: Tween<Offset>(
                                          begin: Offset(1.0, 0.0),
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
                                'Sign Up',
                                style: TextStyle(
                                  color: Color(0xFF8B1A1A),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 24),

                        // Divider with diamond
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Container(
                                      height: 1,
                                      color:
                                          Color(0xFFD4A843).withOpacity(0.3))),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 14),
                                child: Transform.rotate(
                                  angle: pi / 4,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFD4A843),
                                      borderRadius: BorderRadius.circular(1),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                      height: 1,
                                      color:
                                          Color(0xFFD4A843).withOpacity(0.3))),
                            ],
                          ),
                        ),

                        SizedBox(height: 24),

                        // Admin Login
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        AdminPage(),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      return SlideTransition(
                                        position: Tween<Offset>(
                                          begin: Offset(0, 1.0),
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
                              icon: Icon(Icons.admin_panel_settings_outlined,
                                  size: 20),
                              label: Text(
                                'Login as Mess Owner',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Color(0xFFD4A843),
                                side: BorderSide(
                                    color: Color(0xFFD4A843).withOpacity(0.5),
                                    width: 1.5),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                              ),
                            ),
                          ),
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
      cursorColor: Color(0xFF8B1A1A),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Color(0xFFAAAAAA)),
        prefixIcon:
            Icon(icon, color: Color(0xFF8B1A1A).withOpacity(0.6), size: 22),
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
          borderSide: BorderSide(color: Color(0xFF8B1A1A), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Color(0xFFE0D5C5)),
        ),
      ),
    );
  }
}

// Custom wave clipper for the header
class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 60);

    var firstControlPoint = Offset(size.width * 0.25, size.height);
    var firstEndPoint = Offset(size.width * 0.5, size.height - 40);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width * 0.75, size.height - 80);
    var secondEndPoint = Offset(size.width, size.height - 30);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
