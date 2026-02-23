import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/LoginScreen.dart';
import 'package:project/User/ViewMore.dart';

import 'Notification.dart';
import 'User/Userhomescreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onItemTapped(BuildContext context, int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Fluttertoast.showToast(msg: "Successfully Logged Out");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      print("Error for logout $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xFF8B1A1A),
        scaffoldBackgroundColor: Color(0xFFFFF8F0),
      ),
      home: Scaffold(
        backgroundColor: Color(0xFFFFF8F0),
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: Column(
              children: [
                // Custom App Bar (always visible)
                _buildAppBar(context),
                // Switch content based on selected tab
                Expanded(
                  child: IndexedStack(
                    index: _selectedIndex,
                    children: [
                      MyCardListView(),
                      UserHomeScreen(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomNav(context),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF8B1A1A).withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B1A1A).withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: -2,
          ),
        ],
      ),
      child: Row(
        children: [
          // 1. Premium Animated-looking Logo
          Container(
            padding: const EdgeInsets.all(2.5),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF8B1A1A), Color(0xFFD4A843)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage('assets/Splashimage.jpg'),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // 2. Brand Identity
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'WELL DINE',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF8B1A1A),
                    letterSpacing: 1.5,
                  ),
                ),
                Text(
                  'BISTRO & MESS SERVICE',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFD4A843),
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),

          // 3. Modern Action Buttons
          _buildIconButton(
            icon: Icons.notifications_none_rounded,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationPage()),
              );
            },
            hasBadge: true,
          ),
          const SizedBox(width: 8),
          _buildIconButton(
            icon: Icons.logout_rounded,
            onTap: () => _showLogoutDialog(context),
            isPrimary: true,
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
    bool hasBadge = false,
    bool isPrimary = false,
  }) {
    final bgColor = isPrimary
        ? const Color(0xFF8B1A1A).withOpacity(0.1)
        : const Color(0xFFF8F4F0);
    final iconColor =
        isPrimary ? const Color(0xFF8B1A1A) : const Color(0xFF555555);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isPrimary
                ? const Color(0xFF8B1A1A).withOpacity(0.1)
                : const Color(0xFFE8E0D5),
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, size: 22, color: iconColor),
            if (hasBadge)
              Positioned(
                top: 11,
                right: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4A843),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.logout_rounded, color: Color(0xFF8B1A1A), size: 24),
            SizedBox(width: 10),
            Text(
              'Logout',
              style: TextStyle(
                color: Color(0xFF333333),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: Color(0xFF666666)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: Color(0xFF999999))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF8B1A1A),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0xFF8B1A1A).withOpacity(0.06),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.restaurant_menu,
                label: 'Explore',
                isSelected: _selectedIndex == 0,
                onTap: () => _onItemTapped(context, 0),
              ),
              _buildNavItem(
                icon: Icons.person_outline,
                label: 'Profile',
                isSelected: _selectedIndex == 1,
                onTap: () => _onItemTapped(context, 1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 20 : 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? Color(0xFF8B1A1A).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? Color(0xFF8B1A1A) : Color(0xFFAAAAAA),
            ),
            if (isSelected) ...[
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: Color(0xFF8B1A1A),
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Card List View (Mess Listings)
// ─────────────────────────────────────────────────────────

class MyCardListView extends StatefulWidget {
  @override
  _MyCardListViewState createState() => _MyCardListViewState();
}

class _MyCardListViewState extends State<MyCardListView> {
  late Stream<QuerySnapshot> _messStream;
  TextEditingController _searchController = TextEditingController();
  late List<QueryDocumentSnapshot> _filteredMessList = [];
  late List<QueryDocumentSnapshot> _messDocs = [];

  @override
  void initState() {
    super.initState();
    _messStream =
        FirebaseFirestore.instance.collection('messDetails').snapshots();
  }

  void _filterMessList(String query) {
    setState(() {
      _filteredMessList = query.isEmpty
          ? _messDocs.toList()
          : _messDocs.where((mess) {
              final name = mess['name'].toString().toLowerCase();
              final address = mess['address'].toString().toLowerCase();
              return name.contains(query.toLowerCase()) ||
                  address.contains(query.toLowerCase());
            }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Discover Best Bites",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF333333),
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                "Premium mess services at your fingertips",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Search Bar
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF8B1A1A).withOpacity(0.05),
                  blurRadius: 15,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: Color(0xFF333333), fontSize: 15),
              cursorColor: Color(0xFF8B1A1A),
              decoration: InputDecoration(
                hintText: 'Search mess by name or location...',
                hintStyle: TextStyle(color: Color(0xFFBBBBBB), fontSize: 14),
                prefixIcon: Icon(Icons.search_rounded,
                    color: Color(0xFFD4A843), size: 24),
                suffixIcon: _searchController.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          _filterMessList('');
                        },
                        child: Icon(Icons.close, color: Color(0xFFAAAAAA)),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              ),
              onChanged: (value) => _filterMessList(value),
            ),
          ),
        ),

        SizedBox(height: 16),

        // Section title
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF8B1A1A), Color(0xFFD4A843)],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: 10),
              Text(
                'Available Mess',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF333333),
                ),
              ),
              Spacer(),
              Icon(Icons.tune_rounded, color: Color(0xFFAAAAAA), size: 20),
            ],
          ),
        ),

        SizedBox(height: 12),

        // Mess list
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _messStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF8B1A1A)),
                        strokeWidth: 2.5,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Loading mess listings...',
                        style:
                            TextStyle(color: Color(0xFF999999), fontSize: 14),
                      ),
                    ],
                  ),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline,
                          color: Color(0xFF8B1A1A), size: 48),
                      SizedBox(height: 12),
                      Text(
                        'Something went wrong',
                        style: TextStyle(
                            color: Color(0xFF333333),
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Error: ${snapshot.error}',
                        style: TextStyle(color: Color(0xFF999999)),
                      ),
                    ],
                  ),
                );
              }

              _messDocs = snapshot.data!.docs;

              final displayList = _searchController.text.isEmpty
                  ? _messDocs
                  : _filteredMessList;

              if (displayList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.restaurant_outlined,
                          color: Color(0xFFD4A843), size: 56),
                      SizedBox(height: 14),
                      Text(
                        'No mess found',
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Try a different search',
                        style: TextStyle(color: Color(0xFF999999)),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 80),
                physics: BouncingScrollPhysics(),
                itemCount: displayList.length,
                itemBuilder: (context, index) {
                  final messData =
                      displayList[index].data() as Map<String, dynamic>;

                  final String name = messData['name'] ?? '';
                  final String address = messData['address'] ?? '';
                  final String imageUrl = 'assets/Image${(index % 4) + 1}.jpg';

                  return Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: CustomCard(
                      name: name,
                      address: address,
                      imageUrl: imageUrl,
                      index: index,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Screen(
                              phoneNumber: _messDocs[index].id,
                              imageUrl: imageUrl,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
// Custom Mess Card
// ─────────────────────────────────────────────────────────

class CustomCard extends StatelessWidget {
  final String name;
  final String address;
  final String imageUrl;
  final VoidCallback onPressed;
  final int index;

  const CustomCard({
    required this.name,
    required this.address,
    required this.imageUrl,
    required this.onPressed,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    // Cycle through accent colors for variety
    final accentColors = [
      Color(0xFF8B1A1A),
      Color(0xFFD4A843),
      Color(0xFF2E7D5B),
      Color(0xFF4A6FA5),
    ];
    final accent = accentColors[index % accentColors.length];

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: accent.withOpacity(0.08),
              blurRadius: 20,
              offset: Offset(0, 8),
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with gradient overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  child: Container(
                    height: 170,
                    width: double.infinity,
                    child: Image.asset(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 170,
                          color: Color(0xFFF0E8D8),
                          child: Center(
                            child: Icon(
                              Icons.restaurant,
                              color: accent.withOpacity(0.3),
                              size: 50,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Bottom gradient overlay for readability
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.4),
                        ],
                      ),
                    ),
                  ),
                ),
                // Rating badge
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star_rounded,
                            color: Color(0xFFD4A843), size: 16),
                        SizedBox(width: 3),
                        Text(
                          '${(4.0 + (index % 10) * 0.1).toStringAsFixed(1)}',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Card Content
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Color accent bar
                  Container(
                    width: 4,
                    height: 40,
                    decoration: BoxDecoration(
                      color: accent,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(width: 12),
                  // Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF333333),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined,
                                size: 14, color: Color(0xFF999999)),
                            SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                address,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF999999),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Arrow button
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: accent.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: accent,
                      size: 20,
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
}
