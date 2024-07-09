// import 'dart:io';
//
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
// class PaymentScreen extends StatefulWidget {
//   @override
//   _PaymentScreenState createState() => _PaymentScreenState();
// }
//
// class _PaymentScreenState extends State<PaymentScreen> {
//   String? imageUrl;
//   final ImagePicker _imagePicker = ImagePicker();
//   bool isloading = false;
// XFile? image;
//   pickImage() async {
//     XFile? res = await _imagePicker.pickImage(source: ImageSource.gallery);
//
//     if (res != null) {
//       uploadtoFirebase(File(res.path));
//       setState(() {
//         image=res;
//       });
//     }
//   }
//
//   uploadtoFirebase(image) async {
//     setState(() {
//       isloading = true;
//     });
//     try {
//       Reference sr = FirebaseStorage.instance
//           .ref()
//           .child('Payments/${DateTime.now().millisecondsSinceEpoch}.png');
//
//       await sr.putFile(image).whenComplete(
//           () => {
//             // Fluttertoast.showToast(msg: 'Image uploaded to 🔥base')
//           print('uploaded Successfully-----------------------------------')
//           });
//
//       imageUrl = await sr.getDownloadURL();
//     } catch (e) {
//       print('Error occured $e');
//     }
//     setState(() {
//       isloading = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Admin Dashboard'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(color: Colors.grey.shade300)),
//                 height: 300,
//                 width: 300,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: imageUrl == null
//                       ? Image.asset('assets/imageUpload.jpg')
//                       : Image.network(imageUrl!),
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Center(
//                 child: Container(
//                   width: 200,
//                   child: ElevatedButton(
//                     style: ButtonStyle(
//                       backgroundColor: MaterialStateProperty.resolveWith(
//                           (states) => Colors.black),
//                       foregroundColor: MaterialStateProperty.resolveWith(
//                           (states) => Colors.white),
//                     ),
//                     onPressed: () {
//                       pickImage();
//                     },
//                     child: Text(
//                       "Upload QR",
//                       style:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 50,
//               ),
//               ElevatedButton(
//                 style: ButtonStyle(
//                   backgroundColor: MaterialStateProperty.resolveWith(
//                       (states) => Colors.black),
//                   foregroundColor: MaterialStateProperty.resolveWith(
//                       (states) => Colors.white),
//                 ),
//                 onPressed: () {
//                   // Navigate to Payment History Screen
//                 },
//                 child: Text(
//                   "View Payment History",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
// // Future getImage() async {
// //   final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
// //
// //   if (image != null) {
// //     setState(() {
// //       imageFile = File(image.path);
// //     });
// //     uploadImageToFirebase(imageFile!);
// //   }
// // }
// }


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

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

  String? email=FirebaseAuth.instance.currentUser?.email;
  String? imageUrl;
  final ImagePicker _imagePicker = ImagePicker();
  bool isloading = false;

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

      Reference sr = FirebaseStorage.instance.ref().child('Payments/${email}.png');

      await sr.putFile(image).whenComplete(() =>
      {
        Fluttertoast.showToast(msg: 'Image uploaded to 🔥base')
      });

      imageUrl = await sr.getDownloadURL();
      try{

        await FirebaseFirestore.instance.collection('messOwner').doc(email).update({
          'image':imageUrl
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


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300)),
                height: 300,
                width: 300,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: imageUrl == null
                      ? Image.asset('assets/imageUpload.jpg')
                      : Image.network(imageUrl!),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  width: 200,
                  child: ElevatedButton(
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
                      "Upload QR",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => Colors.black),
                  foregroundColor: MaterialStateProperty.resolveWith(
                          (states) => Colors.white),
                ),
                onPressed: () {
                  // Navigate to Payment History Screen
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentHistoryScreen(email: email,),));
                },
                child: Text(
                  "View Payment History",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}