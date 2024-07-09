import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MemberListDescription extends StatefulWidget {
  late String name,phoneNumber,email,time;
  late String? ownerEmail;
  MemberListDescription({
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.time,
    required this.ownerEmail,
  });
  @override
  _MemberListDescriptionState createState() =>
      _MemberListDescriptionState();
}

class _MemberListDescriptionState extends State<MemberListDescription> {

  Future<void> approved() async {
    try {
      // Reference to the Firestore document
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('mess')
          .doc(widget.ownerEmail) // Provide your document ID here
          .collection('requests')
          .doc(widget.email); // Provide your request document ID here

      // Update the 'approved' field to 1
      await documentReference.update({'approved': 1});

      // Show toast message indicating success
      Fluttertoast.showToast(
        msg: 'Request approved successfully!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } catch (error) {
      // Show toast message indicating error
      Fluttertoast.showToast(
        msg: 'Failed to approve request. Please try again later.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      print('Error updating document: $error');
    }
  }  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Member'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 20),
                child: Text(
                  "Name : ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),Container(
                margin: EdgeInsets.only(left: 20),
                child: Text(
                  widget.name,
                  style: TextStyle( fontSize: 20),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 20),
                child: Text(
                  "Email : ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),Container(
                margin: EdgeInsets.only(left: 20),
                child: Text(
                  widget.email,
                  style: TextStyle( fontSize: 20),
                ),
              ),
            ],
          ),Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 20,),
                child: Text(
                  "Phone No : ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),Container(
                margin: EdgeInsets.only(left: 20),
                child: Text(
                  widget.phoneNumber,
                  style: TextStyle( fontSize: 20),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 20),
                child: Text(
                  "Requested Time : ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),Container(
                margin: EdgeInsets.only(left: 20),
                child: Text(
                  widget.time,
                  style: TextStyle( fontSize: 20),
                ),
              ),
            ],
          ),

          // Center(
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Container(
          //         margin: EdgeInsets.only(top: 400),
          //         child: ElevatedButton(
          //           onPressed: () {
          //             approved();
          //           },
          //           style: ButtonStyle(
          //             backgroundColor: MaterialStateColor.resolveWith((states) => Colors.black),
          //             foregroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
          //             elevation: MaterialStateProperty.resolveWith((states) => 10),
          //           ),
          //           child: Text('Approve'),
          //         ),
          //       ),
          //
          //       // Adding some space between buttons(
          //       Container(
          //         margin: EdgeInsets.only(top: 400,left: 40),
          //         child: ElevatedButton(
          //           onPressed: () {
          //             // Add your onPressed logic for Button 2 here
          //           },
          //           style: ButtonStyle(
          //             backgroundColor: MaterialStateColor.resolveWith((states) => Colors.black),
          //             foregroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
          //             elevation: MaterialStateProperty.resolveWith((states) => 10),
          //           ),
          //           child: Text('Reject'),
          //         ),
          //       ),
          //
          //     ],
          //   ),
          // )

        ],
      ),
    );
  }
}
