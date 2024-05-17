import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:safaai/login.dart';

class ProfilePage extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: user != null
          ? FirebaseFirestore.instance
              .collection('users')
              .doc(user!.email)
              .snapshots()
          : null,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        Map<String, dynamic>? userData =
            snapshot.data?.data() as Map<String, dynamic>?;
        if (userData != null) {
          String name = userData['Name'];
          String email = userData['Email'];
          int phone = userData['PhoneNumber'];
          String upi = userData['UpiId'];

          return Container(
            color: Color(0xFF1e1f21),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: Colors.transparent,
                title: Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 50,
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontFamily: 'Gilroy',
                  ),
                ),
              ),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Color(0xFFffbe00),
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: Icon(
                                Icons.person,
                                color: Color.fromARGB(255, 29, 28, 28),
                                size: 30.0,
                              ),
                              title: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      name,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF1e1f21),
                                        fontFamily: 'Gilroy-SemiBold',
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          String newValue = '';
                                          return AlertDialog(
                                            backgroundColor: Color(0xFFffbe00),
                                            content: TextField(
                                              onChanged: (value) {
                                                newValue = value;
                                              },
                                              decoration: InputDecoration(
                                                hintText: 'Enter new Name',
                                              ),
                                            ),
                                            actions: [
                                              GestureDetector(
                                                onTap: () async {
                                                  if (newValue.trim().isEmpty) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                            'Please enter a valid name'),
                                                      ),
                                                    );
                                                  } else {
                                                    final userDocRef =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(user!.email);
                                                    try {
                                                      await userDocRef.update(
                                                          {'Name': newValue});
                                                      Navigator.pop(context);
                                                    } catch (error) {
                                                      print(
                                                          'Error updating Name: $error');
                                                    }
                                                  }
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 13.0,
                                                      horizontal: 10.0),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFF1e1f21),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                                  child: Text(
                                                    'Submit',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 13.0,
                                                      horizontal: 10.0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                                  child: Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.email,
                                color: Color.fromARGB(255, 29, 28, 28),
                                size: 30.0,
                              ),
                              title: Text(
                                email,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF1e1f21),
                                  fontFamily: 'Gilroy-SemiBold',
                                ),
                              ),
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.phone,
                                color: Color.fromARGB(255, 29, 28, 28),
                                size: 30.0,
                              ),
                              title: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      phone.toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF1e1f21),
                                        fontFamily: 'Gilroy-SemiBold',
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          String newValue = '';
                                          return AlertDialog(
                                            backgroundColor: Color(0xFFffbe00),
                                            content: TextField(
                                              onChanged: (value) {
                                                newValue = value;
                                              },
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                                LengthLimitingTextInputFormatter(
                                                    10),
                                              ],
                                              decoration: InputDecoration(
                                                hintText:
                                                    'Enter new Phone Number',
                                              ),
                                            ),
                                            actions: [
                                              GestureDetector(
                                                onTap: () async {
                                                  if (newValue.trim().isEmpty ||
                                                      !RegExp(r'^[0-9]{10}$')
                                                          .hasMatch(newValue)) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                            'Please enter a valid 10-digit phone number'),
                                                      ),
                                                    );
                                                  } else {
                                                    final userDocRef =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(user!.email);
                                                    try {
                                                      await userDocRef.update({
                                                        'PhoneNumber':
                                                            int.parse(newValue)
                                                      });
                                                      Navigator.pop(context);
                                                    } catch (error) {
                                                      print(
                                                          'Error updating Phone Number: $error');
                                                    }
                                                  }
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 13.0,
                                                      horizontal: 10.0),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFF1e1f21),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                                  child: Text(
                                                    'Submit',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 13.0,
                                                      horizontal: 10.0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                                  child: Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            ListTile(
                              leading: Icon(
                                FontAwesomeIcons.piggyBank,
                                color: Color.fromARGB(255, 29, 28, 28),
                                size: 30.0,
                              ),
                              title: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      upi,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF1e1f21),
                                        fontFamily: 'Gilroy-SemiBold',
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          String newValue = '';
                                          return AlertDialog(
                                            backgroundColor: Color(0xFFffbe00),
                                            content: TextField(
                                              onChanged: (value) {
                                                newValue = value;
                                              },
                                              decoration: InputDecoration(
                                                hintText: 'Enter new UPI ID',
                                              ),
                                            ),
                                            actions: [
                                              GestureDetector(
                                                onTap: () async {
                                                  if (newValue.trim().isEmpty) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                            'Please enter a valid UPI ID'),
                                                      ),
                                                    );
                                                  } else {
                                                    final userDocRef =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(user!.email);
                                                    try {
                                                      await userDocRef.update(
                                                          {'UpiId': newValue});
                                                      Navigator.pop(context);
                                                    } catch (error) {
                                                      print(
                                                          'Error updating UPI ID: $error');
                                                    }
                                                  }
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 13.0,
                                                      horizontal: 10.0),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFF1e1f21),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                                  child: Text(
                                                    'Submit',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 13.0,
                                                      horizontal: 10.0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                                  child: Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await FirebaseAuth.instance.signOut();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              padding: EdgeInsets.symmetric(
                                vertical: 13.0,
                                horizontal: 10.0,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFFffbe00),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  "Log Out",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 29, 28, 28),
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await user!.delete();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              padding: EdgeInsets.symmetric(
                                vertical: 13.0,
                                horizontal: 10.0,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  "Delete Account",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          print('Error: Reinstall the app');
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/profile.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Text('Error: Reinstall the app'),
              ),
            ),
          );
        }
      },
    );
  }
}
