import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:safaai/bottomnav.dart';
import 'package:safaai/forgotpass.dart';
import 'package:safaai/home.dart';
import 'package:safaai/login.dart';
import 'package:safaai/mainpage.dart';
import 'package:safaai/profile.dart';
import 'package:safaai/redeem.dart';
import 'package:safaai/register.dart';
import 'package:safaai/splash.dart';
import 'package:safaai/transaction.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
  } catch (e) {
    print('Firebase initialization error: $e');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        '/register': (context) => RegisterPage(),
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/forgotpass': (context) => ForgotPasswordPage(),
        '/transaction': (context) => TransactionPage(),
        '/profile': (context) => ProfilePage(),
        '/redeem': (context) => RedeemPage(),
        '/mainpage': (context) => MainPage(),
        '/bottomnav': (context) => BottomNav(),
      },
    );
  }
}
