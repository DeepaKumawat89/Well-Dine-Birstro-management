import 'package:flutter/material.dart';

class PaymentDescription extends StatefulWidget {
  final String imageURL, name, email;

  const PaymentDescription({
    super.key,
    required this.imageURL,
    required this.name,
    required this.email,
  });

  @override
  State<PaymentDescription> createState() => _PaymentDescriptionState();
}

class _PaymentDescriptionState extends State<PaymentDescription> {
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
          'RECEIPT DETAIL',
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
            // 1. User Info Header
            _buildUserHeader(accentColor),
            const SizedBox(height: 30),

            // 2. Receipt Image Container
            _buildReceiptContainer(primaryColor, accentColor),
            const SizedBox(height: 40),

            // 3. Status Badge
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
                  Icon(Icons.check_circle_rounded,
                      color: Color(0xFF2E7D5B), size: 20),
                  SizedBox(width: 8),
                  Text(
                    "PAYMENT RECEIVED",
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

  Widget _buildUserHeader(Color accent) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: accent.withOpacity(0.1),
          child: Text(
            widget.name[0].toUpperCase(),
            style: TextStyle(
                fontSize: 32, fontWeight: FontWeight.bold, color: accent),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          widget.name,
          style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF333333)),
        ),
        Text(
          widget.email,
          style: const TextStyle(
              fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildReceiptContainer(Color primary, Color accent) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Image.network(
              widget.imageURL,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error_outline, size: 50, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Transaction Receipt Proof",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
