import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Calls extends StatefulWidget {
  const Calls({Key? key}) : super(key: key);

  @override
  State<Calls> createState() => _CallsState();
}

class _CallsState extends State<Calls> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1e2324),

      body: Container(


      ),
      floatingActionButton: FloatingActionButton(onPressed: (){},child: Icon(Icons.add_ic_call_outlined,size: 25,color: Colors.white,weight: 100,),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(17))),
        backgroundColor: Color(0xFFF223847),
      ),
    );
  }
}
