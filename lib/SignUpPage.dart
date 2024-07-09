import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/LoginScreen.dart';
import 'package:project/main.dart';


FirebaseAuth _auth = FirebaseAuth.instance;
Future<void> signUp(String email, String password,String name) async {
  try {
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,

    );
    await FirebaseFirestore.instance.collection('users').doc(email).set({
      'name': name,
      'email': email,
      'password': password,
    });
    // Signup successful
  } catch (e) {
    // Handle signup failure
    print(e.toString());
  }
}
class SignUpPage extends StatelessWidget {
  TextEditingController email=TextEditingController();
  TextEditingController name=TextEditingController();
  TextEditingController password1=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text('Sign Up',style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),

      ),
      body: SingleChildScrollView(
          child:  Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Container(
                  margin: EdgeInsets.only(top: 100),
                  width: 350,
                  child: TextField(
                    controller: name,
                    decoration: InputDecoration(
                      hintText: "Name",
                      prefixIcon: Icon(Icons.mail_outline),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.black)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  width: 350,
                  child: TextField(
                    controller: email,
                    decoration: InputDecoration(
                      hintText: "Email",
                      prefixIcon: Icon(Icons.mail_outline),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.black)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  width: 350,
                  child: TextField(
                    controller: password1,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline_sharp),

                      hintText: "Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.black)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: 150,height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      signUp(email.text, password1.text,name.text);
                      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => LoginScreen(),));
                    },
                    child: Text('Sign Up',style: TextStyle(
                      color: Colors.white
                    ),),
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
                Container(
                  margin: EdgeInsets.only(left: 90,top: 10),
                  child: Row(
                    children: [
                      Text("Already have an account?"),
                      InkWell(
                        onTap: (){
                          _loginButtonAnimation(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 5),
                            child: Text("Login",style: TextStyle(
                              color: Colors.blue
                            ),)),
                      )
                    ],
                  ),
                )
              ],
            ),
          )

      ),
    );
  }
}


void _loginButtonAnimation(BuildContext context) {
  Navigator.of(context).pushReplacement(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(),
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

