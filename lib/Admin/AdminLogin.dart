import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/Admin/AdminApprovalScreen.dart';
import 'package:project/Admin/AdminDashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: Text(
          'Admin Login',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 32,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width: 200,height: 200,
                margin: EdgeInsets.only(left: 80,top: 40),
                child: Image.asset(
                  'assets/Loginimage.jpg'
                ),
              ),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              SizedBox(height: 32),
              Container(
                width: 140,
                margin: EdgeInsets.only(left: 100),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.all(16),
                  ),
                  onPressed: () {
                    _signIn();
                  },
                  child: Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signIn() async {
    String enteredEmail = _emailController.text.toString().trim();
    String enteredPassword = _passwordController.text.toString().trim();

    try {
      var docSnapshot = await _firestore.collection('messOwner').doc(enteredEmail).get();

      if (docSnapshot.exists) {
        try {
          final FirebaseAuth _auth = FirebaseAuth.instance;
          _auth.signInWithEmailAndPassword(email: enteredEmail, password: enteredPassword).then((value) {
            Fluttertoast.showToast(msg: 'Found');
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdminDashboard()),
            );
          });
        } catch (e) {
          print('Error: $e');
        }
      } else {
        Fluttertoast.showToast(
          msg: "Email not found",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
