import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/Admin/AdminApprovalScreen.dart';
import 'package:project/Admin/AdminAttendance.dart';
import 'package:project/Admin/AdminChangeMenu.dart';
import 'package:project/Admin/AdminContactDetails.dart';
import 'package:project/Admin/AdminEditAccount.dart';
import 'package:project/Admin/AdminFeedback.dart';
import 'package:project/Admin/AdminMemberlist.dart';
import 'package:project/Admin/AdminPayment.dart';
import 'package:project/LoginScreen.dart';

class AdminDashboard extends StatefulWidget {
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  late String? ownerEmail;

  @override
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Fluttertoast.showToast(msg: "Successfully Logout");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ));
    } catch (e) {
      print("Error for logout $e");
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications), // Notification icon
            onPressed: () {
              // Navigate to the NotificationPage when the icon is clicked
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminDashboard()),
              );
            },
          ),
          Container(
            // margin: EdgeInsets.only(top: 30,left: 280),
            child: IconButton(
              icon: Icon(
                Icons.logout_outlined,
                size: 30,
              ),
              onPressed: () {
                logout();
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, Admin!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              // Option 1: Change Menu
              AdminOptionCard(
                title: 'Change Menu',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangeMenuScreen(),
                      ));
                  // Add logic for handling 'Change Menu'
                  print('Change Menu button clicked');
                },
              ),
              // Option 2: Requests
              AdminOptionCard(
                title: 'Requests',
                onPressed: () {
                  // Navigate to the Requests page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AdminApprovalScreen()),
                  );
                },
              ),
              // Option 3: Member List & Details
              AdminOptionCard(
                title: 'Member List & Details',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminMemberList(),
                      ));
                  print('Member List & Details button clicked');
                },
              ),
              // Option 4: Attendance Calendar
              AdminOptionCard(
                title: 'Attendance Calendar',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminAttendance()),
                  );
                  // Add logic for handling 'Attendance Calendar'
                  print('Attendance Calendar button clicked');
                },
              ),
              // Option 5: Edit Account
              AdminOptionCard(
                title: 'Edit Account',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditAccountScreen()),
                  );
                  // Add logic for handling 'Edit Account'
                  print('Edit Account button clicked');
                },
              ),
              // Option 6: Payment
              AdminOptionCard(
                title: 'Payments',
                onPressed: () {
                  // Navigate to the Requests page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PaymentScreen()),
                  );
                },
              ),
              // Option 7: Feedback
              AdminOptionCard(
                title: 'Feedback',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AdminFeedbackScreen()),
                  );
                  // Add logic for handling 'Feedback'
                  print('Feedback button clicked');
                },
              ),
              // Option 8: Contact Details
              AdminOptionCard(
                title: 'Contact Details',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AdminContactDetailsScreen()),
                  );
                  // Add logic for handling 'Contact Details'
                  print('Contact Details button clicked');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AdminOptionCard extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const AdminOptionCard({
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontSize: 18),
        ),
        onTap: onPressed,
      ),
    );
  }
}
