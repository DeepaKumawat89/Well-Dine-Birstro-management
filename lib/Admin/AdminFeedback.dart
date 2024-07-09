import 'package:flutter/material.dart';

class AdminFeedbackScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Feedback'),
      ),
      body: ListView.builder(
        itemCount: feedbackList.length,
        itemBuilder: (context, index) {
          final feedback = feedbackList[index];
          return ListTile(
            title: Text('User: ${feedback.user}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Date: ${feedback.date}'),
                Text('Category: ${feedback.category}'),
                Text('Status: ${feedback.status}'),
                Text('Feedback: ${feedback.content}'),
              ],
            ),
            onTap: () {
              // Navigate to the detailed view screen when tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FeedbackDetailsScreen(feedback: feedback),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class FeedbackDetailsScreen extends StatelessWidget {
  final FeedbackEntry feedback;

  FeedbackDetailsScreen({required this.feedback});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('User: ${feedback.user}'),
            Text('Date: ${feedback.date}'),
            Text('Category: ${feedback.category}'),
            Text('Status: ${feedback.status}'),
            Text('Feedback: ${feedback.content}'),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}

class FeedbackEntry {
  final String user;
  final DateTime date;
  final String category;
  final String status;
  final String content;

  FeedbackEntry({
    required this.user,
    required this.date,
    required this.category,
    required this.status,
    required this.content,
  });
}

final List<FeedbackEntry> feedbackList = [
  FeedbackEntry(
    user: 'John Doe',
    date: DateTime(2022, 3, 20),
    category: 'Bug Report',
    status: 'Pending',
    content: 'The app crashes when I perform a certain action.',
  ),
  // Add more feedback entries as needed
];
