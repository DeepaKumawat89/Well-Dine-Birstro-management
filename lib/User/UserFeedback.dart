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

class UserPayments extends StatefulWidget {
  const UserPayments({super.key});

  @override
  State<UserPayments> createState() => _UserPaymentsState();
}

class _UserPaymentsState extends State<UserPayments> {
  String? imageUrl, url;
  final ImagePicker _imagePicker = ImagePicker();
  bool isloading = false;
  String? messEmail;
  pickImage() async {
    XFile? res = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (res != null) {
      uploadtoFirebase(File(res.path));
    }
  }

  uploadtoFirebase(image) async {
    setState(() {
      isloading = true;
    });
    try {
      String? email = FirebaseAuth.instance.currentUser?.email;

      Reference sr =
      FirebaseStorage.instance.ref().child('UserPayments/${email}.png');

      await sr.putFile(image).whenComplete(
              () => {Fluttertoast.showToast(msg: 'Image uploaded to 🔥base')});

      imageUrl = await sr.getDownloadURL();

      try{

        await FirebaseFirestore.instance.collection('messOwner').doc(messEmail).collection('payments').doc(email).set({
          'receipt':imageUrl
        });

      }
      catch(e){

      }


    } catch (e) {
      print('Error occured $e');
    }
    setState(() {
      isloading = false;
    });
  }

  void initState() {
    super.initState();
    print('----------------------------');
    getURl();
    print('----------------------------');
  }

  Future<void> getURl() async {
    String? email = FirebaseAuth.instance.currentUser?.email;
    DocumentSnapshot documentSnapshot =
    await FirebaseFirestore.instance.collection('users').doc(email).get();
    messEmail=documentSnapshot.get('messName');
    print('-----------------------------------------------------$messEmail');
    DocumentSnapshot documentSnapshot1 = await FirebaseFirestore.instance
        .collection('messOwner')
        .doc(documentSnapshot.get('messName'))
        .get();
    url = documentSnapshot1.get('image');
    setState(() {});
  }

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
                  margin: EdgeInsets.only(top: 60),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300)),
                  height: 300,
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: url == null
                        ? Image.asset('assets/imageUpload.jpg')
                        : Image.network(url!),
                  ),
                ),

                SizedBox(
                  height: 60,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => Colors.black),
                    foregroundColor: MaterialStateProperty.resolveWith(
                            (states) => Colors.white),
                  ),
                  onPressed: () {
                    pickImage();
                  },
                  child: Text(
                    "Upload Receipt",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
