// import 'package:flutter/material.dart';
//
// // Model class representing a member
// class Member {
//   final String name;
//   bool isPresent;
//
//   Member({required this.name, this.isPresent = false});
// }
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Attendance App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       // Use different routes for regular users and admins
//       initialRoute: '/',
//       routes: {
//         '/': (context) => AttendancePage(), // Regular user route
//         '/admin': (context) => AdminPage(), // Admin route
//       },
//     );
//   }
// }
//
// class AttendancePage extends StatefulWidget {
//   @override
//   _AttendancePageState createState() => _AttendancePageState();
// }
//
// class _AttendancePageState extends State<AttendancePage> {
//   // List of members (same as before)
//   List<Member> members = [
//     Member(name: 'John Doe'),
//     Member(name: 'Jane Smith'),
//     Member(name: 'Alice Johnson'),
//     // Add more members as needed
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Attendance'),
//       ),
//       body: ListView.builder(
//         itemCount: members.length,
//         itemBuilder: (context, index) {
//           return Card(
//             child: ListTile(
//               title: Text(members[index].name),
//               onTap: () {
//                 // Toggle attendance status
//                 setState(() {
//                   members[index].isPresent = !members[index].isPresent;
//                 });
//               },
//               tileColor: members[index].isPresent ? Colors.green : Colors.white,
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// class AdminPage extends StatefulWidget {
//   @override
//   _AdminPageState createState() => _AdminPageState();
// }
//
// class _AdminPageState extends State<AdminPage> {
//   // List of members (same as before)
//   List<Member> members = [
//     Member(name: 'John Doe'),
//     Member(name: 'Jane Smith'),
//     Member(name: 'Alice Johnson'),
//     // Add more members as needed
//   ];
//
//   DateTime selectedDate = DateTime.now(); // Initialize selected date with today's date
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Admin Dashboard'),
//       ),
//       body: Column(
//         children: [
//           ElevatedButton(
//             onPressed: () => _selectDate(context),
//             child: Text('Select Date'),
//           ),
//           Text(
//             'Selected Date: ${selectedDate.toString()}',
//             style: TextStyle(fontSize: 16),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: members.length,
//               itemBuilder: (context, index) {
//                 return Card(
//                   child: ListTile(
//                     title: Text(members[index].name),
//                     onTap: () {
//                       // Toggle attendance status
//                       setState(() {
//                         members[index].isPresent = !members[index].isPresent;
//                       });
//                     },
//                     tileColor: members[index].isPresent ? Colors.green : Colors.white,
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Add functionality to submit attendance
//           _submitAttendance();
//         },
//         child: Icon(Icons.check),
//       ),
//     );
//   }
//
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: DateTime(2015, 8),
//       lastDate: DateTime(2101),
//     );
//     if (pickedDate != null && pickedDate != selectedDate)
//       setState(() {
//         selectedDate = pickedDate;
//       });
//   }
//
//   void _submitAttendance() {
//     // Store attendance data locally
//     for (var member in members) {
//       // Add code to store attendance data with the selected date locally
//       print('${member.name}: ${member.isPresent ? 'Present' : 'Absent'} on $selectedDate');
//     }
//     // Optionally, you can also send this data to a server or perform other actions.
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'MemberListDescription.dart';
class UserRequest {
  final String userId;
  final String userName;
  // final String contactNumber;
  // final String requestTime;
  final String email;
  final int approved;

  UserRequest({
    required this.userId,
    required this.userName,
    // required this.contactNumber,
    // required this.requestTime,
    required this.email,
    required this.approved,
  });
}
class AdminAttendance extends StatefulWidget{
  @override
  State<AdminAttendance> createState() => _AdminAttendanceState();
}


class _AdminAttendanceState extends State<AdminAttendance> {
  DateTime selectedDate = DateTime.now();
  late List<UserRequest> userRequests = [];
  String date = "Select Date";
  late int approve;
  late String? ownerEmail;
  Set<int> selectedIndexes = {}; // Set to store selected indexes

  void initState() {
    super.initState();
    fetchUserRequests();
  }

  void fetchUserRequests() async {
    var firestore = FirebaseFirestore.instance;
    FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    ownerEmail = user?.email;

    var querySnapshot = await firestore
        .collection('mess')
        .doc(user!.email)
        .collection('requests')
        .where('approved', isEqualTo: 1)
        .get();
    setState(() {
      userRequests = querySnapshot.docs.map((doc) {
        return UserRequest(
          userId: doc.id,
          userName: doc['name'],
          email: doc['email'],
          approved: doc['approved'],
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Attendance"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.grey.shade300,
            height: 1.0,
          ),
        ),
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              width: 300,
              margin: EdgeInsets.only(top: 30),
              child: ElevatedButton(
                onPressed: () {
                  _selectDate(context);
                },
                child: Text(date),
                style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.resolveWith((states) => Colors.black),
                  foregroundColor:
                  MaterialStateProperty.resolveWith((states) => Colors.white),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20, bottom: 20),
            child: Text(
              "Member List",
              style: TextStyle(fontSize: 20),
            ),
          ),
          Expanded(
            child: userRequests.isNotEmpty
                ? ListView.builder(
              itemCount: userRequests.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      if (selectedIndexes.contains(index)) {
                        selectedIndexes.remove(index);
                      } else {
                        selectedIndexes.add(index);
                      }
                    });
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(
                        vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text(
                        '${index + 1})\t${userRequests[index].userName}',
                        style: TextStyle(
                            fontFamily: "MainFont", fontSize: 20),
                      ),
                      // Add color based on selection
                      tileColor: selectedIndexes.contains(index)
                          ? Colors.green.withOpacity(0.3)
                          : null,
                    ),
                  ),
                );
              },
            )
                : Center(child: CircularProgressIndicator()),
          ),
          Container(
            child: ElevatedButton(
              onPressed: () {
                if (selectedIndexes.isNotEmpty) {
                  // Show confirmation dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Submit Attendance"),
                        content: Text("Are you sure you want to submit the attendance?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close dialog
                            },
                            child: Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close dialog
                              submitAttendance(); // Submit attendance
                            },
                            child: Text("Submit"),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  Fluttertoast.showToast(msg: "Please select members");
                }
              },
              child: Text("Submit"),
              style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.resolveWith((states) => Colors.black),
                foregroundColor:
                MaterialStateProperty.resolveWith((states) => Colors.white),
              ),
            ),
          )
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
    );
    if (pickedDate != null && pickedDate != selectedDate)
      setState(() {
        selectedDate = pickedDate;
        date = selectedDate.day.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.year.toString();
      });
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
            .doc(date)
            .set({selectedEmail: 1}, SetOptions(merge: true));
      }
      Fluttertoast.showToast(msg: "Attendance submitted successfully");
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to submit attendance");
    }
  }
}
