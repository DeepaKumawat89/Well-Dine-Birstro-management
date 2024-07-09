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
  @override
  _AdminApprovalScreenState createState() => _AdminApprovalScreenState();
}

class _AdminApprovalScreenState extends State<AdminApprovalScreen> {
  late List<UserRequest> userRequests = [];
  late int approve;
  late String? ownerEmail;
  @override
  void initState() {
    super.initState();
    fetchUserRequests();
  }

  void fetchUserRequests() async {
    var firestore = FirebaseFirestore.instance;
    FirebaseAuth _auth=FirebaseAuth.instance;
    User? user=_auth.currentUser;
    ownerEmail=user?.email;

    var querySnapshot = await firestore.collection('mess').doc(user!.email).collection('requests').get();
    setState(() {
      userRequests = querySnapshot.docs.map((doc) {
        return UserRequest(
          userId: doc.id,
          userName: doc['name'],
          contactNumber: doc['contactNumber'],
          requestTime: doc['date'],
          time: doc['time'],
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
        title: Text('User Requests'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.grey.shade300,
            height: 1.0,
          ),
        ),
      ),
      body: userRequests.isNotEmpty
          ? ListView.builder(
        itemCount: userRequests.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullDescriptionOfRequest(
                    name: userRequests[index].userName,
                    phoneNumber: userRequests[index].contactNumber,
                    email: userRequests[index].email,
                    date: userRequests[index].requestTime,
                    time: userRequests[index].time,
                    ownerEmail: ownerEmail,
                  ),
                ),
              );
            },
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title:
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //     Text(userRequests[index].userName),
                //     // SizedBox(width: 100,),
                //     Container(
                //         alignment: Alignment.bottomRight,
                //         child: Icon(Icons.access_time))
                //   ],
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      userRequests[index].userName,
                      style: TextStyle(fontFamily: "MainFont"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right:5,top: 5),
                      child: Icon(
                        userRequests[index].approved==1
                            ? Icons.check_circle
                            : Icons.timer,
                        color: userRequests[index].approved==1
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contact Number: ${userRequests[index].contactNumber}',
                    ),
                    Text(
                      'Requested at: ${userRequests[index].requestTime}',
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      )
          : Center(child: CircularProgressIndicator()),
    );
  }

  void approveUserRequest(UserRequest request) {
    setState(() {
      userRequests.remove(request);
    });
  }

  void rejectUserRequest(UserRequest request) {
    setState(() {
      userRequests.remove(request);
    });
  }
}
