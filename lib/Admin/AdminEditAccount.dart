import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/LoginScreen.dart';

class EditAccountScreen extends StatefulWidget {
  const EditAccountScreen({super.key});

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  final TextEditingController _nameController =
      TextEditingController(text: "Admin User");
  final TextEditingController _emailController =
      TextEditingController(text: "admin@welldine.com");

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Fluttertoast.showToast(
        msg: "Successfully Logged Out",
        backgroundColor: const Color(0xFF8B1A1A),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      print("Error for logout $e");
    }
  }

  void _showLogoutConfirmDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Confirm Logout',
            style: TextStyle(fontWeight: FontWeight.w900)),
        content: const Text(
            'Are you sure you want to sign out from the admin portal?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B1A1A),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Logout',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
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
          'PORTAL SETTINGS',
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
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // 1. Profile Header
            _buildProfileHeader(accentColor),
            const SizedBox(height: 40),

            // 2. Form Fields
            _buildInputField(
              label: "ADMINISTRATOR NAME",
              controller: _nameController,
              icon: Icons.person_outline_rounded,
              accent: accentColor,
            ),
            const SizedBox(height: 20),
            _buildInputField(
              label: "EMAIL ADDRESS",
              controller: _emailController,
              icon: Icons.email_outlined,
              accent: accentColor,
            ),
            const SizedBox(height: 20),
            _buildInputField(
              label: "CHANGE PASSWORD",
              isPassword: true,
              hint: "••••••••",
              icon: Icons.lock_outline_rounded,
              accent: accentColor,
            ),

            const SizedBox(height: 40),

            // 3. Save Button
            ElevatedButton(
              onPressed: () {
                Fluttertoast.showToast(msg: "Changes saved successfully!");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                shadowColor: primaryColor.withOpacity(0.4),
              ),
              child: const Text(
                "SAVE CHANGES",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1),
              ),
            ),

            const SizedBox(height: 30),

            // 4. Danger Zone / Logout
            _buildDangerZone(primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(Color accent) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: accent.withOpacity(0.3), width: 2),
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: accent.withOpacity(0.1),
                child: const Icon(Icons.admin_panel_settings_rounded,
                    size: 50, color: Color(0xFF8B1A1A)),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                  color: Color(0xFFD4A843), shape: BoxShape.circle),
              child: const Icon(Icons.camera_alt_rounded,
                  size: 16, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          "Admin Profile",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Color(0xFF333333)),
        ),
        Text(
          "Manage your administrative credentials",
          style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    TextEditingController? controller,
    required IconData icon,
    required Color accent,
    bool isPassword = false,
    String? hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: Colors.grey,
              letterSpacing: 1),
        ),
        const SizedBox(height: 10),
        Container(
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
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(icon, color: accent, size: 20),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDangerZone(Color primary) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          const Text(
            "Account Actions",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Colors.redAccent),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _showLogoutConfirmDialog,
            icon: const Icon(Icons.logout_rounded, size: 18),
            label: const Text("LOGOUT FROM PORTAL"),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.redAccent,
              side: const BorderSide(color: Colors.redAccent),
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}
