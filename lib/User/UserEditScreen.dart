import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profile Edit Example',
      home: ProfileEditScreen(),
    );
  }
}

class ProfileEditScreen extends StatefulWidget {
  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  int _currentIndex = 0; // Index for bottom navigation bar
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _bioController = TextEditingController();

  @override
  void initState() {
    // Initialize controllers with user data (if available)
    _nameController.text = "John Doe";
    _emailController.text = "john.doe@example.com";
    _bioController.text = "I love coding!";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _bioController,
                decoration: InputDecoration(labelText: 'Bio'),
                maxLines: 3,
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  // Handle the save button press, update user profile data
                  _saveProfile();
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          // Handle bottom navigation item taps
          _onTabTapped(index);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Edit Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          // Add more items as needed
        ],
      ),
    );
  }

  void _saveProfile() {
    // Implement logic to save/update the user's profile
    String name = _nameController.text;
    String email = _emailController.text;
    String bio = _bioController.text;

    // Perform the necessary operations to save the data (e.g., API call, database update)
    // You can replace this with your own logic based on your application's needs

    // For demonstration purposes, print the updated data
    print('Updated Profile:');
    print('Name: $name');
    print('Email: $email');
    print('Bio: $bio');

    // Optionally, show a snackbar or navigate to another screen after saving
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile saved successfully!'),
      ),
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      // Handle navigation to different screens based on the selected index
      // You can use Navigator or any other navigation method here
    });
  }
}
