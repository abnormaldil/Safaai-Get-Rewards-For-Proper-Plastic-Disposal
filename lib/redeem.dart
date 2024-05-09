import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RedeemPage extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: user != null
          ? FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .snapshots()
          : null,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        Map<String, dynamic>? userData = snapshot.data?.data() as Map<String, dynamic>?;
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

  Widget _buildRedeemUI(BuildContext context, int creditBalance, Map<String, dynamic> userData) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/redeem.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        
       backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Credit Balance:',
                  style: TextStyle(fontSize: 20, color:Color.fromARGB(255, 255, 255, 255,),fontFamily: 'BebasNeue'),
                ),
                SizedBox(height: 10),
                Text(
                  creditBalance.toString(),
                  style: TextStyle(fontSize: 90, fontWeight: FontWeight.bold,color:Color.fromARGB(255, 255, 255, 255) ),
                ),
                SizedBox(height: 20),
              
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                            'Redeem\t',
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
                                  onPressed: () => _redeemCredits(context, creditBalance, userData),
                                  icon: Icon(Icons.chevron_right_rounded),
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
  }

 void _redeemCredits(BuildContext context, int creditBalance, Map<String, dynamic> userData) {
  if (creditBalance % 100 == 0 && creditBalance >= 100) {
    int redeemedCredit = creditBalance; 
    int newCreditBalance = creditBalance - redeemedCredit;

  
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .update({'CreditBalance': newCreditBalance});

 
    userData['CreditBalance'] = newCreditBalance;


    Timestamp transactionTime = Timestamp.now();

   
    String upiId = userData['UpiId'];
    String email = userData['Email'];

    FirebaseFirestore.instance
        .collection('transactions')
        .doc(user!.uid)
        .collection(user!.uid) 
        .add({
          'RedeemAmount': redeemedCredit,
          'Time': transactionTime,
          'Date': transactionTime.toDate(),
          'UpiId': upiId, 
          'Email': email, 
        })
        .then((_) {
         
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
        })
        .catchError((error) {
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
        content: Text('Insufficient balance or invalid amount for redemption.'),
      ),
    );
  }
}

}
