// Example snippet for profile.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String userName = 'Dilshith'; // Placeholder value for user data

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/profile.png'), fit: BoxFit.cover),
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
                child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(110),
                      child: Column(),
                    ),
                    SizedBox(height: 50),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'LogOut\t',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Color(0xFFffbe00),
                            child: IconButton(
                              color: const Color.fromARGB(255, 29, 28, 28),
                              onPressed: () => FirebaseAuth.instance.signOut(),
                              icon: Icon(Icons.chevron_right_rounded),
                            ),
                          ),
                        ],
                      ),
                  ]),

            ))));
  }
}
