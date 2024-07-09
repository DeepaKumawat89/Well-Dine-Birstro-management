import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserChangeMenu extends StatefulWidget {
  @override
  State<UserChangeMenu> createState() => _UserChangeMenuState();
}

class _UserChangeMenuState extends State<UserChangeMenu> {
  late String? userEmail;
  void initState(){
    super.initState();
    FirebaseAuth _auth=FirebaseAuth.instance;
    User? user=_auth.currentUser;
    userEmail=user?.email;

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

      ),
    );
  }

  Widget _buildMenuList(String itemType) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) {
          return Center(child: Text('Error fetching data'));
        }

        String ownerEmail = snapshot.data!.get('messName');

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
                          // IconButton(
                          //   onPressed: () {
                          //     _deleteItem(ownerEmail, itemType, index);
                          //   },
                          //   icon: Icon(Icons.restore_from_trash),
                          // )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

}

