import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RedeemPage extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: user != null
          ? FirebaseFirestore.instance
              .collection('users')
              .doc(user!.email) // Use email instead of UID
              .snapshots()
          : null,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        Map<String, dynamic>? userData =
            snapshot.data?.data() as Map<String, dynamic>?;
        if (userData != null) {
          int creditBalance = userData['CreditBalance'];
          return _buildRedeemUI(context, creditBalance, userData);
        } else {
          // Handle the case where user data is null (e.g., show an error message)
          print('Error: User data not found in Firestore');
          return Scaffold(
            body: Center(
              child: Text('Error: User data not found in Firestore'),
            ),
          );
        }
      },
    );
  }

  Widget _buildRedeemUI(
      BuildContext context, int creditBalance, Map<String, dynamic> userData) {
    return Container(
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage('assets/redeem.png'),
      //     fit: BoxFit.cover,
      //   ),
      // ),
      child: Scaffold(
        backgroundColor: Color(0xFF1e1f21),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xFF1e1f21),
          title: Text(
            'Redeem',
            style: TextStyle(
              fontSize: 36,
              color: Color.fromARGB(255, 255, 255, 255),
              fontFamily: 'Gilroy',
            ),
          ),
        ),
        body: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.005),
              SizedBox(
                height: 0.0,
              ),
              Container(
                alignment: Alignment.center,
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 255, 162, 0).withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 25,
                      offset: Offset(0, 3),
                    ),
                  ],
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 74, 74, 79),
                      Color.fromARGB(255, 19, 18, 18),
                      Color.fromARGB(255, 39, 39, 40),
                    ],
                  ),
                ),
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 5.0),
                      Icon(
                        FontAwesomeIcons.leaf,
                        size: 45.0, // Adjust the size as needed
                        color: Color(0xFFffbe00),
                      ),
                      Text(
                        creditBalance.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40),
              Text(
                'Redemption Guidelines:',
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: 'Gilroy',
                  color: Color(0xFFffbe00),
                ),
              ),
              SizedBox(height: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• Minimum redemption of 100 tokens',
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'Gilroy',
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  Text(
                    '• Redeemable in multiples of 100',
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'Gilroy',
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Redeem\t',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Gilroy',
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xFFffbe00),
                    child: IconButton(
                      color: const Color.fromARGB(255, 29, 28, 28),
                      onPressed: () =>
                          _redeemCredits(context, creditBalance, userData),
                      icon: Icon(Icons.chevron_right_rounded),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _redeemCredits(
      BuildContext context, int creditBalance, Map<String, dynamic> userData) {
    if (creditBalance % 100 == 0 && creditBalance >= 100) {
      int redeemedCredit = creditBalance;
      int newCreditBalance = creditBalance - redeemedCredit;

      FirebaseFirestore.instance
          .collection('users')
          .doc(user!.email) // Use email instead of UID
          .update({'CreditBalance': newCreditBalance});

      userData['CreditBalance'] = newCreditBalance;

      Timestamp transactionTime = Timestamp.now();

      String upiId = userData['UpiId'];
      String email = userData['Email'];

      FirebaseFirestore.instance
          .collection('transactions')
          .doc(user!.email) // Use email instead of UID
          .collection(user!.email!) // Use email instead of UID
          .add({
        'RedeemAmount': redeemedCredit,
        'Time': transactionTime,
        'Date': transactionTime.toDate(),
        'UpiId': upiId,
        'Email': email,
      }).then((_) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Success'),
              backgroundColor: Color(0xFFffbe00),
              content: Text('Redeemed $redeemedCredit Credits!'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }).catchError((error) {
        // Handle errors during transaction record saving
        print("Error saving transaction: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred. Please try again.'),
          ),
        );
      });
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Insufficient balance or invalid amount for redemption.'),
        ),
      );
    }
  }
}
