import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:safaai/bottomnav.dart';
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
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: Colors.transparent,
                title: Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 34,
                    color: const Color.fromARGB(255, 80, 79, 79),
                    fontFamily: 'Gilroy',
                  ),
                ),
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back, // Back arrow icon
                    color: const Color.fromARGB(255, 80, 79, 79),
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => BottomNav()));
                  },
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.info_outline,
                      color: const Color.fromARGB(255, 80, 79, 79),
                      size: 30,
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Color(
                                  0xFF1e1f21), // Set background color to dark
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Center(
                                    child: Text(
                                      'Project Safaai',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Project Members:',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Center(
                                    child: Text(
                                      'Aiswarya M K\nDilshith T S\nKarthika Raju\nNakul P',
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 42, 254, 169),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Guide:',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Center(
                                    child: Text(
                                      'Prof. Aswathy B',
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 42, 254, 169),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              body: Container(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color.fromARGB(255, 29, 213, 140),
                                Color.fromARGB(255, 42, 254, 169),
                                Color.fromARGB(255, 29, 213, 140),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(255, 42, 254, 169)
                                    .withOpacity(0.5),
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
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  size: 30.0,
                                ),
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        name,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontFamily: 'Gilroy',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            String newValue = '';
                                            return AlertDialog(
                                              backgroundColor: Color.fromARGB(
                                                  255, 42, 254, 169),
                                              content: SingleChildScrollView(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    TextField(
                                                      onChanged: (value) {
                                                        newValue = value;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                              fillColor: Color
                                                                  .fromARGB(
                                                                      0,
                                                                      255,
                                                                      255,
                                                                      255),
                                                              filled: true,
                                                              hintText:
                                                                  "Enter New Name",
                                                              hintStyle: TextStyle(
                                                                  fontSize:
                                                                      15.0,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          29,
                                                                          28,
                                                                          28)),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            254,
                                                                            215,
                                                                            20),
                                                                    width: 5.0),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30),
                                                              )),
                                                    ),
                                                    SizedBox(height: 20),
                                                  ],
                                                ),
                                              ),
                                              actions: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    if (newValue
                                                        .trim()
                                                        .isEmpty) {
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
                                                              .collection(
                                                                  'users')
                                                              .doc(user!.email);
                                                      try {
                                                        await userDocRef
                                                            .update({
                                                          'Name':
                                                              newValue.trim()
                                                        });
                                                        Navigator.pop(context);
                                                      } catch (error) {
                                                        print(
                                                            'Error updating Name: $error');
                                                      }
                                                    }
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10.0,
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
                                                    padding:
                                                        EdgeInsets.symmetric(
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
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  size: 30.0,
                                ),
                                title: Text(
                                  email,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontFamily: 'Gilroy',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.phone,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  size: 30.0,
                                ),
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        phone.toString(),
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontFamily: 'Gilroy',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            String newValue = '';
                                            return AlertDialog(
                                              backgroundColor: Color.fromARGB(
                                                  255, 19, 212, 151),
                                              content: SingleChildScrollView(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    TextField(
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
                                                      decoration:
                                                          InputDecoration(
                                                              fillColor: Color
                                                                  .fromARGB(
                                                                      0,
                                                                      255,
                                                                      255,
                                                                      255),
                                                              filled: true,
                                                              hintText:
                                                                  "Enter New Phone Number",
                                                              hintStyle: TextStyle(
                                                                  fontSize:
                                                                      15.0,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          29,
                                                                          28,
                                                                          28)),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            254,
                                                                            215,
                                                                            20),
                                                                    width: 5.0),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30),
                                                              )),
                                                    ),
                                                    SizedBox(height: 20),
                                                  ],
                                                ),
                                              ),
                                              actions: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    if (newValue
                                                            .trim()
                                                            .isEmpty ||
                                                        !RegExp(r'^[0-9]{10}$')
                                                            .hasMatch(
                                                                newValue)) {
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
                                                              .collection(
                                                                  'users')
                                                              .doc(user!.email);
                                                      try {
                                                        await userDocRef
                                                            .update({
                                                          'PhoneNumber':
                                                              int.parse(newValue
                                                                  .trim())
                                                        });
                                                        Navigator.pop(context);
                                                      } catch (error) {
                                                        print(
                                                            'Error updating Phone Number: $error');
                                                      }
                                                    }
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
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
                                                    padding:
                                                        EdgeInsets.symmetric(
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
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  size: 30.0,
                                ),
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        upi,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontFamily: 'Gilroy',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            String newValue = '';
                                            return AlertDialog(
                                              backgroundColor: Color.fromARGB(
                                                  255, 19, 212, 151),
                                              content: SingleChildScrollView(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    TextField(
                                                      onChanged: (value) {
                                                        newValue = value;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                              fillColor: Color
                                                                  .fromARGB(
                                                                      0,
                                                                      255,
                                                                      255,
                                                                      255),
                                                              filled: true,
                                                              hintText:
                                                                  "Enter New UPI Id",
                                                              hintStyle: TextStyle(
                                                                  fontSize:
                                                                      15.0,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          29,
                                                                          28,
                                                                          28)),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            254,
                                                                            215,
                                                                            20),
                                                                    width: 5.0),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            50),
                                                              )),
                                                    ),
                                                    SizedBox(height: 20),
                                                  ],
                                                ),
                                              ),
                                              actions: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    if (newValue
                                                        .trim()
                                                        .isEmpty) {
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
                                                              .collection(
                                                                  'users')
                                                              .doc(user!.email);
                                                      try {
                                                        await userDocRef
                                                            .update({
                                                          'UpiId':
                                                              newValue.trim()
                                                        });
                                                        Navigator.pop(context);
                                                      } catch (error) {
                                                        print(
                                                            'Error updating UPI ID: $error');
                                                      }
                                                    }
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
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
                                                    padding:
                                                        EdgeInsets.symmetric(
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
                      ),
                      SizedBox(height: 100),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Row(
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 13.0,
                                    horizontal: 10.0,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color.fromARGB(255, 41, 236, 158),
                                        Color.fromARGB(255, 42, 254, 169),
                                        Color.fromARGB(255, 29, 213, 140),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Log Out",
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        fontSize: 16.0,
                                        fontFamily: 'Gilroy',
                                        fontWeight: FontWeight.bold,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 13.0,
                                    horizontal: 10.0,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color.fromARGB(255, 251, 102, 34),
                                        Color.fromARGB(255, 246, 114, 74),
                                        Color.fromARGB(255, 228, 94, 31),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Delete Account",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontFamily: 'Gilroy',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
