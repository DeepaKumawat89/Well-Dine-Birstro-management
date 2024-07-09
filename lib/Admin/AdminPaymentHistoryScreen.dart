import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/Admin/PaymentDescription.dart';

class PaymentHistoryScreen extends StatefulWidget {
  final String? email;

  PaymentHistoryScreen({required this.email});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  List<String> names = [];
  List<String> emails = [];
  List<String> imageURL = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('messOwner')
          .doc(widget.email)
          .collection('payments')
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        List<String> fetchedNames = [];
        List<String> fetchedEmails = [];
        List<String> fetchedImages = [];
        for (var element in querySnapshot.docs) {
          fetchedEmails.add(element.id);

          fetchedImages.add(element.get('receipt'));
          print('------------------------------${element.get('receipt')}');
          DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(element.id)
              .get();
          fetchedNames.add(documentSnapshot.get('name'));
        }
        setState(() {
          names = fetchedNames;
          emails = fetchedEmails;
          imageURL = fetchedImages;
        });
      }
    } catch (e) {
      print(e); // Handle errors appropriately
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment History'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (names.isEmpty) // Check if data is loaded
                Center(
                  child: CircularProgressIndicator(), // Show loading indicator
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: names.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentDescription(imageURL: imageURL[index],name: names[index],email: emails[index],),));
                      },
                      child: Card(
                        color: Colors.white,
                        child: ListTile(
                          leading: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          title: Text(
                            names[index],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            emails[index],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
