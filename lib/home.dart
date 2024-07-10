import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:audioplayers/audioplayers.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;
  AudioPlayer _player = AudioPlayer();

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
          final userDocRef = _firestore
              .collection('users')
              .doc(user.email); // Changed uid to email
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
          var assetSource = AssetSource('claimed.mp3');
          await _player.play(assetSource);
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Success'),
                backgroundColor: Color(0xFFffbe00),
                content: Text('Your SaFi balance has been increased by 10.'),
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
      var assetSource = AssetSource('error.mp3');
      await _player.play(assetSource);
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
      final email = user.email;
      if (email != null) {
        final docRef = _firestore.collection('users').doc(email.trim());
        final docSnapshot = await docRef.get();
        if (docSnapshot.exists) {
          final creditBalance = docSnapshot.get('CreditBalance') ?? 0;
          setState(() {
            CreditBalance = creditBalance.toString();
          });
        }
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
    Widget _buildCurvedImage(String imagePath) {
      return ClipRRect(
        borderRadius:
            BorderRadius.circular(15.0), // Adjust border radius as needed
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFFffbe00),
      appBar: AppBar(
        backgroundColor: Color(0xFFffbe00),
        automaticallyImplyLeading: false,
        title: Text(
          'SaFaai',
          style: TextStyle(
            fontSize: 35,
            color: Color.fromARGB(255, 255, 255, 255),
            fontFamily: 'AvantGardeLT',
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: CarouselSlider(
              items: [
                _buildCurvedImage('assets/b1.jpg'),
                _buildCurvedImage('assets/b2.jpg'),
                _buildCurvedImage('assets/b3.jpg'),
              ],
              options: CarouselOptions(
                height: 150.0,
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.easeInBack,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                viewportFraction: 0.8,
                scrollPhysics: ScrollPhysics(),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 1.4,
                  child: DraggableScrollableSheet(
                    builder: (BuildContext context,
                        ScrollController scrollController) {
                      return Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1e1f21),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60),
                            topRight: Radius.circular(60),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Icon(
                                Icons.keyboard_double_arrow_up_rounded,
                                size: 45.0,
                                color: Colors.white,
                              ),
                              SizedBox(height: 20),
                              Container(
                                alignment: Alignment.center,
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromARGB(255, 255, 162, 0)
                                          .withOpacity(0.5),
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
                                        size: 45.0,
                                        color: Color(0xFFffbe00),
                                      ),
                                      Text(
                                        '$CreditBalance',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 60.0,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                controller: codeController,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Enter Unique Code',
                                  labelStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              GestureDetector(
                                onTap: () {
                                  _incrementBalance(codeController.text.trim());
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 13.0,
                                    horizontal: 13.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFffbe00),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Claim",
                                      style: TextStyle(
                                        color: Color(0xFF1e1f21),
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
