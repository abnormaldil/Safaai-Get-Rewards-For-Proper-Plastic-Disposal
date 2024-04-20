import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safaai/home.dart';
import 'package:safaai/login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String name = "", email = "", phone = "", password = "", upi = "";
  TextEditingController namecontroller = new TextEditingController();
  TextEditingController emailcontroller = new TextEditingController();
  TextEditingController phonecontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();
  TextEditingController upicontroller = new TextEditingController();
  final _formkey = GlobalKey<FormState>();

  registration() async {
    if (password != null &&
        namecontroller.text != "" &&
        emailcontroller.text != "" &&
        phonecontroller.text != "" &&
        upicontroller.text != "") {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          "Yeeyy, Let's Go!",
          style: TextStyle(fontSize: 20.0),
        )));
        // ignore: use_build_context_synchronously
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-email') {
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
        } else if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Color.fromARGB(255, 36, 36, 36),
              content: Text(
                "Your password needs more strength",
                style: TextStyle(
                  decoration: TextDecoration.none,
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 18,
                ),
              )));
        } else if (e.code == "email-already-in-use") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Color.fromARGB(255, 36, 36, 36),
              content: Text(
                "We already know you! Please log in.",
                style: TextStyle(
                  decoration: TextDecoration.none,
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 18,
                ),
              )));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/register.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left: 35, top: 30),
              child: Text(
                'Create\nAccount',
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Form(
                key: _formkey,
                child: Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.23),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 35, right: 35),
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Your sweet name?';
                                }
                                return null;
                              },
                              controller: namecontroller,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  hintText: "Name",
                                  hintStyle: TextStyle(color: Colors.white),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                            SizedBox(
                              height: 13,
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
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  hintText: "Email",
                                  hintStyle: TextStyle(color: Colors.white),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                            SizedBox(
                              height: 13,
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter Phone Number';
                                }
                                return null;
                              },
                              controller: phonecontroller,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  hintText: "Phone Number",
                                  hintStyle: TextStyle(color: Colors.white),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                            SizedBox(
                              height: 13,
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter Password';
                                }
                                return null;
                              },
                              controller: passwordcontroller,
                              style: TextStyle(color: Colors.white),
                              obscureText: true,
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  hintText: "Password",
                                  hintStyle: TextStyle(color: Colors.white),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                            SizedBox(
                              height: 13,
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter UpiId';
                                }
                                return null;
                              },
                              controller: upicontroller,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  hintText: "Upi Id",
                                  hintStyle: TextStyle(color: Colors.white),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                            SizedBox(
                              height: 23,
                            ),
                            GestureDetector(
                              onTap: () {
                                if (_formkey.currentState!.validate()) {
                                  setState(() {
                                    email = emailcontroller.text;
                                    name = namecontroller.text;
                                    password = passwordcontroller.text;
                                    phone = phonecontroller.text;
                                    upi = upicontroller.text;
                                  });
                                }
                                registration();
                              },
                              child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 13.0, horizontal: 13.0),
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 48, 49, 49),
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Center(
                                      child: Text(
                                    "Sign Up",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.w500),
                                  ))),
                            ),
                            SizedBox(
                              height: 13,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(
                                        context); // Go back to login page
                                  },
                                  child: Text(
                                    'Sign In',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Colors.white,
                                        fontSize: 18),
                                  ),
                                  style: ButtonStyle(),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  goToLogin(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );

  goToHome(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
}
