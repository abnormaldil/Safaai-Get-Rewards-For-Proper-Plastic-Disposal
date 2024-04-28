import 'package:flutter/material.dart';

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
                          Text(
                            'Token Balance',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
                              decoration: InputDecoration(
                                labelText: 'Enter Unique Code',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
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
                                    fontSize: 20, fontWeight: FontWeight.w700),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Color(0xff4c505b),
                                child: IconButton(
                                    color: Colors.white,
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
