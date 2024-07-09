import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/LoginScreen.dart';
import 'package:project/User/ViewMore.dart';

import 'Notification.dart';
import 'User/Userhomescreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final int _selectedIndex = 0;
  // Initialize _selectedIndex to the index of "Home"
  void _onItemTapped(BuildContext context, int index) {
    if (index == _selectedIndex) { // Check if the selected index is already the current index
      // If already on the same screen, do nothing

      return;
    }

    // Perform navigation based on the selected index
    if (index == 1) { // Check if "Profile" option is clicked
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserHomeScreen()),
      );
    }
  }

  Future<void> logout() async{
    try{
      await FirebaseAuth.instance.signOut();
      Fluttertoast.showToast(msg: "Successfully Logout");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
    }
    catch(e){
      print("Error for logout $e");
    }

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Available Mess'),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications), // Notification icon
              onPressed: () {
                // Navigate to the NotificationPage when the icon is clicked
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationPage()),
                );
              },
            ),
            Container(
              // margin: EdgeInsets.only(top: 30,left: 280),
              child: IconButton(
                icon: Icon(Icons.logout_outlined,
                  size: 30,),
                onPressed: (){
                  logout();
                },
              ),
            ),
          ],
        ),
        body:
        Stack(
          children: [
            MyCardListView(), // Your main content goes here
            Positioned(
              left: 1,
              right: 1,
              bottom: 0,
              child: BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: (index) => _onItemTapped(context, index),
                backgroundColor: Colors.black,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.grey,
                selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
                unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard),
                    label: 'Dashboard',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ],
        ),


      ),
    );
  }
}


class MyCardListView extends StatefulWidget {
  @override
  _MyCardListViewState createState() => _MyCardListViewState();
}

class _MyCardListViewState extends State<MyCardListView> {
  late Stream<QuerySnapshot> _messStream;
  TextEditingController _searchController = TextEditingController();
  late List<QueryDocumentSnapshot> _filteredMessList = [];
  late List<QueryDocumentSnapshot> _messDocs = []; // Declare messDocs here

  @override
  void initState() {
    super.initState();
    _messStream = FirebaseFirestore.instance.collection('messDetails').snapshots();
  }

  void _filterMessList(String query) {
    setState(() {
      _filteredMessList = query.isEmpty
          ? _messDocs.toList() // Use _messDocs to filter the complete list
          : _messDocs.where((mess) {
        final name = mess['name'].toString().toLowerCase();
        final address = mess['address'].toString().toLowerCase();
        return name.contains(query.toLowerCase()) ||
            address.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
            height: 52,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              onChanged: (value) {
                _filterMessList(value);
              },
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _messStream,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              _messDocs = snapshot.data!.docs; // Update _messDocs here

              return ListView.builder(
                itemCount: _searchController.text.isEmpty
                    ? _messDocs.length
                    : _filteredMessList.length,
                itemBuilder: (context, index) {
                  final messData = _searchController.text.isEmpty
                      ? _messDocs[index].data() as Map<String, dynamic>
                      : _filteredMessList[index].data() as Map<String, dynamic>;

                  final String name = messData['name'] ?? '';
                  final String address = messData['address'] ?? '';
                  final String imageUrl =
                      'assets/Image${index + 1}.jpg'; // Assuming images are named Image1.webp, Image2.webp, etc.

                  return CustomCard(
                    name: name,
                    address: address,
                    imageUrl: imageUrl,
                    onPressed: () {
                      print('-------------------------------------------------------${_messDocs[index].id}');

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Screen(phoneNumber: _messDocs[index].id),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}


class CustomCard extends StatelessWidget {
  final String name;
  final String address;
  final String imageUrl;
  final VoidCallback onPressed;

  const CustomCard({
    required this.name,
    required this.address,
    required this.imageUrl,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: InkWell(
        onTap: onPressed,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        address,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: onPressed,
                    child: Text(
                      'View More',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
