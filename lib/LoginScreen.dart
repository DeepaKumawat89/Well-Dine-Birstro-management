import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/homescreen.dart';
import 'Admin/AdminLogin.dart';
import 'SignUpPage.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _loginState();
}

class _loginState extends State<LoginScreen>{
  bool passwordText = true;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
// FirebaseFirestore ref=FirebaseFirestore.instance.
  Future<void> _login() async {
    String userEmail = email.text.trim();
    String userPassword = password.text.trim();

    try {
      await _auth.signInWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp()));
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text("Login",
        style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Center(
              child: Text(
                " Welcome",
                style: TextStyle(fontSize: 45, fontFamily: 'MainFont'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(
                    controller: email,
                    decoration: InputDecoration(
                      hintText: "Email",
                      prefixIcon: Icon(Icons.mail_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: password,
                    obscureText: passwordText,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline_sharp),
                      suffixIcon: InkWell(
                        child: Icon(Icons.remove_red_eye),
                        onTap: () {
                          setState(() {
                            passwordText = !passwordText;
                          });
                        },
                      ),
                      hintText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Container(width: 140,height: 50,
                    child: ElevatedButton(
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontFamily: 'MainFont'),
                      ),
                      onPressed: _login,
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80.0),
                          ),
                        ),
                        backgroundColor: MaterialStateColor.resolveWith((states) => Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account?",
                  style: TextStyle(fontFamily: 'MainFont1'),
                ),
                InkWell(
                  onTap: () {
                    _loginButtonAnimation(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'MainFont',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminPage()),
                );
              },
              child: Text(
                'Login as Mess Owner',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _loginButtonAnimation(BuildContext context) {
  Navigator.of(context).pushReplacement(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SignUpPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCirc;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    ),
  );
}
