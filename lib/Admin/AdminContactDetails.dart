import 'package:flutter/material.dart';
class AdminContactDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: Govind Mess',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Owner: Mr. John Doe',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Mobile Number: +1234567890',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Name: Ulape Mess',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Owner: Mr. Sai Patil',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Mobile Number: +1234567890',
              style: TextStyle(fontSize: 16),
            ),
            // Add more contact details or actions as needed
          ],
        ),
      ),
    );
  }
}