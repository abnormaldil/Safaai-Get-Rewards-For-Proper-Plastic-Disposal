import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TransactionPage extends StatefulWidget {
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  Stream<QuerySnapshot>? transactionsStream;

  @override
  void initState() {
    super.initState();
    transactionsStream = FirebaseFirestore.instance
        .collection('transactions')
        .doc(user!.uid)
        .collection(user!.uid) // Assuming subcollection with user's uid
        .orderBy('Time', descending: true) // Order by Time (descending)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/transaction.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar:AppBar(
  centerTitle: true, 
  backgroundColor: Colors.transparent, 
  title: Text(
    'Transactions',
    style: TextStyle(
      fontSize: 60,
      color: Color.fromARGB(255, 255, 255, 255), 
      fontFamily: 'BebasNeue',
    ),
  ),
),

        body: StreamBuilder<QuerySnapshot>(
          
          stream: transactionsStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
      
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
      
            List<DocumentSnapshot> transactions = snapshot.data!.docs;
      
            return ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                DocumentSnapshot transaction = transactions[index];
      
                return _buildTransactionTile(context, transaction);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildTransactionTile(BuildContext context, DocumentSnapshot transaction) {
    Timestamp transactionTime = transaction['Time'];
    int redeemedAmount = transaction['RedeemAmount'];
  

    return ListTile(
      
      title: Text('$redeemedAmount''\tCoins' ,style: TextStyle(
      fontSize: 40,
      color: Color.fromARGB(255, 255, 255, 255), 
      fontFamily: 'BebasNeue',
    ),),
      subtitle: Text(
        'Date: ${transactionTime.toDate().toString()}', style: TextStyle(
      fontSize: 20,
      color: Color.fromARGB(255, 255, 255, 255), 
      fontFamily: 'BebasNeue',
    ),
      ),
      trailing: Row(
      mainAxisSize: MainAxisSize.min, // Restrict trailing widget size
      children: [
        Icon(Icons.check_circle, color: Color.fromARGB(255, 9, 220, 16),size: 30), // UPI ID icon
       
       
      ],
    ),// Display UPI ID and Email
    );
  }
}
