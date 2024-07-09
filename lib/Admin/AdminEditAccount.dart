import 'package:flutter/material.dart';


class EditAccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile_placeholder.jpg'),
              // Replace with actual user profile picture logic
            ),
            SizedBox(height: 12),
            Text(
              'Username',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter your username',
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Email',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter your email',
              ),
            ),
            SizedBox(height: 16),
            Text(
              'New Password',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Enter your new password',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add logic to save changes
              },
              child: Text('Save Changes'),
            ),
            SizedBox(height: 2),
            TextButton(
              onPressed: () {
                // Add logic to show account deactivation confirmation
              },
              child: Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}
