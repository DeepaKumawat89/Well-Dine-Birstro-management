import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChangeMenuScreen extends StatefulWidget {
  @override
  State<ChangeMenuScreen> createState() => _ChangeMenuScreenState();
}

class _ChangeMenuScreenState extends State<ChangeMenuScreen> {
  late String? ownerEmail;

  @override
  void initState() {
    super.initState();
    FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    ownerEmail = user?.email;
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF8B1A1A);
    const accentColor = Color(0xFFD4A843);
    const bgColor = Color(0xFFFFF8F0);

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
          title: const Text(
            "MANAGEMENT MENU",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: primaryColor,
              fontSize: 18,
              letterSpacing: 1.2,
            ),
          ),
          bottom: TabBar(
            indicatorColor: accentColor,
            indicatorWeight: 3,
            labelColor: primaryColor,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(
                fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 1),
            tabs: const [
              Tab(text: "VEGETARIAN"),
              Tab(text: "NON-VEG"),
            ],
          ),
        ),
        body: TabBarView(
          physics: const BouncingScrollPhysics(),
          children: [
            _buildMenuList('Veg'),
            _buildMenuList('Non-veg'),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: const Text(
            "ADD NEW ITEM",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          icon: const Icon(Icons.add_circle_outline, color: Colors.white),
          backgroundColor: primaryColor,
          elevation: 4,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AdminChangeMenuScreen()));
          },
        ),
      ),
    );
  }

  Widget _buildMenuList(String itemType) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('messOwner')
          .doc(ownerEmail)
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
                Icon(Icons.restaurant_outlined,
                    size: 64, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                const Text("No items found in this category",
                    style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        var items = (snapshot.data!.get('items') as List<dynamic>?) ?? [];

        if (items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.restaurant_outlined,
                    size: 64, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                const Text("Menu is empty",
                    style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
          physics: const BouncingScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFF8B1A1A).withOpacity(0.1),
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                        color: Color(0xFF8B1A1A), fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(
                  items[index].toString(),
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333)),
                ),
                trailing: IconButton(
                  onPressed: () => _showDeleteConfirm(itemType, index),
                  icon: const Icon(Icons.delete_outline_rounded,
                      color: Colors.redAccent),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirm(String itemType, int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Item',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to remove this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _deleteItem(itemType, index);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteItem(String itemType, int index) async {
    try {
      DocumentReference menuRef = FirebaseFirestore.instance
          .collection('messOwner')
          .doc(ownerEmail)
          .collection('menu')
          .doc(itemType);

      DocumentSnapshot snapshot = await menuRef.get();
      List<dynamic> items = List.from(snapshot.get('items'));

      items.removeAt(index);

      await menuRef.update({'items': items});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Item deleted successfully"),
            backgroundColor: Colors.black87),
      );
    } catch (error) {
      print("Failed to delete item: $error");
    }
  }
}

class AdminChangeMenuScreen extends StatefulWidget {
  const AdminChangeMenuScreen({super.key});

  @override
  _AdminChangeMenuScreenState createState() => _AdminChangeMenuScreenState();
}

class _AdminChangeMenuScreenState extends State<AdminChangeMenuScreen> {
  TextEditingController newItemController = TextEditingController();
  int? _selectedValue = 0;
  late String? ownerEmail;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    ownerEmail = user?.email;
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF8B1A1A);
    const accentColor = Color(0xFFD4A843);
    const bgColor = Color(0xFFFFF8F0);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'ADD MENU ITEM',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w900,
            fontSize: 18,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Category Selection",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF555555)),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildCategoryOption(0, "Vegetarian",
                        Icons.fiber_manual_record, Colors.green),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildCategoryOption(
                        1, "Non-Veg", Icons.fiber_manual_record, Colors.red),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Text(
                "Dish Name",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF555555)),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: newItemController,
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter dish name" : null,
                style: const TextStyle(fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  hintText: "e.g. Special Paneer Masala",
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon:
                      const Icon(Icons.restaurant_rounded, color: accentColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: accentColor, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: saveMenuChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  shadowColor: primaryColor.withOpacity(0.4),
                ),
                child: const Text(
                  "SAVE TO MENU",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryOption(
      int value, String label, IconData icon, Color color) {
    bool isSelected = _selectedValue == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedValue = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade200,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? color : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void saveMenuChanges() {
    if (!_formKey.currentState!.validate()) return;

    String itemType = _selectedValue == 0 ? 'Veg' : 'Non-veg';
    String newItem = newItemController.text;

    FirebaseFirestore.instance
        .collection('messOwner')
        .doc(ownerEmail)
        .collection('menu')
        .doc(itemType)
        .update({
      'items': FieldValue.arrayUnion([newItem]),
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Menu updated!"), backgroundColor: Color(0xFF2E7D5B)),
      );
      Navigator.pop(context);
    }).catchError((error) {
      print("Failed to add item: $error");
    });
  }
}
