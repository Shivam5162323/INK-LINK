
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xy/Signinup/signin.dart';

import 'auth.dart';
import 'otp.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthService _auth = AuthService();

  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final ConfirmPass = TextEditingController();
  final phoneno = TextEditingController();


  late String documentId;
  Future<void> addUsertoDatabase() async {



    // String documentId = generateDocumentId(email);
    DocumentReference users = FirebaseFirestore.instance.collection('users').doc();
    documentId = users.id;
    // userid = documentId;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {

      prefs.setString('userid', documentId);
    });


    // print(_drivelink);
    // Call the user's CollectionReference to add a new user
    return users
        .set({
      'phone': phoneno.text,
      'name': name.text ,
      'email':email.text,
      'pass': password.text,
      'time': DateTime.now(),
      'id': documentId

    })
        .then((value) => print("user Added"))
        .catchError((error) => print("Failed to add user: $error"));

  }





  Widget buildResultText(String nme) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').where('name', isEqualTo: nme).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          // return CircularProgressIndicator();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return name.text==''?SizedBox():Row(
            children: [
              Icon(Icons.check_circle_rounded,color: Colors.greenAccent,),
              Text('  Username available',style: TextStyle(color: Colors.greenAccent)),
            ],
          );
        }

        return Row(
          children: [
            Icon(CupertinoIcons.clear_circled_solid,color: Colors.red,),

            Text('  Username already exists! Use another one.',style: TextStyle(color: Colors.red),),
          ],
        );
      },
    );
  }









  Widget Checkifmailexist(String nme) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').where('email', isEqualTo: nme).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          // return CircularProgressIndicator();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return name.text==''?SizedBox():Row(
            children: [
              Icon(Icons.check_circle_rounded,color: Colors.greenAccent,),
              Text('Good to go!',style: TextStyle(color: Colors.greenAccent)),
            ],
          );
        }

        return Row(
          children: [
            Icon(CupertinoIcons.clear_circled_solid,color: Colors.red,),

            Text('Try Using another email!!',style: TextStyle(color: Colors.red),),
          ],
        );
      },
    );
  }






  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Color(0xFFFe0d7d1),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomRight,
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.only(topLeft: Radius.elliptical(350, 180))),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomRight,
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                  color: Color(0xFFF161f1d),
                  borderRadius:
                  BorderRadius.only(topLeft: Radius.circular(800))),
            ),
          ),


          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.15,
                      left: MediaQuery.of(context).size.width * 0.1,
                      right: MediaQuery.of(context).size.width * 0.1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sign up',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 50,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'We are happy to see you here!',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.always,

                  child: Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.07,
                        right: MediaQuery.of(context).size.width * 0.07,
                        top: MediaQuery.of(context).size.height * 0.01),
                    child: Column(
                      children: [
                        buildResultText(name.text),

                        TextFormField(
                          controller: name,
                          onChanged: (_){

                          },
                          decoration: InputDecoration(
                            labelText: 'Username',
                            icon: Icon(
                              Icons.person_outline,
                              color: Colors.black87,
                            ),
                            labelStyle:
                            TextStyle(color: Colors.black87, fontSize: 18),
                            errorStyle: TextStyle(
                              color: Colors.black,),

                            hintText: 'name',
                            hintStyle: TextStyle(color: Colors.black26),

                          ),
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                              overflow: TextOverflow.visible),
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Username can\'t be null';
                            }
                            return null;
                          },
                        ),

                        // Checkifmailexist(email.text),


                        TextFormField(
                          controller: email,

                          decoration: InputDecoration(
                            labelText: 'Email address',
                            icon: Icon(
                              Icons.mail_outline_rounded,
                              color: Colors.black87,
                            ),
                            labelStyle:
                            TextStyle(color: Colors.black87, fontSize: 18),
                            errorStyle: TextStyle(
                              color: Colors.black, // Change this color as desired
                            ),

                            hintText: 'abc@gmail.com',
                            hintStyle: TextStyle(color: Colors.black26),

                          ),
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                              overflow: TextOverflow.visible),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {


                            if (value == null || !value.contains('@') || !value.endsWith('gmail.com')) {
                              return 'Enter a valid Gmail address';
                            }
                            return null;
                          },
                        ),




                        TextFormField(
                          controller: password,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            icon: Icon(
                              Icons.security_outlined,
                              color: Colors.black87,
                            ),

                            labelStyle:
                            TextStyle(color: Colors.black87, fontSize: 18),
                            errorStyle: TextStyle(
                              color: Colors.black, // Change this color as desired
                            ),
                            hintText: '8 character password',
                            hintStyle: TextStyle(color: Colors.black26),
                          ),

                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                              overflow: TextOverflow.visible),
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,

                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'This field is required';
                            }
                            if (value.trim().length < 8) {
                              return 'Password must be at least 8 characters in length';
                            }
                            // Return null if the entered password is valid
                            return null;
                          },
                        ),


                        SizedBox(height: 8),
                        Center(
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.08),
                            child: ElevatedButton(
                              onPressed: () async {

                                if (_formKey.currentState!.validate()){


                                  dynamic result = await _auth.signInEmailPassword(LoginUser(email: email.text,password: password.text));
                                  if(result.code == 'user-not-found'){



                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>OTPScreen(email.text,password.text,name.text)));



                                  }
                                  else {
                                    print(result.code);


                                    final snackBar = SnackBar(
                                      content: Text('User Already Exists!!'),);


                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);




                                  }

                                }





                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.black,
                                  shape: StadiumBorder(side: BorderSide(width: 0.1)),
                                  minimumSize: Size(
                                      MediaQuery.of(context).size.width * 0.95,
                                      MediaQuery.of(context).size.height * 0.063)),
                              child: Text('Sign up me'),


                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.025),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                      CupertinoPageRoute(builder: (context) => Signin()));
                                },
                                child: Text(
                                  'Already have an account?',
                                  style: TextStyle(color: Colors.white,fontSize: 16),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    // Handle "Need help?" action
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        top: MediaQuery.of(context).size.height * 0.03),
                                    child: Text(
                                      'Need help?',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          decoration: TextDecoration.underline),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}






