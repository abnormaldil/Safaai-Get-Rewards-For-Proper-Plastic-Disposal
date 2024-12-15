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
        color: const Color.fromARGB(255, 255, 255, 255),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text(
            'Transactions',
            style: TextStyle(
              fontSize: 36,
              color: const Color.fromARGB(255, 41, 41, 41),
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
    DateTime dateTime = transactionTime.toDate();
    String formattedDate = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
    String formattedTime =
        "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25, vertical: 7),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color.fromARGB(0, 34, 34, 34),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Date:$formattedDate",
                style: TextStyle(
                  fontSize: 14,
                  color: const Color.fromARGB(255, 41, 41, 41),
                  fontFamily: 'Gilroy',
                ),
              ),
              SizedBox(height: 5),
              Text(
                "Time:$formattedTime",
                style: TextStyle(
                  fontSize: 14,
                  color: const Color.fromARGB(255, 41, 41, 41),
                  fontFamily: 'Gilroy',
                ),
              ),
            ],
          ),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 38, 226, 166).withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: Offset(0, 2),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  FontAwesomeIcons.leaf,
                  color: Color.fromARGB(255, 255, 255, 255),
                  size: 20,
                ),
                SizedBox(height: 5),
                Text(
                  "$redeemedAmount",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Gilroy',
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
