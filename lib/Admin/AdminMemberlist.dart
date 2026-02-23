import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/Admin/FullDescriptionOfRequest.dart';
import 'package:project/Admin/MemberListDescription.dart';

class UserRequest {
  final String userId;
  final String userName;
  final String contactNumber;
  final String requestTime;
  final String email;
  final int approved;

  UserRequest({
    required this.userId,
    required this.userName,
    required this.contactNumber,
    required this.requestTime,
    required this.email,
    required this.approved,
  });
}

class AdminMemberList extends StatefulWidget {
  const AdminMemberList({super.key});

  @override
  _AdminMemberListState createState() => _AdminMemberListState();
}

class _AdminMemberListState extends State<AdminMemberList> {
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
            .where('approved', isEqualTo: 1)
            .get();
        setState(() {
          userRequests = querySnapshot.docs.map((doc) {
            return UserRequest(
              userId: doc.id,
              userName: doc['name'] ?? 'Unknown',
              contactNumber: doc['contactNumber'] ?? 'No contact',
              requestTime: doc['time'] ?? 'No time',
              email: doc['email'] ?? 'No email',
              approved: doc['approved'] ?? 1,
            );
          }).toList();
          _isLoading = false;
        });
      } catch (e) {
        print("Error fetching members: $e");
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF8B1A1A);
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
          'MEMBER DIRECTORY',
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
                    return _buildMemberCard(request, context, primaryColor);
                  },
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline_rounded,
              size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            "No members found",
            style: TextStyle(
                color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberCard(
      UserRequest request, BuildContext context, Color primaryColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                builder: (context) => MemberListDescription(
                  name: request.userName,
                  phoneNumber: request.contactNumber,
                  email: request.email,
                  time: request.requestTime,
                  ownerEmail: ownerEmail,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: const Color(0xFFD4A843).withOpacity(0.1),
                  child: Text(
                    request.userName[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD4A843),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.userName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.phone_iphone_rounded,
                              size: 12, color: Colors.grey.shade400),
                          const SizedBox(width: 4),
                          Text(
                            request.contactNumber,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded,
                    color: Color(0xFFEEEEEE), size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
