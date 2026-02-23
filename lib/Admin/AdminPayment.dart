import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/Admin/AdminPaymentHistoryScreen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final String? email = FirebaseAuth.instance.currentUser?.email;
  String? imageUrl;
  final ImagePicker _imagePicker = ImagePicker();
  bool isloading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentQR();
  }

  Future<void> _loadCurrentQR() async {
    if (email == null) return;
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('messOwner')
          .doc(email)
          .get();
      if (doc.exists && doc.data() != null) {
        setState(() {
          imageUrl = doc.get('image');
        });
      }
    } catch (e) {
      print("Error loading QR: $e");
    }
  }

  pickImage() async {
    XFile? res = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (res != null) {
      uploadtoFirebase(File(res.path));
    }
  }

  uploadtoFirebase(File image) async {
    setState(() {
      isloading = true;
    });
    try {
      Reference sr =
          FirebaseStorage.instance.ref().child('Payments/$email.png');
      await sr.putFile(image);
      String newUrl = await sr.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('messOwner')
          .doc(email)
          .update({
        'image': newUrl,
      });

      setState(() {
        imageUrl = newUrl;
        isloading = false;
      });
      Fluttertoast.showToast(
        msg: 'QR Code updated successfully!',
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (e) {
      print('Error occurred $e');
      setState(() {
        isloading = false;
      });
      Fluttertoast.showToast(msg: 'Failed to upload QR Code');
    }
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
          'PAYMENT SETTINGS',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. QR Code Display Card
              _buildQRCard(primaryColor, accentColor),

              const SizedBox(height: 40),

              // 2. Action Buttons
              _buildActionButton(
                icon: Icons.qr_code_scanner_rounded,
                title: "Update QR Code",
                subtitle: "Upload your mess payment QR",
                color: primaryColor,
                onTap: pickImage,
              ),

              const SizedBox(height: 16),

              _buildActionButton(
                icon: Icons.history_rounded,
                title: "Payment History",
                subtitle: "View all member transactions",
                color: accentColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentHistoryScreen(email: email),
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),

              const Center(
                child: Text(
                  "Ensure your QR code is clear and valid for\nusers to make seamless payments.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQRCard(Color primary, Color accent) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified_rounded, color: primary, size: 16),
                const SizedBox(width: 8),
                Text(
                  "ACTIVE PAYMENT QR",
                  style: TextStyle(
                    color: primary,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: accent.withOpacity(0.3), width: 2),
                ),
                padding: const EdgeInsets.all(12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: isloading
                      ? const Center(
                          child: CircularProgressIndicator(
                              color: Color(0xFF8B1A1A)))
                      : imageUrl == null
                          ? Image.asset('assets/imageUpload.jpg',
                              fit: BoxFit.cover)
                          : Image.network(
                              imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.error_outline,
                                      size: 50, color: Colors.grey),
                            ),
                ),
              ),
              if (imageUrl == null && !isloading)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.add_photo_alternate_outlined,
                      color: primary, size: 40),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            "Scan this QR to pay mess bills",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: color.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF333333),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                color: color.withOpacity(0.3), size: 16),
          ],
        ),
      ),
    );
  }
}
