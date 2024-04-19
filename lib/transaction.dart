import 'package:flutter/material.dart';

class TransactionHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction History'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display transaction history (earned and redeemed coins)
            Text('No Transactions found'),
          ],
        ),
      ),
    );
  }
}
