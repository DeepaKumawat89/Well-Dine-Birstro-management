import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:project/LoginScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _fadeController;
  late AnimationController _rotateController;
  late Animation<double> _logoScale;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );
    _logoScale = CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 900),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _rotateController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 20),
    )..repeat();

    _logoController.forward();
    Future.delayed(Duration(milliseconds: 600), () {
      if (mounted) _fadeController.forward();
    });

    Timer(Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                LoginScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: Duration(milliseconds: 600),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _fadeController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            // Floating decorative blobs
            _buildFloatingBlob(
                top: -60,
                left: -40,
                size: 180,
                color: Color(0xFF8B1A1A).withOpacity(0.06)),
            _buildFloatingBlob(
                top: 100,
                right: -50,
                size: 140,
                color: Color(0xFFD4A843).withOpacity(0.08)),
            _buildFloatingBlob(
                bottom: 150,
                left: -30,
                size: 120,
                color: Color(0xFF8B1A1A).withOpacity(0.05)),
            _buildFloatingBlob(
                bottom: -40,
                right: -30,
                size: 160,
                color: Color(0xFFD4A843).withOpacity(0.07)),

            // Rotating ring decoration
            Positioned.fill(
              child: Center(
                child: AnimatedBuilder(
                  animation: _rotateController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotateController.value * 2 * pi,
                      child: Container(
                        width: 240,
                        height: 240,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xFFD4A843).withOpacity(0.15),
                            width: 1.5,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  ScaleTransition(
                    scale: _logoScale,
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF8B1A1A).withOpacity(0.15),
                            blurRadius: 40,
                            spreadRadius: 10,
                          ),
                          BoxShadow(
                            color: Color(0xFFD4A843).withOpacity(0.1),
                            blurRadius: 60,
                            spreadRadius: 5,
                          ),
                        ],
                        border: Border.all(
                          color: Color(0xFFD4A843).withOpacity(0.3),
                          width: 3,
                        ),
                      ),
                      padding: EdgeInsets.all(22),
                      child: Image.asset(
                        'assets/Splashimage.jpg',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  SizedBox(height: 36),

                  // App name
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        Text(
                          'Well Dine',
                          style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF8B1A1A),
                            letterSpacing: 2,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                width: 30, height: 2, color: Color(0xFFD4A843)),
                            SizedBox(width: 10),
                            Icon(Icons.restaurant,
                                color: Color(0xFFD4A843), size: 18),
                            SizedBox(width: 10),
                            Container(
                                width: 30, height: 2, color: Color(0xFFD4A843)),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          'BISTRO MANAGEMENT',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF8B1A1A).withOpacity(0.5),
                            letterSpacing: 6,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 80),

                  // Loading
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFFD4A843)),
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

  Widget _buildFloatingBlob({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double size,
    required Color color,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}
