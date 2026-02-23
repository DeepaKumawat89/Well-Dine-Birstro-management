import 'package:flutter/material.dart';

class MemberListDescription extends StatefulWidget {
  final String name, phoneNumber, email, time;
  final String? ownerEmail;

  const MemberListDescription({
    super.key,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.time,
    required this.ownerEmail,
  });

  @override
  _MemberListDescriptionState createState() => _MemberListDescriptionState();
}

class _MemberListDescriptionState extends State<MemberListDescription> {
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
          'MEMBER PROFILE',
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
            // 1. Profile Badge
            _buildProfileBadge(accentColor),
            const SizedBox(height: 30),

            // 2. Member Info Card
            _buildMemberInfoCard(accentColor),
            const SizedBox(height: 40),

            // 3. Status Badge (Static for now since they are already members)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D5B).withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
                border:
                    Border.all(color: const Color(0xFF2E7D5B).withOpacity(0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.verified_user_rounded,
                      color: Color(0xFF2E7D5B), size: 20),
                  SizedBox(width: 8),
                  Text(
                    "ACTIVE MEMBER",
                    style: TextStyle(
                      color: Color(0xFF2E7D5B),
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
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

  Widget _buildProfileBadge(Color accent) {
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
        const SizedBox(height: 4),
        const Text(
          "Registered Member",
          style: TextStyle(
              fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildMemberInfoCard(Color accent) {
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
          _buildInfoTile(
              Icons.access_time_rounded, "Member Since", widget.time, accent),
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
                        fontSize: 11,
                        color: Colors.grey,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5)),
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
}
