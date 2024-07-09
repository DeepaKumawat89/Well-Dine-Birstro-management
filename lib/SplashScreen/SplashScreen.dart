import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/Admin/AdminDashboard.dart';
import 'package:project/LoginScreen.dart';
import 'package:project/homescreen.dart';

class SplashScreen extends StatefulWidget{
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {
  void initState(){
    Timer(Duration(seconds: 3), () {
      checkLogin();
    });
  }

  void checkLogin()async{
    User? user = FirebaseAuth.instance.currentUser;
if(user!=null){
  QuerySnapshot querySnapshot=await FirebaseFirestore.instance.collection('messOwner').get();
  if(querySnapshot.docs.isNotEmpty){
    querySnapshot.docs.forEach((element) {
      if(user.email==element.id) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminDashboard(),));
      }
    });
  }
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp(),));
}
else {
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),));

}
  }
  @override
  Widget build(BuildContext context) {
 return Scaffold(
   body:
   Center(
       child: Image.asset(
         'assets/Splashimage.jpg', // Path to your splash screen image
         width: 400, // Adjust width as needed
         height: 400, // Adjust height as needed
       ),),

 );
  }
}