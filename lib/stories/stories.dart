import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Stories extends StatefulWidget {
  const Stories({Key? key}) : super(key: key);

  @override
  State<Stories> createState() => _StoriesState();
}

class _StoriesState extends State<Stories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1e2324),

      body: Container(

      ),

      floatingActionButton: FloatingActionButton(onPressed: (){},child: Icon(CupertinoIcons.camera,size: 25,color: Colors.white,weight: 100,),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(17))),
        backgroundColor: Color(0xFFF223847),
      ),
    );
  }
}
