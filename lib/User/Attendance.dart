import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserAttendance extends StatefulWidget {
  const UserAttendance({super.key});

  @override
  State<UserAttendance> createState() => _UserAttendanceState();
}

class _UserAttendanceState extends State<UserAttendance> {
  late String? currentUserEmail;
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    currentUserEmail = user?.email;
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
          "ATTENDANCE LOG",
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) =>
                  setState(() => _searchText = value.toLowerCase()),
              decoration: InputDecoration(
                hintText: 'Search by date (DD-MM-YYYY)...',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                prefixIcon:
                    const Icon(Icons.search_rounded, color: accentColor),
                filled: true,
                fillColor: bgColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          Expanded(
            child: currentUserEmail == null
                ? const Center(child: Text("User not authenticated"))
                : StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(currentUserEmail)
                        .snapshots(),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                            child:
                                CircularProgressIndicator(color: primaryColor));
                      }
                      if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                        return const Center(child: Text("User data not found"));
                      }

                      final ownerEmail = userSnapshot.data!.get('messName');
                      if (ownerEmail == null || ownerEmail.toString().isEmpty) {
                        return _buildEmptyState("Not Joined Any Mess",
                            "Join a mess to track your attendance.");
                      }

                      return StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("messOwner")
                            .doc(ownerEmail)
                            .collection("attendance")
                            .snapshots(),
                        builder: (context, attendanceSnapshot) {
                          if (attendanceSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator(
                                    color: primaryColor));
                          }
                          if (!attendanceSnapshot.hasData ||
                              attendanceSnapshot.data!.docs.isEmpty) {
                            return _buildEmptyState("No History Yet",
                                "Your attendance history will appear here.");
                          }

                          var docs = attendanceSnapshot.data!.docs;
                          if (_searchText.isNotEmpty) {
                            docs = docs
                                .where((doc) => doc.id.contains(_searchText))
                                .toList();
                          }

                          // Sort by date (descending)
                          docs.sort((a, b) => _compareDates(b.id, a.id));

                          if (docs.isEmpty) {
                            return _buildEmptyState("No Results Found",
                                "Try a different search query.");
                          }

                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            physics: const BouncingScrollPhysics(),
                            itemCount: docs.length,
                            itemBuilder: (context, index) {
                              final date = docs[index].id;
                              final data =
                                  docs[index].data() as Map<String, dynamic>;
                              final isPresent =
                                  data.containsKey(currentUserEmail);

                              return _buildAttendanceCard(
                                  date, isPresent, primaryColor, accentColor);
                            },
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceCard(
      String date, bool isPresent, Color primary, Color accent) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: (isPresent ? Colors.green : Colors.red).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isPresent ? Icons.check_circle_rounded : Icons.cancel_rounded,
            color: isPresent ? Colors.green : Colors.red,
            size: 24,
          ),
        ),
        title: Text(
          date,
          style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: Color(0xFF333333)),
        ),
        subtitle: Text(
          isPresent ? "Marked as Present" : "Marked as Absent",
          style: TextStyle(
            color: isPresent ? Colors.green.shade700 : Colors.red.shade700,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing:
            Icon(Icons.chevron_right_rounded, color: Colors.grey.shade300),
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.calendar_today_rounded,
              size: 60, color: Color(0xFFE8E0D5)),
          const SizedBox(height: 20),
          Text(title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF333333))),
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  int _compareDates(String d1, String d2) {
    try {
      final p1 = d1.split('-').map(int.parse).toList();
      final p2 = d2.split('-').map(int.parse).toList();
      // YYYY-MM-DD comparison logic (reversed for DD-MM-YYYY)
      if (p1[2] != p2[2]) return p1[2].compareTo(p2[2]);
      if (p1[1] != p2[1]) return p1[1].compareTo(p2[1]);
      return p1[0].compareTo(p2[0]);
    } catch (e) {
      return d1.compareTo(d2);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
