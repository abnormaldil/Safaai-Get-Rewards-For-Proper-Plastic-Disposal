import 'package:flutter/material.dart';

class Transaction {
  final String code;
  final int amount;
  final DateTime timestamp;

  Transaction(this.code, this.amount, this.timestamp);
}

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionList({Key? key, required this.transactions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return ListTile(
          title: Text(transaction.code),
          subtitle: Text(
              'Claimed ${transaction.amount} tokens on ${transaction.timestamp.toIso8601String()}'),
        );
      },
    );
  }
}

class TransactionPage extends StatefulWidget {
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  List<Transaction> _transactions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/transaction.png'),
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
                  // Display transaction list here
                  TransactionList(transactions: _transactions),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
