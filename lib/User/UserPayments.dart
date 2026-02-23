import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class UserPayments extends StatefulWidget {
  const UserPayments({super.key});

  @override
  State<UserPayments> createState() => _UserPaymentsState();
}

class _UserPaymentsState extends State<UserPayments> {
  String? qrImageUrl, messEmail;
  final ImagePicker _imagePicker = ImagePicker();
  bool isUploading = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMessInfo();
  }

  Future<void> _loadMessInfo() async {
    try {
      final userEmail = FirebaseAuth.instance.currentUser?.email;
      if (userEmail != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userEmail)
            .get();
        if (userDoc.exists) {
          messEmail = userDoc.get('messName');
          if (messEmail != null && messEmail!.isNotEmpty) {
            final messDoc = await FirebaseFirestore.instance
                .collection('messOwner')
                .doc(messEmail)
                .get();
            if (messDoc.exists) {
              qrImageUrl = messDoc.get('image');
            }
          }
        }
      }
    } catch (e) {
      print("Error loading payment info: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _pickAndUploadReceipt() async {
    final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 70);
    if (image == null) return;

    setState(() => isUploading = true);
    try {
      final userEmail = FirebaseAuth.instance.currentUser?.email;
      if (userEmail == null || messEmail == null) return;

      final storageRef =
          FirebaseStorage.instance.ref().child('UserPayments/$userEmail.png');
      await storageRef.putFile(File(image.path));
      final downloadUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('messOwner')
          .doc(messEmail)
          .collection('payments')
          .doc(userEmail)
          .set({
        'receipt': downloadUrl,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'Pending',
      });

      Fluttertoast.showToast(
          msg: 'Receipt uploaded successfully!', backgroundColor: Colors.green);
    } catch (e) {
      print("Upload error: $e");
      Fluttertoast.showToast(
          msg: 'Upload failed. Please try again.', backgroundColor: Colors.red);
    } finally {
      setState(() => isUploading = false);
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
          "BILL PAYMENTS",
          style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
              fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // 1. Instructions Header
                  const Text(
                    "Pay Your Mess Bill",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF333333)),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Scan the QR code below to make a payment and upload your receipt for verification.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 32),

                  // 2. QR Code Display
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: accentColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "MESS PAYMENT QR",
                            style: TextStyle(
                                color: accentColor,
                                fontWeight: FontWeight.w900,
                                fontSize: 10,
                                letterSpacing: 1),
                          ),
                        ),
                        const SizedBox(height: 24),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: qrImageUrl != null
                              ? Image.network(
                                  qrImageUrl!,
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(
                                      Icons.error_outline,
                                      size: 100,
                                      color: Colors.grey),
                                )
                              : Image.asset('assets/imageUpload.jpg',
                                  width: 200, height: 200, fit: BoxFit.cover),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Securely powered by UPI",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 48),

                  // 3. Upload Action
                  const Text(
                    "Already Paid?",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF333333)),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: isUploading ? null : _pickAndUploadReceipt,
                    icon: isUploading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.cloud_upload_outlined),
                    label: Text(isUploading
                        ? "UPLOADING..."
                        : "UPLOAD PAYMENT RECEIPT"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                      shadowColor: primaryColor.withOpacity(0.4),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 4. Verification Note
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.info_outline_rounded,
                          size: 16, color: Colors.grey.shade400),
                      const SizedBox(width: 8),
                      Text(
                        "Payments are usually verified within 24 hours.",
                        style: TextStyle(
                            color: Colors.grey.shade500, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
