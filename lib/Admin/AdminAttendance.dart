import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserRequest {
  final String userId;
  final String userName;
  final String email;
  final int approved;

  UserRequest({
    required this.userId,
    required this.userName,
    required this.email,
    required this.approved,
  });
}

class AdminAttendance extends StatefulWidget {
  const AdminAttendance({super.key});

  @override
  State<AdminAttendance> createState() => _AdminAttendanceState();
}

class _AdminAttendanceState extends State<AdminAttendance> {
  DateTime selectedDate = DateTime.now();
  late List<UserRequest> userRequests = [];
  String dateDisplay = "Select Date";
  String? ownerEmail;
  Set<int> selectedIndexes = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    dateDisplay =
        "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";
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
          "DAILY ATTENDANCE",
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. Date Selector Area
          _buildDateSelector(primaryColor, accentColor),

          // 2. Member List Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Member List",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF333333)),
                ),
                Text(
                  "${selectedIndexes.length} Selected",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: accentColor),
                ),
              ],
            ),
          ),

          // 3. The List
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: primaryColor))
                : userRequests.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        physics: const BouncingScrollPhysics(),
                        itemCount: userRequests.length,
                        itemBuilder: (context, index) {
                          return _buildAttendanceCard(index, accentColor);
                        },
                      ),
          ),

          // 4. Submit Button
          _buildSubmitSection(primaryColor),
        ],
      ),
    );
  }

  Widget _buildDateSelector(Color primary, Color accent) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "Tracking Date",
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                letterSpacing: 1),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () => _selectDate(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: accent.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.calendar_month_rounded, color: accent, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    dateDisplay,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: primary),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.arrow_drop_down_circle_outlined,
                      color: primary, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_off_rounded, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text("No active members to track",
              style:
                  TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildAttendanceCard(int index, Color accent) {
    final isSelected = selectedIndexes.contains(index);
    final user = userRequests[index];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected ? Colors.green.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color:
              isSelected ? Colors.green.withOpacity(0.3) : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isSelected ? 0.02 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        onTap: () {
          setState(() {
            if (selectedIndexes.contains(index)) {
              selectedIndexes.remove(index);
            } else {
              selectedIndexes.add(index);
            }
          });
        },
        leading: CircleAvatar(
          backgroundColor:
              (isSelected ? Colors.green : accent).withOpacity(0.1),
          child: Text(
            user.userName[0].toUpperCase(),
            style: TextStyle(
              color: isSelected ? Colors.green : accent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          user.userName,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF333333)),
        ),
        subtitle: Text(
          user.email,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? Colors.green : Colors.grey.shade100,
          ),
          child: Icon(
            isSelected ? Icons.check : Icons.add,
            size: 16,
            color: isSelected ? Colors.white : Colors.grey.shade400,
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitSection(Color primary) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _showSubmitDialog,
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
        ),
        child: const Text(
          "SUBMIT ATTENDANCE",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1),
        ),
      ),
    );
  }

  void _showSubmitDialog() {
    if (selectedIndexes.isEmpty) {
      Fluttertoast.showToast(msg: "Please select present members");
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text("Confirm Attendance",
            style: TextStyle(fontWeight: FontWeight.w900)),
        content: Text(
            "Submit attendance for ${selectedIndexes.length} members on $dateDisplay?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel",
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              submitAttendance();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B1A1A),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Confirm",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF8B1A1A),
              onPrimary: Colors.white,
              onSurface: Color(0xFF333333),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        dateDisplay =
            "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";
      });
    }
  }

  void submitAttendance() async {
    var firestore = FirebaseFirestore.instance;
    try {
      for (int index in selectedIndexes) {
        String selectedEmail = userRequests[index].email;
        await firestore
            .collection('messOwner')
            .doc(ownerEmail)
            .collection('attendance')
            .doc(dateDisplay)
            .set({selectedEmail: 1}, SetOptions(merge: true));
      }
      Fluttertoast.showToast(msg: "Attendance submitted successfully!");
      setState(() => selectedIndexes.clear());
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to submit attendance");
    }
  }
}
