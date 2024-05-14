import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;
  String CreditBalance = '0';
  TextEditingController codeController = TextEditingController();
  Set<String> validCodes = {
    "SA23A2",
    "GKA235",
    "IKDFJ45",
    "OER345",
    "IOW523",
    "SOEJ4A",
    "OGJR04",
    "UBXL245",
    "KIG3454",
    "VN45033"
  };
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _incrementBalance(String code) async {
    final user = FirebaseAuth.instance.currentUser;
    if (validCodes.contains(code)) {
      try {
        if (user != null) {
          final userDocRef = _firestore.collection('users').doc(user.uid);

          await _firestore.runTransaction((transaction) async {
            final docSnapshot = await transaction.get(userDocRef);
            final int currentCreditBalance =
                docSnapshot.get('CreditBalance') ?? 0;
            final int newCreditBalance = currentCreditBalance + 10;

            transaction.update(userDocRef, {'CreditBalance': newCreditBalance});
          });

          setState(() {
            CreditBalance = (int.parse(CreditBalance) + 10).toString();
          });

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Success'),
                backgroundColor: Color(0xFFffbe00),
                content: Text('Your token balance has been increased by 10.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } catch (error) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Color(0xFFffbe00),
              title: Text('Error'),
              content: Text('An error occurred: $error'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Color(0xFFffbe00),
            title: Text('Invalid Code'),
            content: Text('The entered code is invalid. Please try again.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _getBalance() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docRef = _firestore.collection('users').doc(user.uid);
      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        final creditBalance = docSnapshot.get('CreditBalance') ?? 0;
        setState(() {
          CreditBalance = creditBalance.toString();
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getBalance();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/home.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            'Safaai',
            style: TextStyle(
              fontSize: 25,
              color: Color.fromARGB(255, 255, 255, 255),
              fontFamily: 'AvantGardeLT',
            ),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(100),
                  child: Column(
                    children: [
                      // Text(
                      //   'BALANCE',
                      //   style: TextStyle(
                      //     fontSize: 35.0,
                      //     fontWeight: FontWeight.bold,
                      //     fontFamily: 'BebasNeue',
                      //   ),
                      // ),

                      Text(
                        '$CreditBalance',
                        style: TextStyle(
                          fontSize: 90.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          controller: codeController,
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                          decoration: InputDecoration(
                            labelText: 'Enter Unique Code',
                            labelStyle: TextStyle(
                              fontSize: 20.0,
                              color: Color(0xFFFFFFFF),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFffbe00),
                                width: 5.0,
                              ),
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Claim\t',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'BebasNeue',
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Color(0xFFffbe00),
                            child: IconButton(
                              color: const Color.fromARGB(255, 29, 28, 28),
                              onPressed: () =>
                                  _incrementBalance(codeController.text),
                              icon: Icon(Icons.chevron_right_rounded),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
