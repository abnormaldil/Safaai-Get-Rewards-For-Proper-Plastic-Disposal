// Example snippet for profile.dart
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String userName = 'John Doe'; // Placeholder value for user data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('User Name: $userName'),
            TextField(
              decoration: InputDecoration(labelText: 'Update UpiId'),
            ),
            ElevatedButton(
              onPressed: () {
                // Update UpiId in the database
              },
              child: Text('Update'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
