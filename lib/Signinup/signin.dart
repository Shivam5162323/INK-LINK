import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xy/Signinup/signup.dart';
import 'package:xy/Test.dart';

import '../Home.dart';
import 'auth.dart';
import 'otp.dart';

class Signin extends StatefulWidget {
  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {

  final AuthService _auth = AuthService();
  final email = TextEditingController();
  final pass = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();



  Future<Map<String, dynamic>> getUserData(String userEmail) async {
    try {
      // Reference to the Firestore collection 'users'
      CollectionReference users = FirebaseFirestore.instance.collection('users');

      // Query the Firestore collection to get the user document based on email
      QuerySnapshot querySnapshot = await users.where('email', isEqualTo: userEmail).get();

      // Check if a user document with the provided email exists
      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document (there should be only one matching email)
        DocumentSnapshot userData = querySnapshot.docs.first;

        // Extract the data you need (name, id, profile photo path)
        Map<String, dynamic> userDataMap = userData.data() as Map<String, dynamic>;

        // Return the user data
        return userDataMap;
      } else {
        // Handle the case where the user document does not exist
        return {};
      }
    } catch (e) {
      // Handle any errors that may occur during the data fetching process
      print('Error fetching user data: $e');
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.white,
          ),
          Container(
            alignment: Alignment.topCenter,
            height: MediaQuery
                .of(context)
                .size
                .height * 0.85,
            decoration: BoxDecoration(
                color: Color(0xFFFe0d7d1),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.elliptical(350, 170))),
          ),
          Container(
            alignment: Alignment.topCenter,
            height: MediaQuery
                .of(context)
                .size
                .height * 0.58,
            decoration: BoxDecoration(
                color: Color(0xFFF161f1d),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.elliptical(340, 200))),
          ),


          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,

              children: [

                Container(
                  margin: EdgeInsets.only(left: MediaQuery
                      .of(context)
                      .size
                      .width * 0.1, right: MediaQuery
                      .of(context)
                      .size
                      .width * 0.1, top: MediaQuery
                      .of(context)
                      .size
                      .height * 0.12),
                  alignment: Alignment.topLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome Back!', style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 50),),

                      Text('Hey! Good to see you again.', style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 17),),


                      Container(
                        margin: EdgeInsets.only(top: MediaQuery
                            .of(context)
                            .size
                            .height * 0.1),
                        child: Text(
                          'Sign in',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 45,
                              fontWeight: FontWeight.bold),
                        ),
                      ),


                      Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.always,

                        child: Container(
                          margin: EdgeInsets.only(top: MediaQuery
                              .of(context)
                              .size
                              .height * 0.01),
                          child: Column(
                            children: [

                              TextFormField(
                                controller: email,
                                autofocus: false,

                                decoration: InputDecoration(
                                  label: Text(
                                    'Email address',
                                    style: TextStyle(color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400),
                                  ),

                                  icon: Icon(
                                    Icons.mail_outline_rounded,
                                    color: Colors.white,
                                  ),

                                  labelStyle: TextStyle(fontSize: 18),
                                  errorStyle: TextStyle(
                                    color: Colors.white,),

                                  hintText: 'abc@gmail.com',
                                  hintStyle: TextStyle(color: Colors.black26),


                                ),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    overflow: null),
                                keyboardType: TextInputType.emailAddress,


                                validator: (value) {
                                  if (value == null || !value.contains('@') ||
                                      !value.endsWith('gmail.com')) {
                                    return 'Enter a valid Gmail address ';
                                  }
                                  return null;
                                },

                              ),


                              TextFormField(
                                controller: pass,

                                decoration: InputDecoration(
                                  label: Text(
                                    'Password',
                                    style: TextStyle(color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  icon: Icon(
                                    Icons.security_outlined,
                                    color: Colors.white,
                                  ),
                                  labelStyle: TextStyle(fontSize: 18),
                                  errorStyle: TextStyle(
                                    color: Colors.white,),

                                  hintText: '8 character password',
                                  hintStyle: TextStyle(color: Colors.black26),

                                ),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    overflow: null),
                                keyboardType: TextInputType.visiblePassword,
                                validator: (value) {
                                  if (value == null || value
                                      .trim()
                                      .isEmpty) {
                                    return 'This field is required';
                                  }
                                  if (value
                                      .trim()
                                      .length < 8) {
                                    return 'Password must be at least 8 characters in length';
                                  }
                                  // Return null if the entered password is valid
                                  return null;
                                },
                              ),


                              Center(
                                child: Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(
                                        top: MediaQuery
                                            .of(context)
                                            .size
                                            .height * 0.06),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          dynamic result = await _auth
                                              .signInEmailPassword(LoginUser(
                                              email: email.text,
                                              password: pass.text));
                                          if (result.uid == null) {
                                            // Handle the case where the user does not exist or the password is incorrect
                                            final snackBar = SnackBar(
                                              content: Text('User does not exist or wrong password!'),
                                            );
                                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                          } else {
                                            print(result.code);
                                            // Sign-in was successful

                                            Map<String, dynamic> userData = await getUserData(email.text);
                                            var profilephoto;
                                            var name;
                                            var userid;
                                            if (userData != null) {
                                              // User data is available, you can access it like this:
                                              name = userData['name'];
                                              userid = userData['id'];
                                              profilephoto = userData['profilePhotoPath'];

                                              setState(() {

                                              });
                                              print(userid);

                                              // Do something with the user data
                                            } else {
                                              // Handle the case where the user document does not exist
                                              print('User data not found.');
                                            }
                                            SharedPreferences prefs = await SharedPreferences.getInstance();







                                            setState(() {
                                              prefs.setString('email', email.text);
                                              prefs.setString('userid', userid);
                                              prefs.setString('name', name);
                                              prefs.setString('profilephoto', profilephoto);

                                            });
                                            Navigator.push(context, MaterialPageRoute(
                                              builder: (context) => Home(),
                                            ));



                                          }

                                        }

                                      },
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.black,
                                          shape:
                                          StadiumBorder(
                                              side: BorderSide(width: 0.1)),
                                          minimumSize: Size(
                                              MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width * 0.95,
                                              MediaQuery
                                                  .of(context)
                                                  .size
                                                  .height * 0.063)),
                                      child: Text('Sign in me'),
                                    )),
                              ),


                              Container(
                                margin: EdgeInsets.only(top: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.03),
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushReplacement(
                                          CupertinoPageRoute(
                                              builder: (context) => Signup()));
                                    },
                                    child: Text('Create  an account',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),

                                  ),

                                ),
                              ),

                              Container(
                                alignment: Alignment.bottomCenter,
                                margin: EdgeInsets.only(top: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.015),),
                              Center(
                                child: Text('Need help?', style: TextStyle(
                                    color: Colors.black,
                                    decoration: TextDecoration.underline,
                                    fontSize: 15),
                                ),
                              ),


                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                )


              ],


            ),
          )


        ],

      ),
    );
  }
}
