// Example snippet for profile.dart
import 'package:flutter/material.dart';

class TransactionPage extends StatelessWidget {
  // Placeholder value for user data

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/transaction.png'), fit: BoxFit.cover),
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
                  ]),
            ))));
  }
}
