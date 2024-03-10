import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'login.dart';

class splashScreen extends StatefulWidget {
  final Widget? child;
  const splashScreen({super.key, this.child});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {

  @override
  void initState()
  {
   Future.delayed(
    const Duration(seconds: 1), (){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => widget.child!), (route) => false);
    }
   );
  }


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Text("Adnan's Application",
      style: TextStyle(
        color: Colors.black),
      ),
    ));
  }
}