import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:safaai/bottomnav.dart';
import 'package:safaai/profile.dart';

class RedeemPage extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;
  AudioPlayer _player = AudioPlayer();

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
          String cname = userData['Name'];
          int creditBalance = userData['CreditBalance'];

          return _buildRedeemUI(context, creditBalance, cname, userData);
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

  Widget _buildRedeemUI(BuildContext context, int creditBalance, String cname,
      Map<String, dynamic> userData) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
      ),
      child: Scaffold(
        backgroundColor: Color.fromARGB(0, 30, 31, 33),
        appBar: AppBar(
          centerTitle: false,
          toolbarHeight: 100,
          backgroundColor: Color.fromARGB(0, 30, 31, 33),
          title: Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize
                  .min, // Ensures the column only takes the space it needs
              children: [
                Text(
                  "Hello,",
                  style: TextStyle(
                    fontSize: 26,
                    color: const Color.fromARGB(255, 80, 79, 79),
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Text(
                  cname + "!",
                  style: TextStyle(
                    fontSize: 36,
                    color: const Color.fromARGB(255, 80, 79, 79),
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(
                  right: 10.0), // Add padding to the right
              child: IconButton(
                icon: Icon(
                  Icons.person_2_rounded,
                  color: const Color.fromARGB(255, 80, 79, 79),
                  size: 60,
                ),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => ProfilePage()));
                },
              ),
            ),
          ],
        ),
        body: Container(
          alignment: Alignment.center,
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.005),
              Container(
                alignment: Alignment.center,
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 25, 255, 182).withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 25,
                      offset: Offset(0, 3),
                    ),
                  ],
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 29, 213, 140),
                      Color.fromARGB(255, 42, 254, 169),
                      Color.fromARGB(255, 29, 213, 140),
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
                        color: Color.fromARGB(255, 255, 255, 255),
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
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // First Box
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.13,
                    margin: EdgeInsets.symmetric(
                        horizontal: 15), // Space between boxes
                    padding: EdgeInsets.all(20), // Inner spacing
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius:
                          BorderRadius.circular(40), // Rounded corners
                      border: Border.all(
                          color: Color.fromARGB(255, 171, 171, 171),
                          width: 1), // Black border
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star, // Replace with your preferred icon
                          size: 40,
                          color: Color.fromARGB(255, 29, 213, 140),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Items Recycled',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Gilroy',
                            color: const Color.fromARGB(255, 80, 79, 79),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.13,
                    margin: EdgeInsets.symmetric(
                        horizontal: 15), // Space between boxes
                    padding: EdgeInsets.all(20), // Inner spacing
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius:
                          BorderRadius.circular(40), // Rounded corners
                      border: Border.all(
                          color: Color.fromARGB(255, 171, 171, 171),
                          width: 1), // Black border
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.favorite, // Replace with your preferred icon
                          size: 40,
                          color: Color.fromARGB(255, 29, 213, 140),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Total Earnings',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Gilroy',
                            color: const Color.fromARGB(255, 80, 79, 79),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Container(
                height: 210,
                margin: EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(50), // Rounded corners
                  border: Border.all(
                      color: Color.fromARGB(255, 171, 171, 171),
                      width: 1), // Black border
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Left Column
                    Expanded(
                      flex: 3, // Adjust the space for left column
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Earn Points For Discarded Trash',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Gilroy',
                              color: const Color.fromARGB(255, 80, 79, 79),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'With you we help ecology.',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Gilroy',
                              color: const Color.fromARGB(255, 113, 112, 112),
                            ),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BottomNav()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(255, 42, 241, 162),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              'Get Started',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Gilroy',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10), // Space between columns
                    // Right Column
                    Expanded(
                      flex: 2, // Adjust the space for right column
                      child: Image.asset(
                        'assets/forgot.png',
                        fit: BoxFit.contain,
                        height: 150, // Adjust to a suitable size
                        width: 150, // Optional width
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () => _redeemCredits(context, creditBalance, userData),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding: EdgeInsets.symmetric(
                      vertical: 15), // Adjust padding for height
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 37, 232, 154),
                        Color.fromARGB(255, 42, 254, 169),
                        Color.fromARGB(255, 29, 213, 140),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Color.fromARGB(255, 42, 254, 169).withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 5,
                        offset: Offset(0, 3), // Shadow positioning
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Redeem',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Gilroy',
                        color: const Color.fromARGB(
                            255, 255, 255, 255), // Black text
                      ),
                    ),
                  ),
                ),
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

  Future<void> _redeemCredits(BuildContext context, int creditBalance,
      Map<String, dynamic> userData) async {
    int n = creditBalance % 100;
    int newn = creditBalance - n;
    if (creditBalance >= 100) {
      int redeemedCredit = newn;
      int newCreditBalance = n;

      FirebaseFirestore.instance
          .collection('users')
          .doc(user!.email)
          .update({'CreditBalance': newCreditBalance});

      userData['CreditBalance'] = newCreditBalance;

      Timestamp transactionTime = Timestamp.now();

      String upiId = userData['UpiId'];
      String email = userData['Email'];

      FirebaseFirestore.instance
          .collection('transactions')
          .doc(user!.email)
          .collection(user!.email!)
          .add({
        'RedeemAmount': redeemedCredit,
        'Time': transactionTime,
        'Date': transactionTime.toDate(),
        'UpiId': upiId,
        'Email': email,
      }).then((_) async {
        var assetSource = AssetSource('claimed.mp3');
        await _player.play(assetSource);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Success'),
              backgroundColor: Color.fromARGB(255, 42, 254, 169),
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
        print("Error saving transaction: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred. Please try again.'),
          ),
        );
      });
    } else {
      var assetSource = AssetSource('error.mp3');
      await _player.play(assetSource);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Color.fromARGB(255, 42, 254, 169),
            title: Text(
              'Invalid Redemption!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontFamily: 'Gilroy',
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            content: Padding(
              padding: const EdgeInsets.only(
                  top: 10.0, bottom: 10.0, left: 0.0, right: 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '•Minimum 100 Tokens Required for Redemption',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Gilroy',
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  Text(
                    '•Redeem in Multiples of 100',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Gilroy',
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Gilroy',
                    color: const Color.fromARGB(255, 80, 79, 79),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }
}
