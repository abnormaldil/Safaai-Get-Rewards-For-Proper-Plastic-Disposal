import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    if (user != null && user!.email != null) {
      transactionsStream = FirebaseFirestore.instance
          .collection('transactions')
          .doc(user!.email)
          .collection(user!.email!)
          .orderBy('Time', descending: true)
          .snapshots();
    }
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
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text(
            'Transactions',
            style: TextStyle(
              fontSize: 50,
              color: Color.fromARGB(255, 255, 255, 255),
              fontFamily: 'Gilroy',
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

  Widget _buildTransactionTile(
      BuildContext context, DocumentSnapshot transaction) {
    Timestamp transactionTime = transaction['Time'];
    int redeemedAmount = transaction['RedeemAmount'];

    return ListTile(
      title: Text(
        '$redeemedAmount SaFi',
        style: TextStyle(
          fontSize: 34,
          color: Color(0xFFffbe00),
          fontFamily: 'Gilroy',
        ),
      ),
      subtitle: Text(
        'Date: ${transactionTime.toDate().toString()}',
        style: TextStyle(
          fontSize: 15,
          color: Color.fromARGB(255, 255, 255, 255),
          fontFamily: 'Gilroy',
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min, // Restrict trailing widget size
        children: [
          Icon(
            FontAwesomeIcons.check,
            size: 35.0, // Adjust the size as needed
            color: Color.fromARGB(255, 28, 253, 39),
          ),
        ],
      ),
    );
  }
}
