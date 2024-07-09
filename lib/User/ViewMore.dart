import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/User/JoinMessForm.dart';

class Screen extends StatelessWidget {
  final String phoneNumber;

  Screen({required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('More Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('messDetails').doc(phoneNumber).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No data found.'));
          }

          final messData = snapshot.data!.data() as Map<String, dynamic>;
          final String name = messData['name'] ?? '';
          final String address = messData['address'] ?? '';
          final String charges = messData['charges'] != null ? messData['charges'].toString() : '';
          final String special = messData['special'] ?? '';
          final String phone = messData['phoneNo'] ?? '';

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/Image1.jpg'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, top: 10),
                child: Text(
                  name,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20, top: 10),
                    child: Text(
                      "Address :",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, top: 10),
                    child: Text(
                      address,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20, top: 10),
                    child: Text(
                      "Phone No :",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, top: 10),
                    child: Text(
                      phone,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20, top: 10),
                    child: Text(
                      "Charges :",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, top: 10),
                    child: Text(
                      charges,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20, top: 10),
                    child: Text(
                      "Special :",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: 200,
                    margin: EdgeInsets.only(left: 10, top: 10),
                    child: Text(
                      special,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 80),
                  child: ElevatedButton(
                    child: Text("Join Mess"),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => JoinMessForm(phoneNumber: phoneNumber,),));
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith((states) => Colors.black),
                      foregroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
                      elevation: MaterialStateProperty.resolveWith((states) => 10),
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
