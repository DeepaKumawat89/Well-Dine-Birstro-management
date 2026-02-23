import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FullDescriptionOfRequest extends StatefulWidget {
  final String name, phoneNumber, email, time, date;
  final String? ownerEmail;

  const FullDescriptionOfRequest({
    super.key,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.date,
    required this.time,
    required this.ownerEmail,
  });

  @override
  _FullDescriptionOfRequestState createState() =>
      _FullDescriptionOfRequestState();
}

class _FullDescriptionOfRequestState extends State<FullDescriptionOfRequest> {
  bool _isProcessing = false;

  Future<void> _handleAction(int status) async {
    setState(() => _isProcessing = true);
    try {
      DocumentReference requestRef = FirebaseFirestore.instance
          .collection('mess')
          .doc(widget.ownerEmail)
          .collection('requests')
          .doc(widget.email);

      await requestRef.update({'approved': status});

      if (status == 1) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.email)
            .update({'messName': widget.ownerEmail});
      }

      Fluttertoast.showToast(
        msg: status == 1
            ? 'Request approved successfully!'
            : 'Request rejected.',
        backgroundColor: status == 1 ? Colors.green : Colors.redAccent,
      );
      Navigator.pop(context);
    } catch (error) {
      Fluttertoast.showToast(msg: 'Action failed. Please try again.');
      print('Error: $error');
    } finally {
      setState(() => _isProcessing = false);
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
          'REQUEST DETAIL',
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            // 1. Profile Header Accessory
            _buildProfileHeader(accentColor),
            const SizedBox(height: 30),

            // 2. Information Card
            _buildInfoContainer(primaryColor, accentColor),
            const SizedBox(height: 50),

            // 3. Action Buttons
            if (_isProcessing)
              const CircularProgressIndicator(color: primaryColor)
            else
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      label: "REJECT",
                      icon: Icons.close_rounded,
                      color: Colors.redAccent,
                      onTap: () => _handleAction(2),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildActionButton(
                      label: "APPROVE",
                      icon: Icons.check_circle_outline_rounded,
                      color: const Color(0xFF2E7D5B),
                      onTap: () => _handleAction(1),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(Color accent) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: accent.withOpacity(0.5), width: 2),
          ),
          child: CircleAvatar(
            radius: 50,
            backgroundColor: accent.withOpacity(0.1),
            child: Text(
              widget.name[0].toUpperCase(),
              style: TextStyle(
                  fontSize: 40, fontWeight: FontWeight.w900, color: accent),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          widget.name,
          style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Color(0xFF333333)),
        ),
        Text(
          "Membership Inquiry",
          style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildInfoContainer(Color primary, Color accent) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
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
          _buildInfoTile(
              Icons.email_outlined, "Email Address", widget.email, accent),
          _buildDivider(),
          _buildInfoTile(Icons.phone_outlined, "Contact Number",
              widget.phoneNumber, accent),
          _buildDivider(),
          _buildInfoTile(Icons.calendar_today_outlined, "Request Date",
              widget.date, accent),
          _buildDivider(),
          _buildInfoTile(
              Icons.access_time_rounded, "Request Time", widget.time, accent),
        ],
      ),
    );
  }

  Widget _buildInfoTile(
      IconData icon, String label, String value, Color accent) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: accent, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF444444))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
        height: 1, indent: 70, endIndent: 20, color: Colors.grey.shade100);
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1),
            ),
          ],
        ),
      ),
    );
  }
}
