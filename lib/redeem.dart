// Example snippet for redeem.dart
import 'package:flutter/material.dart';

class RedeemPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/redeem.png'), fit: BoxFit.cover),
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
                      child: Column(),
                    ),
                    // SizedBox(height: 10),
                    // Container(
                    //   padding: EdgeInsets.all(10),
                    //   child: Column(
                    //     children: [
                    //       Padding(
                    //         padding: const EdgeInsets.symmetric(horizontal: 20),
                    //         child: TextField(
                    //           style: TextStyle(
                    //               color: Color.fromARGB(255, 255, 255, 255)),
                    //           decoration: InputDecoration(
                    //             labelText: 'Enter Unique Code',
                    //             labelStyle: TextStyle(
                    //                 fontSize: 20.0, color: Color(0xFFFFFFFF)),
                    //             border: OutlineInputBorder(
                    //               borderSide: BorderSide(
                    //                   color: Color(0xFFffbe00), width: 5.0),
                    //               borderRadius: BorderRadius.circular(50),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //       SizedBox(
                    //         height: 30,
                    //       ),
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.end,
                    //         children: [
                    //           Text(
                    //             'Claim\t',
                    //             style: TextStyle(
                    //                 fontSize: 20,
                    //                 fontWeight: FontWeight.w700,
                    //                 color: Color.fromARGB(255, 255, 255, 255)),
                    //           ),
                    //           CircleAvatar(
                    //             radius: 30,
                    //             backgroundColor: Color(0xFFffbe00),
                    //             child: IconButton(
                    //                 color:
                    //                     const Color.fromARGB(255, 29, 28, 28),
                    //                 onPressed: () {
                    //                   // Navigator.pushNamed(
                    //                   //     context, '/bottomnav');
                    //                 },
                    //                 icon: Icon(
                    //                   Icons.chevron_right_rounded,
                    //                 )),
                    //           )
                    //         ],
                    //       ),
                    //       // SizedBox(
                    //       //   height: 40,
                    //       // ),
                    //     ],
                    //   ),
                    // )
                  ]),
            ))));
  }
}
