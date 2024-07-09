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
  @override
  _AdminMemberListState createState() => _AdminMemberListState();
}

class _AdminMemberListState extends State<AdminMemberList> {
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

    var querySnapshot = await firestore.collection('mess').doc(user!.email).collection('requests').where('approved',isEqualTo: 1).get();
    setState(() {
      userRequests = querySnapshot.docs.map((doc) {
        return UserRequest(
          userId: doc.id,
          userName: doc['name'],
          contactNumber: doc['contactNumber'],
          requestTime: doc['time'],
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
        title: Text('Member List'),
      ),
      body:
      userRequests.isNotEmpty
          ? ListView.builder(
        itemCount: userRequests.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MemberListDescription(
                    name: userRequests[index].userName,
                    phoneNumber: userRequests[index].contactNumber,
                    email: userRequests[index].email,
                    time: userRequests[index].requestTime,
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
                Text(
                  userRequests[index].userName,
                  style: TextStyle(fontFamily: "MainFont"),
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
