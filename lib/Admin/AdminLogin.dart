import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/Admin/AdminDashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage>
    with SingleTickerProviderStateMixin {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _obscurePassword = true;
  bool _isLoading = false;

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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
            // Diagonal header shape
            ClipPath(
              clipper: _DiagonalClipper(),
              child: Container(
                height: screenHeight * 0.40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF2C2C2C),
                      Color(0xFF3D3D3D),
                      Color(0xFF4A4A4A),
                    ],
                  ),
                ),
              ),
            ),

            // Decorative hexagon-like shapes
            Positioned(
              top: 40,
              right: 30,
              child: Transform.rotate(
                angle: pi / 6,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.1), width: 1.5),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 80,
              left: 20,
              child: Transform.rotate(
                angle: pi / 4,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Color(0xFFD4A843).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 20,
              left: 60,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFD4A843).withOpacity(0.5),
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
                        SizedBox(height: 12),

                        // Back button
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(Icons.arrow_back_ios_new,
                                  color: Colors.white70, size: 20),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.1),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 10),

                        // Admin icon with shield shape
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFD4A843), Color(0xFFC49535)],
                            ),
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFD4A843).withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 3,
                              ),
                            ],
                          ),
                          child: Icon(Icons.admin_panel_settings,
                              color: Colors.white, size: 45),
                        ),

                        SizedBox(height: 16),

                        Text(
                          'Mess Owner',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 6),
                        // Admin badge
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                          decoration: BoxDecoration(
                            color: Color(0xFFD4A843).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Color(0xFFD4A843).withOpacity(0.4)),
                          ),
                          child: Text(
                            'ADMIN ACCESS',
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFFD4A843),
                              letterSpacing: 3,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.06),

                        // Login card
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 24),
                          padding: EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF2C2C2C).withOpacity(0.08),
                                blurRadius: 30,
                                offset: Offset(0, 10),
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Restricted banner
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFFF8F0),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color:
                                          Color(0xFFD4A843).withOpacity(0.3)),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.shield_outlined,
                                        color: Color(0xFFD4A843), size: 18),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'Restricted to mess owners only',
                                        style: TextStyle(
                                          color: Color(0xFF8B7640),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),

                              _buildTextField(
                                controller: _emailController,
                                hint: 'Admin Email',
                                icon: Icons.email_outlined,
                                inputType: TextInputType.emailAddress,
                              ),
                              SizedBox(height: 16),
                              _buildTextField(
                                controller: _passwordController,
                                hint: 'Password',
                                icon: Icons.lock_outline,
                                isPassword: true,
                              ),
                              SizedBox(height: 28),

                              // Admin login button
                              SizedBox(
                                width: double.infinity,
                                height: 54,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF2C2C2C),
                                        Color(0xFF3D3D3D)
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Color(0xFF2C2C2C).withOpacity(0.25),
                                        blurRadius: 14,
                                        offset: Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _signIn,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
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
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.login, size: 20),
                                              SizedBox(width: 10),
                                              Text(
                                                'ADMIN LOGIN',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 2,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ),
                            ],
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
      cursorColor: Color(0xFF2C2C2C),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Color(0xFFAAAAAA)),
        prefixIcon:
            Icon(icon, color: Color(0xFF2C2C2C).withOpacity(0.5), size: 22),
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
          borderSide: BorderSide(color: Color(0xFF2C2C2C), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Color(0xFFE0D5C5)),
        ),
      ),
    );
  }

  void _signIn() async {
    String enteredEmail = _emailController.text.toString().trim();
    String enteredPassword = _passwordController.text.toString().trim();

    if (enteredEmail.isEmpty || enteredPassword.isEmpty) {
      _showSnackBar('Please fill in all fields', Color(0xFFD4A843));
      return;
    }

    setState(() => _isLoading = true);

    try {
      var docSnapshot =
          await _firestore.collection('messOwner').doc(enteredEmail).get();

      if (docSnapshot.exists) {
        try {
          final FirebaseAuth auth = FirebaseAuth.instance;
          await auth.signInWithEmailAndPassword(
              email: enteredEmail, password: enteredPassword);
          Fluttertoast.showToast(msg: 'Welcome, Admin!');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminDashboard()),
          );
        } catch (e) {
          _showSnackBar('Invalid password', Color(0xFF8B1A1A));
        }
      } else {
        _showSnackBar('Email not found in admin records', Color(0xFF8B1A1A));
      }
    } catch (e) {
      _showSnackBar('An error occurred. Please try again.', Color(0xFF8B1A1A));
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
}

// Diagonal clip path for admin header
class _DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    path.lineTo(size.width, size.height - 30);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
