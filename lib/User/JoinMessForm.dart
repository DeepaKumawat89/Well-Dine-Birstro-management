import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class JoinMessForm extends StatefulWidget {
  late String phoneNumber;
  JoinMessForm({required this.phoneNumber});

  @override
  State<JoinMessForm> createState() => _JoinMessFormState();
}

class _JoinMessFormState extends State<JoinMessForm> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join Form'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.grey.shade300,
            height: 2.0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              child: TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter your name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.blue)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                      borderRadius: BorderRadius.circular(15)),

                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.blue)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(15)),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(

              controller: contactNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Contact Number',
                hintText: 'Enter your contact number',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.blue)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(15)),
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              height: 50,
              margin: EdgeInsets.only(left: 80,right: 80,top: 60),
              child: ElevatedButton(
                onPressed: () {
                  String name = nameController.text;
                  String email = emailController.text;
                  String contactNumber = contactNumberController.text;
                  // var t = TimeOfDay.now();
                  var d = DateTime.now();

                  var firestore = FirebaseFirestore.instance;

                  // Set the document ID as the phoneNumber
                  String phoneNumber = widget.phoneNumber;

                  // Add data to Firestore
                  firestore.collection('mess').doc(phoneNumber).collection('requests').doc(email).set({
                    'name': name,
                    'email': email,
                    'contactNumber': contactNumber,
                    // 'time': '${t.hour}:${t.minute}',
                    'time': '${d.hour}:${d.minute}',
                    'date': '${d.day}-${d.month}-${d.year}',
                    'approved':0
                  }).then((value) {
                    print('Data added to Firestore');
                  }).catchError((error) {
                    print('Failed to add data to Firestore: $error');
                  });

                },
                child: Text('Submit',style: TextStyle(fontSize: 16,color: Colors.white),),
                style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.resolveWith(
                          (states) => Colors.blue),

                ),

              ),
            ),
          ],
        ),
      ),
    );
  }
}
