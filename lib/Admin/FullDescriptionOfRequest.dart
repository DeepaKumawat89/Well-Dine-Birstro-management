import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FullDescriptionOfRequest extends StatefulWidget {
  late String name,phoneNumber,email,time,date;
  late String? ownerEmail;
  FullDescriptionOfRequest({
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.date,
    required this.time,
    required this.ownerEmail,
  });
  @override
  _FullDescriptionOfRequestState createState() =>
      _FullDescriptionOfRequestState();
}

class _FullDescriptionOfRequestState extends State<FullDescriptionOfRequest> {

  Future<void> approved() async {
    try {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('mess')
          .doc(widget.ownerEmail)
          .collection('requests')
          .doc(widget.email);

      await documentReference.update({'approved': 1});
      FirebaseFirestore.instance.collection('users').doc(widget.email).update({
        'messName': widget.ownerEmail
      });
      Fluttertoast.showToast(
        msg: 'Request approved successfully!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } catch (error) {
      Fluttertoast.showToast(
        msg: 'Failed to approve request. Please try again later.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      print('Error updating document: $error');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Requests'),
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
                  "Requested Date : ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),Container(
                margin: EdgeInsets.only(left: 20),
                child: Text(
                  widget.date,
                  style: TextStyle( fontSize: 20),
                ),
              ),
            ],
          ), Row(
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

          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 400),
                  child: ElevatedButton(
                    onPressed: () {
                      approved();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith((states) => Colors.black),
                      foregroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
                      elevation: MaterialStateProperty.resolveWith((states) => 10),
                    ),
                    child: Text('Approve'),
                  ),
                ),

                // Adding some space between buttons(
                Container(
                  margin: EdgeInsets.only(top: 400,left: 40),
                  child: ElevatedButton(
                    onPressed: () {
                      // Add your onPressed logic for Button 2 here
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith((states) => Colors.black),
                      foregroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
                      elevation: MaterialStateProperty.resolveWith((states) => 10),
                    ),
                    child: Text('Reject'),
                  ),
                ),

              ],
            ),
          )

        ],
      ),
    );
  }
}