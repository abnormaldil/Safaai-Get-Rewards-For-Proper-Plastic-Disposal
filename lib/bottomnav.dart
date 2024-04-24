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
  late TransactionHistoryScreen transactionHistoryScreen;

  @override
  void initState() {
    homePage = HomePage();
    redeemPage = RedeemPage();
    transactionHistoryScreen = TransactionHistoryScreen();
    profilePage = ProfilePage();
    pages = [homePage, redeemPage, transactionHistoryScreen, profilePage];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
          height: 75,
          backgroundColor: Colors.white,
          color: const Color.fromARGB(255, 0, 0, 0),
          animationDuration: Duration(milliseconds: 500),
          onTap: (int index) {
            setState(() {
              currentTabIndex = index;
            });
          },
          items: [
            Icon(
              Icons.home_outlined,
              color: Colors.white,
            ),
            Icon(
              Icons.wallet_outlined,
              color: Colors.white,
            ),
            Icon(
              Icons.history_outlined,
              color: Colors.white,
            ),
            Icon(
              Icons.person_outline,
              color: Colors.white,
            )
          ]),
      body: pages[currentTabIndex],
    );
  }
}
