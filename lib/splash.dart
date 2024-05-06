import 'package:flutter/material.dart';
import 'package:safaai/mainpage.dart';


class SplashScreen extends StatefulWidget {

  _SplashState createState() => _SplashState();
}

  class _SplashState extends State<SplashScreen>{
  @override
  void initState(){
  super.initState();
  _navigatetoHome();
  }

  _navigatetoHome()async{
    await Future.delayed(Duration(milliseconds: 3000), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> MainPage()));
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFffbe00),
        //Color(0xFF3EB16F),
        child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Container(

        child: Image.asset('assets/foreground.png', width:300,height:300),
        ),
          // Container(
          //   // child: Padding(
          //   //   padding: EdgeInsets.only(top: 1),
          //   // child: Text('Earth will be better.',
          //   //     textAlign: TextAlign.center,
          //   //     overflow: TextOverflow.ellipsis,
          //   //     style: TextStyle(
          //   //     fontFamily: "Poppins",
          //   //     fontSize: 25,
          //   //     color: Colors.white,
          //   //   ),)
          //   // )
          // ),
      ],
        ),
      ),
      ),
    );
}


}