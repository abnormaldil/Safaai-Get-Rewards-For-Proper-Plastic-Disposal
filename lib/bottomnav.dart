import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:safaai/home.dart';
import 'package:safaai/profile.dart';
import 'package:safaai/redeem.dart';
import 'package:safaai/transaction.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentTabIndex = 0;

  late List<Widget> pages;
  late Widget currentPage;
  late HomePage homePage;
  late ProfilePage profilePage;
  late RedeemPage redeemPage;
  late TransactionPage transactionHistoryScreen;

  @override
  void initState() {
    homePage = HomePage();
    redeemPage = RedeemPage();
    transactionHistoryScreen = TransactionPage();
    profilePage = ProfilePage();
    pages = [homePage, redeemPage, transactionHistoryScreen, profilePage];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
          height: 75,
          backgroundColor: Color(0xFF1e1f21),
          color: Color(0xFFffbe00),
          animationDuration: Duration(milliseconds: 500),
          onTap: (int index) {
            setState(() {
              currentTabIndex = index;
            });
          },
          items: [
            Icon(
              Icons.home_outlined,
              color: const Color.fromARGB(255, 23, 23, 23),
            ),
            Icon(
              Icons.wallet_outlined,
              color: const Color.fromARGB(255, 23, 23, 23),
            ),
            Icon(
              Icons.history_outlined,
              color: const Color.fromARGB(255, 23, 23, 23),
            ),
            Icon(
              Icons.person_outline,
              color: const Color.fromARGB(255, 23, 23, 23),
            )
          ]),
      body: pages[currentTabIndex],
    );
  }
}
