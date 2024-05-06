import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:safaai/forgotpass.dart';
import 'package:safaai/home.dart';
import 'package:safaai/login.dart';
import 'package:safaai/mainpage.dart';
import 'package:safaai/profile.dart';
import 'package:safaai/redeem.dart';
import 'package:safaai/register.dart';
import 'package:safaai/transaction.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MainPage(),
    routes: {
      '/register': (context) => RegisterPage(),
      '/login': (context) => LoginPage(),
      '/home': (context) => HomePage(),
      '/forgotpass': (context) => ForgotPasswordPage(),
      '/transaction': (context) => TransactionPage(),
      '/profile': (context) => ProfilePage(),
      '/redeem': (context) => RedeemPage(),
      '/mainpage':(context) => MainPage(),
    },
  ));
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false);
  }
}
