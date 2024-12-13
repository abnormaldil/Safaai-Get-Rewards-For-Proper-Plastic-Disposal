import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  String email = "";
  TextEditingController emailcontroller = new TextEditingController();
  final _formkey = GlobalKey<FormState>();

  resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        "Check your email inbox",
        style: TextStyle(fontSize: 20.0),
      )));
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Color.fromARGB(255, 36, 36, 36),
            content: Text(
              "We don't know you!",
              style: TextStyle(
                decoration: TextDecoration.none,
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 18,
              ),
            )));
      } else if (e.code == 'invalid-email') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Color.fromARGB(255, 36, 36, 36),
            content: Text(
              " That email might be missing a few pieces",
              style: TextStyle(
                decoration: TextDecoration.none,
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 18,
              ),
            )));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/forgot.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formkey,
                  child: Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(left: 35, right: 35),
                            child: Column(
                              children: [
                                Center(
                                  child: const Text(
                                    'Forgot your password?',
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontFamily: 'AvantGardeLT',
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Image.asset(
                                  'assets/forgotpass.png',
                                  width: 140,
                                  height: 140,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'Dont Worry!',
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                      decoration: TextDecoration.none,
                                      fontSize: 43,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Gilroy',
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 15, right: 15),
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Gilroy',
                                      ),
                                      children: [
                                        TextSpan(
                                          text:
                                              "We will send a Password Reset Link to\n",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        TextSpan(
                                          text: email,
                                          style: TextStyle(
                                              color: Color(
                                                  0xFFffbe00)), // Change color here
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Enter Email';
                                    }
                                    return null;
                                  },
                                  controller: emailcontroller,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        ),
                                      ),
                                      hintText: "Email",
                                      hintStyle: TextStyle(color: Colors.white),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      )),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (_formkey.currentState!.validate()) {
                                      setState(() {
                                        email = emailcontroller.text;
                                      });
                                      resetPassword();
                                    }
                                  },
                                  child: Container(
                                    width: 140,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Color(0xFF18cc84),
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: Center(
                                      child: Text(
                                        "Send Email",
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 31, 30, 30),
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 50.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/login');
                                      },
                                      child: Text(
                                        'Back To Login',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
