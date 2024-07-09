import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChangeMenuScreen extends StatefulWidget {
  @override
  State<ChangeMenuScreen> createState() => _ChangeMenuScreenState();
}

class _ChangeMenuScreenState extends State<ChangeMenuScreen> {
  late String? ownerEmail;
  void initState(){
    super.initState();
    FirebaseAuth _auth=FirebaseAuth.instance;
    User? user=_auth.currentUser;
    ownerEmail=user?.email;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Menu"),
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Text(
                    "Veg",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Text(
                    "Non-Veg",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Content of the first tab ("Veg")
            _buildMenuList('Veg'),
            // Content of the second tab ("Non-Veg")
            _buildMenuList('Non-veg'),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: Text("Add Item", style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.black,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AdminChangeMenuScreen()));
          },
        ),
      ),
    );
  }

  Widget _buildMenuList(String itemType) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('messOwner')
          .doc(ownerEmail)
          .collection('menu')
          .doc(itemType)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        var items = snapshot.data!.get('items') as List<dynamic>;

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 70,
                child: Card(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0,top: 18),
                        child: Text('${index+1}) ${items[index]}',style: TextStyle(fontSize: 18)),
                      ),
                      IconButton(
                        onPressed: () {
                          _deleteItem(itemType, index);
                        },
                        icon: Icon(Icons.restore_from_trash),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _deleteItem(String itemType, int index) async {
    try {
      // Get a reference to the menu document
      DocumentReference menuRef = FirebaseFirestore.instance
          .collection('messOwner')
          .doc(ownerEmail)
          .collection('menu')
          .doc(itemType);

      // Fetch the current items array
      DocumentSnapshot snapshot = await menuRef.get();
      List<dynamic> items = snapshot.get('items');

      // Remove the item at the specified index
      items.removeAt(index);

      // Update the items array in Firestore
      await menuRef.update({'items': items});
    } catch (error) {
      print("Failed to delete item: $error");
    }
  }
}





class AdminChangeMenuScreen extends StatefulWidget {
  @override
  _AdminChangeMenuScreenState createState() => _AdminChangeMenuScreenState();
}

class _AdminChangeMenuScreenState extends State<AdminChangeMenuScreen> {
  TextEditingController newItemController = TextEditingController();
  int? _selectedValue = 0; // Initialize _selectedValue
  late String? ownerEmail;
  void initState(){
    super.initState();
    FirebaseAuth _auth=FirebaseAuth.instance;
    User? user=_auth.currentUser;
    ownerEmail=user?.email;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Menu'),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 20),
            child: Row(
              children: [
                Row(
                  children: [
                    Radio<int>(
                      activeColor: Colors.black,
                      value: 0,
                      groupValue: _selectedValue,
                      onChanged: (int? value) {
                        setState(() {
                          _selectedValue = value;
                        });
                      },
                    ),
                    Text('Veg', style: TextStyle(fontFamily: "MainFont")),
                  ],
                ),
                Row(
                  children: [
                    Radio<int>(
                      activeColor: Colors.black,
                      value: 1,
                      groupValue: _selectedValue,
                      onChanged: (int? value) {
                        setState(() {
                          _selectedValue = value;
                        });
                      },
                    ),
                    Text('Non-Veg',
                        style: TextStyle(fontFamily: "MainFont")),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: newItemController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black, width: 1)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black, width: 2)),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Call function to save menu changes
              saveMenuChanges();
            },
            child: Text("Submit"),
          ),
        ],
      ),
    );
  }

  void saveMenuChanges() {
    // Extract selected radio button value
    String itemType = _selectedValue == 0 ? 'Veg' : 'Non-veg';

    // Get text field value
    String newItem = newItemController.text;

    // Store data into Firebase
    FirebaseFirestore.instance
        .collection('messOwner')
        .doc(ownerEmail)
        .collection('menu')
        .doc(itemType) // Use itemType as document ID
        .update({
      'items': FieldValue.arrayUnion([newItem]),
    }).then((value) {
      // On success, navigate back to previous screen
      Navigator.pop(context);
    }).catchError((error) {
      // Handle error
      print("Failed to add item: $error");
    });
  }
}


