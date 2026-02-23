import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/Admin/FullDescriptionOfRequest.dart';

class UserRequest {
  final String userId;
  final String userName;
  final String contactNumber;
  final String requestTime;
  final String time;
  final String email;
  final int approved;

  UserRequest({
    required this.userId,
    required this.userName,
    required this.contactNumber,
    required this.requestTime,
    required this.time,
    required this.email,
    required this.approved,
  });
}

class AdminApprovalScreen extends StatefulWidget {
  const AdminApprovalScreen({super.key});

  @override
  _AdminApprovalScreenState createState() => _AdminApprovalScreenState();
}

class _AdminApprovalScreenState extends State<AdminApprovalScreen> {
  late List<UserRequest> userRequests = [];
  String? ownerEmail;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserRequests();
  }

  void fetchUserRequests() async {
    var firestore = FirebaseFirestore.instance;
    FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    ownerEmail = user?.email;

    if (user != null) {
      try {
        var querySnapshot = await firestore
            .collection('mess')
            .doc(user.email)
            .collection('requests')
            .get();
        setState(() {
          userRequests = querySnapshot.docs.map((doc) {
            return UserRequest(
              userId: doc.id,
              userName: doc['name'] ?? 'Unknown',
              contactNumber: doc['contactNumber'] ?? 'No contact',
              requestTime: doc['date'] ?? 'No date',
              time: doc['time'] ?? 'No time',
              email: doc['email'] ?? 'No email',
              approved: doc['approved'] ?? 0,
            );
          }).toList();
          _isLoading = false;
        });
      } catch (e) {
        print("Error fetching requests: $e");
        setState(() => _isLoading = false);
      }
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
          'JOIN REQUESTS',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : userRequests.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  physics: const BouncingScrollPhysics(),
                  itemCount: userRequests.length,
                  itemBuilder: (context, index) {
                    final request = userRequests[index];
                    return _buildRequestCard(
                        request, context, primaryColor, accentColor);
                  },
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.mark_email_read_outlined,
              size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            "No pending requests",
            style: TextStyle(
                color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard(UserRequest request, BuildContext context,
      Color primaryColor, Color accentColor) {
    bool isApproved = request.approved == 1;

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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FullDescriptionOfRequest(
                  name: request.userName,
                  phoneNumber: request.contactNumber,
                  email: request.email,
                  date: request.requestTime,
                  time: request.time,
                  ownerEmail: ownerEmail,
                ),
              ),
            ).then((_) => fetchUserRequests());
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // 1. Initial Circle
                CircleAvatar(
                  radius: 28,
                  backgroundColor: (isApproved ? Colors.green : accentColor)
                      .withOpacity(0.1),
                  child: Text(
                    request.userName[0].toUpperCase(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isApproved ? Colors.green : accentColor,
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // 2. Info Detail
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.userName,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        request.email,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.calendar_today_rounded,
                              size: 12, color: primaryColor.withOpacity(0.5)),
                          const SizedBox(width: 4),
                          Text(
                            request.requestTime,
                            style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // 3. Status Badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isApproved
                        ? Colors.green.withOpacity(0.1)
                        : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isApproved
                            ? Icons.verified_rounded
                            : Icons.pending_rounded,
                        size: 14,
                        color: isApproved ? Colors.green : Colors.orange,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isApproved ? "Approved" : "Pending",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: isApproved ? Colors.green : Colors.orange,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
