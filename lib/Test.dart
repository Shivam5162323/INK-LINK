import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xy/main.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text(userid),),
          Center(child: Text(email),),
          Center(child: Text(profilephoto),),
          Center(child: Text(name),)
        ],
      ),
    );
  }
}
