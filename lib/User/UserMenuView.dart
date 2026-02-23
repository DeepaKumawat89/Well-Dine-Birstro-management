import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserMenuView extends StatefulWidget {
  final String? messOwnerEmail; // Optional: If passed, show this mess's menu

  const UserMenuView({super.key, this.messOwnerEmail});

  @override
  State<UserMenuView> createState() => _UserMenuViewState();
}

class _UserMenuViewState extends State<UserMenuView> {
  late String? userEmail;
  String? joinedMessEmail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (widget.messOwnerEmail != null) {
      setState(() {
        joinedMessEmail = widget.messOwnerEmail;
        isLoading = false;
      });
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      userEmail = user?.email;
      if (userEmail != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userEmail)
            .get();
        if (doc.exists) {
          setState(() {
            joinedMessEmail = doc.get('messName');
          });
        }
      }
    } catch (e) {
      print("Error loading user data: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF8B1A1A);
    const accentColor = Color(0xFFD4A843);
    const bgColor = Color(0xFFFFF8F0);

    if (isLoading) {
      return const Scaffold(
        backgroundColor: bgColor,
        body: Center(child: CircularProgressIndicator(color: primaryColor)),
      );
    }

    if (joinedMessEmail == null || joinedMessEmail!.isEmpty) {
      return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: primaryColor),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text("MESS MENU",
              style:
                  TextStyle(color: primaryColor, fontWeight: FontWeight.w900)),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.restaurant_rounded,
                  size: 80, color: Color(0xFFE8E0D5)),
              const SizedBox(height: 20),
              const Text(
                "No Mess Joined",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF333333)),
              ),
              const SizedBox(height: 10),
              const Text(
                "Join a mess to see their daily menu specials.",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("BROWSE MESSES",
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: primaryColor),
            onPressed: () => Navigator.pop(context),
          ),
          title: Column(
            children: [
              const Text(
                "TODAY'S MENU",
                style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    letterSpacing: 1.2),
              ),
              Text(
                joinedMessEmail!,
                style: const TextStyle(
                    color: accentColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: accentColor,
            indicatorWeight: 3,
            labelColor: primaryColor,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(
                fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 1),
            tabs: [
              Tab(text: "VEGETARIAN"),
              Tab(text: "NON-VEGETARIAN"),
            ],
          ),
        ),
        body: TabBarView(
          physics: const BouncingScrollPhysics(),
          children: [
            _buildMenuList('Veg', primaryColor, accentColor),
            _buildMenuList('Non-veg', Colors.redAccent, accentColor),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuList(String itemType, Color themeColor, Color accent) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('messOwner')
          .doc(joinedMessEmail)
          .collection('menu')
          .doc(itemType)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: Color(0xFF8B1A1A)));
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.no_meals_rounded,
                    size: 64, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                Text("No $itemType items available today",
                    style: const TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w600)),
              ],
            ),
          );
        }

        final data = snapshot.data!.data() as Map<String, dynamic>?;
        final List<dynamic> items = (data?['items'] as List<dynamic>?) ?? [];

        if (items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.restaurant_outlined,
                    size: 64, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                Text("Menu is empty for $itemType",
                    style: const TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w600)),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: themeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      "${index + 1}",
                      style: TextStyle(
                          color: themeColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 18),
                    ),
                  ),
                ),
                title: Text(
                  items[index].toString(),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF333333),
                  ),
                ),
                trailing: Icon(
                  itemType == 'Veg' ? Icons.circle : Icons.circle,
                  color: itemType == 'Veg' ? Colors.green : Colors.red,
                  size: 14,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
