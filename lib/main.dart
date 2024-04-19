import 'package:flutter/material.dart';
import 'package:safaai/forgotpass.dart';
import 'package:safaai/home.dart';
import 'package:safaai/login.dart';
import 'package:safaai/profile.dart';
import 'package:safaai/redeem.dart';
import 'package:safaai/register.dart';
import 'package:safaai/transaction.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginPage(),
    routes: {
      '/register': (context) => RegisterPage(),
      '/login': (context) => LoginPage(),
      '/home': (context) => HomePage(),
      '/forgotpass': (context) => ForgotPasswordPage(),
      '/transaction': (context) => TransactionHistoryScreen(),
      '/profile': (context) => ProfilePage(),
      '/redeem': (context) => RedeemPage(),
    },
  ));
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false);
  }
}
