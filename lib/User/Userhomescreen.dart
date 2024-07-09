
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Attendance.dart';
import 'ChangeManu.dart';
import 'UserFeedback.dart';

class OptionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  OptionCard({
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        elevation: 4, // Elevation applied
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Shape applied
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              leading: Icon(icon),
              title: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserHomeScreen extends StatefulWidget {
  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  String name='',email='',ownerEmail='';

  void initState(){
    super.initState();
    getDetails();

  }
  Future<void> getDetails()async{
    try{

      String? email1=await FirebaseAuth.instance.currentUser?.email;
      DocumentSnapshot documentSnapshot=await FirebaseFirestore.instance.collection('users').doc(email1).get();
      name=documentSnapshot.get('name');
      email=documentSnapshot.get('email');
      ownerEmail=documentSnapshot.get('messName');
      setState(() {
      });
    }
    catch(e){
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // User avatar at the top center
            Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(top: 20, bottom: 16),
              child: CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage(
                    'https://example.com/avatar.jpg'), // Replace with actual avatar URL
              ),
            ),

            // User name below the avatar
            Text(
              name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6), // Adding space between name and email
            Text(
              email, // Replace with actual email ID
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8), // Adding space between name and email
            Text(
              ownerEmail==''?'':ownerEmail, // Replace with actual email ID
              style: TextStyle(fontSize: 16),
            ),

            // Card Grid View
            GridView.count(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              children: [
                // OptionCard(
                //   title: 'Meal Book',
                //   icon: Icons.book,
                //   onPressed: () {
                //     // Handle meal book option
                //   },
                // ),
                OptionCard(
                  title: 'Edit Account',
                  icon: Icons.edit,
                  onPressed: () {
                    // Handle edit account option
                  },
                ),
                OptionCard(
                  title: 'View Menu',
                  icon: Icons.restaurant_menu,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => UserChangeMenu(),));
                  },
                ),
                OptionCard(
                  title: 'Attendance',
                  icon: Icons.access_time,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserAttendance(),
                        ));
                  },
                ),
                OptionCard(
                  title: 'Payments',
                  icon: Icons.payment,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => UserPayments()));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
