import 'dart:async';
import 'dart:math';
import 'dart:convert' as convert;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xy/Home.dart';
import 'package:xy/Signinup/signin.dart';
import 'package:xy/Test.dart';
import '../main.dart';
import 'package:email_otp/email_otp.dart';

import 'auth.dart';

final random = Random();
var o = random.nextInt(90000) + 10000;


var verifyotp;

String generateFiveDigitNumber() {
  Random random = Random();
  return (random.nextInt(90000) + 10000).toString(); // Generates a random number between 10000 and 99999
}



class OTPScreen extends StatefulWidget {
  final mailid;
  final pass;
  final name;
  OTPScreen(this.mailid,this.pass,this.name);
  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {


  final OTP = OtpFieldController();

  var otptosend= generateFiveDigitNumber();

  final AuthService _auth = AuthService();

  EmailOTP myauth = EmailOTP();



  Future<String> sendOtpToEmail() async {
    try {
      String username = 'vendvl.0@gmail.com'; // Your Gmail username
      String password = 'bteavjdkzosenaen'; // Your Gmail password

      final smtpServer = gmail(username, password);

      final message = Message()
        ..from = Address(username, 'VenDvl')
        ..recipients.add(widget.mailid) // Replace with the user's email address
        ..subject = otptosend
        ..html= '''
     <!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verification Code</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            display: flex;
            justify-content: center; /* Center horizontally */
            align-items: center; /* Center vertically */
            height: 100vh; /* Use full viewport height */
            margin: 0;
        }

        .container {
            display: table;
            margin: 0 auto;
            border-radius: 10px;
            padding: 20px;
            text-align: center; /* Align OTP to center */
            max-width: 100%; /* Set a maximum width for the container */
            box-sizing: border-box; /* Ensure padding is included in width */
            background-size: cover; /* Ensure the background image covers the container */
            background-position: center; /* Center the background image */
        }

        .bold-text {
            font-weight: bold;
            font-size: 24px;
            text-align: center;
        }

        .otp-container {
            letter-spacing: 1em;
            font-size: 32px;
        }

        img {
            display: block;
            margin: 0 auto; /* Center the image */
        }

        .info-text {
            margin-top: 20px;
            font-size: 14px;
            color: #777;
        }

        /* Add a class for white text */
        .white-text {
            color: white;
        }
    </style>

    <style>
        @media (min-width: 768px) {
            .container {
                background-image: url('https://c4.wallpaperflare.com/wallpaper/843/66/529/illustration-mountains-low-poly-minimalism-wallpaper-preview.jpg');
            }
            /* Apply white text for larger screens */
            .white-text {
                color: white;
            }
        }

        @media (max-width: 767px) {
            .container {
                background-image: url('https://c4.wallpaperflare.com/wallpaper/535/845/69/digital-art-artwork-fantasy-art-planet-sun-hd-wallpaper-thumb.jpg');
            }
        }
    </style>
</head>

<body>
    <div class="container">
        <div class="bold-text white-text">Ink Link</div>
        <img src="http://ven.epizy.com/image/output-onlinegiftools.gif" alt="GIF" width="200" height="200">
        <div class="otp-container white-text">
            $otptosend
        </div>
        <div class="white-text">Here is your verification code</div>
        <div class="info-text white-text">Please do not share this code with anyone for security reasons.</div>
    </div>
</body>

</html>





        '''
        ..text = 'Your OTP code is: '+ otptosend; // Replace with the generated OTP

      await send(message, smtpServer);

      return 'OTP sent successfully!';
    } catch (e) {
      return 'Failed to send OTP. Error: $e';
    }
  }














  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();



  late String documentId;
  Future<void> addUsertoDatabase() async {



    // String documentId = generateDocumentId(email);
    DocumentReference users = FirebaseFirestore.instance.collection('users').doc();
    documentId = users.id;
    // userid = documentId;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userid', users.id);

    print('User id======= $users.id');


    setState(() {

      // prefs.setString('userid', documentId);
    });


    // print(_drivelink);
    // Call the user's CollectionReference to add a new user
    return users
        .set({
      // 'phone': phoneno.text,
      'name': widget.name,
      'email':widget.mailid,
      'id': users.id,
      'pass': widget.pass,
      'time': DateTime.now(),


    })
        .then((value) => print("user Added"))
        .catchError((error) => print("Failed to add user: $error"));

    print('User id======= $users.id');

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Image.asset(
                'assets/images/plane.png',
                color: Colors.white,
              )),
          Text(
            'OTP Verification',
            style: TextStyle(fontSize: 36),
          ),
          Text(
            '* * * *',
            style: TextStyle(fontSize: 36),
          ),
          TextButton(
            child: Text(
              '''Click here to send OTP to''',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () async {

              String result = await sendOtpToEmail();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(result),
              ));
            },
          ),
          Text(
            '${widget.mailid}',
            style: TextStyle(color: Colors.orangeAccent, fontSize: 18),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 37),
            child: OTPTextField(
                controller: OTP,
                length: 5,
                outlineBorderRadius: 36,
                fieldWidth: 47,
                otpFieldStyle: OtpFieldStyle(
                  backgroundColor: Color(0xFFF062121),
                  focusBorderColor: Colors.orangeAccent,
                  borderColor: Colors.black,
                  enabledBorderColor: Colors.black,
                ),
                width: MediaQuery.of(context).size.width,
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                textFieldAlignment: MainAxisAlignment.spaceAround,
                fieldStyle: FieldStyle.box,
                onChanged: (String code) {
                  print(code);
                  setState(() {
                    verifyotp=code;
                  });
                },
                onCompleted: (String verificationCode) {
                }
            ),
          ),
          ElevatedButton(
              onPressed: () async {

                print(verifyotp);




                if (verifyotp.toString() == otptosend) {



                  dynamic result = await _auth.registerEmailPassword(
                      LoginUser(
                          email: widget.mailid, password: widget.pass));



                  addUsertoDatabase();

                  SharedPreferences prefs = await SharedPreferences.getInstance();







                  setState(() {
                    prefs.setString('email', widget.mailid);
                    prefs.setString('userid', documentId);
                    prefs.setString('name', widget.name);
                    prefs.setString('profilephoto', 'assets/images/noprofile.png');

                  });

                  print(documentId);

                  prefs.setString('userid', documentId);
                  setState(() {

                  });
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => Home()));
                } else {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Color(0xFFF062121),
                          title: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Wrong OTP",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                          content: Text(
                            'Check code and try once again!',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      });
                }
              },
              child: Text('Verify OTP')),
          TextButton(
              child: Text('Didn\'t receive OTP?'),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    CupertinoPageRoute(builder: (context) => Signin()));
                showDialog<void>(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Color(0xFFF062121),
                        icon: Icon(
                          Icons.send_outlined,
                          color: Colors.green,
                        ),
                        title: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "OTP sent",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            )),
                      );
                    });
              }),
        ],
      ),
    );
  }
}
