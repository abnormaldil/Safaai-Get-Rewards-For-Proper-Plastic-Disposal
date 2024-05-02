import 'package:flutter/material.dart';
import 'package:safaai/transaction.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String tokenBalance = "0"; // Example token balance
  TextEditingController codeController = TextEditingController();
  Set<String> validCodes = {"SAF123", "SAF345", "SAF567", "SAF789"};

  void _incrementBalance(String code) {
    // Here you can implement your logic to validate the code
    // and increment the token balance accordingly.
    // For this example, let's just increment the balance by 10 for any valid code.
    if (validCodes.contains(code)) {
      setState(() {
        tokenBalance = (int.parse(tokenBalance) + 10).toString();
        // Add transaction
      });
    } else {
      // Show an error message for invalid code
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Invalid Code'),
            content: Text('The entered code is invalid. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/home.png'), fit: BoxFit.cover),
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
                child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(110),
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          Text(
                            '$tokenBalance',
                            style: TextStyle(
                              fontSize: 90.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextField(
                              controller: codeController,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255)),
                              decoration: InputDecoration(
                                labelText: 'Enter Unique Code',
                                labelStyle: TextStyle(
                                    fontSize: 20.0, color: Color(0xFFFFFFFF)),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xFFffbe00), width: 5.0),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Claim\t',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Color(0xFFffbe00),
                                child: IconButton(
                                    color:
                                        const Color.fromARGB(255, 29, 28, 28),
                                    onPressed: () {
                                      _incrementBalance(codeController.text);
                                      codeController.clear();
                                      // Navigator.pushNamed(
                                      //     context, '/bottomnav');
                                    },
                                    icon: Icon(
                                      Icons.chevron_right_rounded,
                                    )),
                              )
                            ],
                          ),
                          // SizedBox(
                          //   height: 40,
                          // ),
                        ],
                      ),
                    )
                  ]),
            ))));
  }
}
