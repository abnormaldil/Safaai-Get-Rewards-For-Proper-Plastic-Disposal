import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: user != null
          ? FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .snapshots()
          : null,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        Map<String, dynamic>? userData =
            snapshot.data?.data() as Map<String, dynamic>?;
        if (userData != null) {
          String name = userData['Name'];
          String email = userData['Email'];
          int phone = userData['PhoneNumber'];
          String upi = userData['UpiId'];

          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/profile.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // List of user details with icons
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        IconData? iconData;
                        String value;
                        switch (index) {
                          case 0:
                            iconData = Icons.person;
                            value = name;
                            break;
                          case 1:
                            iconData = Icons.email;
                            value = email;
                            break;
                          case 2:
                            iconData = Icons.phone;
                            value = phone.toString();
                            break;
                          case 3:
                            iconData =
                                Icons.money; // Adjust icon based on preference
                            value = upi;
                            break;
                          default:
                            iconData = null;
                            value = '';
                        }

                        return ListTile(
                          leading: iconData != null
                              ? Icon(
                                  iconData,
                                  color: const Color.fromARGB(
                                      255, 29, 28, 28), // Set color to black
                                  size:
                                      30.0, // Increase size to 30.0 (adjust as needed)
                                )
                              : null,
                          title: Text(
                            value,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontFamily: 'Gilroy-SemiBold',
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 40),

                    // Logout button
                    GestureDetector(
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        // Handle successful logout or navigate to login page
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        padding: EdgeInsets.symmetric(
                          vertical: 13.0,
                          horizontal: 10.0,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFffbe00),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            "Log Out",
                            style: TextStyle(
                             color: const Color.fromARGB(255, 29, 28, 28),
                              fontSize: 22.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          // Handle the case where user data is null (e.g., show an error message)
          print('Error: User data not found in Firestore');
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/profile.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Text('Error: User data not found in Firestore'),
              ),
            ),
          );
        }
      },
    );
  }
}
