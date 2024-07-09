import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

// import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/Admin/AdminPaymentHistoryScreen.dart';

class PaymentDescription extends StatefulWidget {
  String imageURL,name,email;
  PaymentDescription({
    required this.imageURL,
    required this.name,
    required this.email,
  });
  // const PaymentDescription({super.key});

  @override
  State<PaymentDescription> createState() => _PaymentDescriptionState();
}

class _PaymentDescriptionState extends State<PaymentDescription> {
  bool isloading = false;
  String? messEmail;






  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Payments'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 40),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300)),
                  height: 300,
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: widget.imageURL == null
                        ? Image.asset('assets/imageUpload.jpg')
                        : Image.network(widget.imageURL),
                  ),
                ),

                SizedBox(
                  height: 60,
                ),
                Row(
                  children: [
                    Text('Name : ',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                    Text(widget.name,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20),),
                  ],
                ),

                Row(
                  children: [
                    Text('Email : ',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                    Text(widget.email,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20),),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
