import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../progressindi.dart';















class Settingss extends StatefulWidget {

  @override
  State<Settingss> createState() => _SettingssState();
}

class _SettingssState extends State<Settingss> {





// Retrieve all data from a single collection
  Future<List<Map<String, dynamic>>> getAllDataFromCollection(
      String collectionPath) async {
    final QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection(collectionPath).orderBy('date',descending: true).get();

    if (snapshot.docs.isNotEmpty) {
      // Create a list to hold the extracted data
      final List<Map<String, dynamic>> dataList = [];

      // Iterate through all documents in the collection
      snapshot.docs.forEach((doc) {
        // Extract the document data and add it to the list
        final data = doc.data();
        dataList.add(data as Map<String, dynamic>);
      });



      return dataList;
    } else {
      print('No data found in the collection.');
      return [];
    }
  }





  var profileimage2;
  // void updateProfilePhoto() {
  //   setState(() {
  //     profileimage2 = profilephoto;
  //   });
  // }
  var id;
  Future<List<Map<String, dynamic>>>? _futureData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    id= userid;
    print(id);











      _futureData = getAllDataFromCollection('users');







    // loadProfilePhoto();

  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getDataFromFirestore() {
    // Replace 'your_collection' and 'your_document_id' with the appropriate values
    print('Getting data from Firestore'); // Add this line

    return FirebaseFirestore.instance
        .collection('users')
        .doc(userid)
        .get();
    print(userid);
  }

  // var useridd;

  void loadProfilePhoto() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

// Reload the SharedPreferences instance to get the latest values
//     await prefs.reload();

// Get the updated value from SharedPreferences
    profileimage2 = prefs.getString('profilephoto');
    // useridd = prefs.getString('userid');
    print(profileimage2);

  }



  String capitalize(String input) {
    if (input.isEmpty) {
      return input;
    }

    List<String> words = input.split(' ');
    for (int i = 0; i < words.length; i++) {
      String word = words[i];
      if (word.isNotEmpty) {
        words[i] = word[0].toUpperCase() + word.substring(1);
      }
    }

    return words.join(' ');
  }


  final _auth = FirebaseAuth.instance;




// var profilephoto2;
  @override
  Widget build(BuildContext context) {

    // Navigator.pop(context);
    // updateProfilePhoto();

    loadProfilePhoto();

    Future<void> _refreshData() async {
      // Perform a refresh operation here, such as fetching new data from an API.
      await Future.delayed(Duration(seconds: 2));
      setState(() {
        _futureData;
      });
    }

    print(userid);


    return Scaffold(

      backgroundColor: Color(0xFFF1e2324),
      appBar: AppBar(
  backgroundColor: Color(0xFFF1e2324),

        elevation: 0,

        title: Text('Settings'),


      ),

      // body: Container(
      //   margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.02,left: MediaQuery.of(context).size.height*0.02,right: MediaQuery.of(context).size.height*0.02,),
      //   child: SingleChildScrollView(
      //     child: Column(children: [
      //
      //
      //
      //
      //
      //
      //
      //        Row(
      //
      //           children: [
      //
      //             ClipRRect(
      //               borderRadius: BorderRadius.all(Radius.circular(60)),
      //               child: GestureDetector(
      //                 onTap: (){
      //                   Navigator.pushNamed(context, '/profilephoto');
      //                 },
      //                 child: Container(
      //                   padding: EdgeInsets.all(15),
      //                     // color: Colors.greenAccent,
      //                     decoration: BoxDecoration(
      //                       shape: BoxShape.circle,
      //                       color: Colors.greenAccent,
      //                     ),
      //                     child: Image.asset(profileimage2==null?'assets/images/p2.png':profileimage2,height: MediaQuery.of(context).devicePixelRatio*20,)),
      //               ),
      //             ),
      //
      //
      //             Container(
      //               margin: EdgeInsets.only(left:  MediaQuery.of(context).size.height*0.03),
      //               child: Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Text(capitalize(name),style: TextStyle(fontSize: MediaQuery.of(context).devicePixelRatio*10,color: Colors.white),),
      //                   Text(capitalize(email),style: TextStyle(fontSize:  MediaQuery.of(context).devicePixelRatio*6,color: Colors.white),),
      //                 ],
      //               ),
      //             ),
      //           ],
      //         ),
      //
      //       // Text(userid,style: TextStyle(fontSize: 18,color: Colors.white),),
      //       Container(margin: EdgeInsets.symmetric(vertical:  MediaQuery.of(context).size.height*0.025),),
      //       ListTile(
      //         onTap: (){},
      //         // subtitle: Text('Change phone number, Transfer account, Delete account',style: TextStyle(fontSize: MediaQuery.of(context).devicePixelRatio*4,color: Colors.grey),),
      //         leading: Icon(CupertinoIcons.person_alt_circle,color: Colors.white,size:MediaQuery.of(context).devicePixelRatio*10 ,),
      //         title: Text('Account',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).devicePixelRatio*6),),),
      //
      //       ListTile(
      //         onTap: (){},
      //         leading: Icon(CupertinoIcons.doc_append,color: Colors.white,size:MediaQuery.of(context).devicePixelRatio*10 ,),
      //         title: Text('Appearance',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).devicePixelRatio*6),),),
      //
      //         ListTile(
      //         onTap: (){},
      //         leading: Icon(CupertinoIcons.chat_bubble,color: Colors.white,size:MediaQuery.of(context).devicePixelRatio*10 ,),
      //         title: Text('Chats',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).devicePixelRatio*6),),),
      //
      //         ListTile(
      //         onTap: (){},
      //         leading: Icon(CupertinoIcons.bell,color: Colors.white,size:MediaQuery.of(context).devicePixelRatio*10 ,),
      //         title: Text('Notifications',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).devicePixelRatio*6),),),
      //
      //
      //         ListTile(
      //         onTap: (){},
      //         leading: Icon(CupertinoIcons.lock,color: Colors.white,size:MediaQuery.of(context).devicePixelRatio*10 ,),
      //         title: Text('Privacy',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).devicePixelRatio*6),),),
      //
      //
      //         ListTile(
      //         onTap: (){},
      //         leading: Icon(CupertinoIcons.chart_pie,color: Colors.white,size:MediaQuery.of(context).devicePixelRatio*10 ,),
      //         title: Text('Data and Storage',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).devicePixelRatio*6),),),
      //
      //       Container(margin: EdgeInsets.symmetric(vertical:  MediaQuery.of(context).size.height*0.025,),child: Divider(color: Colors.blueGrey,),),
      //
      //
      //       ListTile(
      //         onTap: (){},
      //         leading: Icon(CupertinoIcons.question_circle,color: Colors.white,size:MediaQuery.of(context).devicePixelRatio*10 ,),
      //         title: Text('Help',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).devicePixelRatio*6),),),
      //
      //         ListTile(
      //         onTap: (){},
      //         leading: Icon(CupertinoIcons.paperplane,color: Colors.white,size:MediaQuery.of(context).devicePixelRatio*10 ,),
      //         title: Text('Invite a friend',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).devicePixelRatio*6),),),
      //
      //
      //
      //       Container(margin: EdgeInsets.symmetric(vertical:  MediaQuery.of(context).size.height*0.025,),child: Divider(color: Colors.blueGrey,),),
      //
      //
      //       ListTile(
      //         onTap: (){
      //           showDialog(
      //               context: context,
      //               builder: (context) {
      //                 return AlertDialog(
      //                   backgroundColor:  Color(0xFFF223847),
      //                   // backgroundColor: Color(0xFFF062121),
      //                   shape: RoundedRectangleBorder(
      //                       borderRadius: BorderRadius.circular(10)),
      //                   title: Text(
      //                     'Are you sure you want to log out?',
      //                     style: TextStyle(color: Colors.white),
      //                   ),
      //                   icon: Icon(
      //                     Icons.output,
      //                     color: Colors.white,
      //                   ),
      //
      //                   content: Row(
      //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
      //                     children: [
      //                       ElevatedButton(
      //                         onPressed: () async {
      //                           await _auth.signOut();
      //
      //                           SharedPreferences prefs =
      //                           await SharedPreferences.getInstance();
      //                           prefs.remove('email');
      //                           prefs.remove('userid');
      //                           prefs.remove('name');
      //                           Navigator.pushNamedAndRemoveUntil(
      //                               context, '/signin', (route) => false);
      //
      //                           // Navigator.pushReplacement(context, CupertinoPageRoute(builder: (BuildContext context){
      //                           //   return SignIn();
      //                           // }));
      //                         },
      //                         style: ElevatedButton.styleFrom(
      //                           shape: RoundedRectangleBorder(
      //                               side: BorderSide(color: Color(0xFFF1e2324)),
      //                               borderRadius: BorderRadius.all(Radius.circular(20))),
      //                           backgroundColor: Colors.red,
      //                         ),
      //                         child: Text('Yes',
      //                             style: TextStyle(fontWeight: FontWeight.bold)),
      //                       ),
      //                       ElevatedButton(
      //                         onPressed: () {
      //                           Navigator.of(context, rootNavigator: true)
      //                               .pop('dialog');
      //                         },
      //                         child: Text(
      //                           'No',
      //                           style: TextStyle(fontWeight: FontWeight.bold),
      //                         ),
      //                         style: ElevatedButton.styleFrom(
      //                           shape: RoundedRectangleBorder(
      //                               side: BorderSide(color: Color(0xFFF1e2324)),
      //                               borderRadius: BorderRadius.all(Radius.circular(20))),
      //                           backgroundColor: Colors.green,
      //                         ),
      //                       )
      //                     ],
      //                   ),
      //                 );
      //               });
      //         },
      //         leading: Icon(Icons.logout,color: Colors.white,size:MediaQuery.of(context).devicePixelRatio*10 ,),
      //         title: Text('Logout',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).devicePixelRatio*6),),),
      //
      //
      //
      //
      //     ],),
      //   ),
      // ),



      body: WillPopScope(
        onWillPop: () async{
          setState(() {

          });
          return true;
        },

        child: Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.02,left: MediaQuery.of(context).size.height*0.02,right: MediaQuery.of(context).size.height*0.02,),

          child: SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  future: getDataFromFirestore(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      // return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: StaggeredDotsWave(color: Colors.white, size:  MediaQuery.of(context).size.height*0.09 ));

                    }
                    if (!snapshot.hasData || snapshot.data!.data()==null) {
                      return SizedBox();
                    }

                      print(id);

                      final data = snapshot.data!.data();
                      // final naam = data!['name'];
                      final mail = data!['email'];
                      final profile = data!['profilephotopath'];

                      return Row(

                        children: [

                          ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(60)),
                            child: GestureDetector(
                              onTap: (){
                                Navigator.pushNamed(context, '/profilephoto');
                              },
                              child: Container(
                                  padding: EdgeInsets.all(15),
                                  // color: Colors.greenAccent,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.greenAccent,
                                  ),
                                  child: Image.asset(profile==null?'assets/images/noprofile.png':profile,height: MediaQuery.of(context).devicePixelRatio*20,)),
                            ),
                          ),


                          Container(
                            margin: EdgeInsets.only(left:  MediaQuery.of(context).size.height*0.03),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text(capitalize(naam),style: TextStyle(fontSize: MediaQuery.of(context).devicePixelRatio*10,color: Colors.white),),
                                Text(capitalize(mail),style: TextStyle(fontSize:  MediaQuery.of(context).devicePixelRatio*6,color: Colors.white),),
                              ],
                            ),
                          ),
                        ],
                      );

                  },
                ),









            Column(children: [







               // Row(
               //
               //    children: [
               //
               //      ClipRRect(
               //        borderRadius: BorderRadius.all(Radius.circular(60)),
               //        child: GestureDetector(
               //          onTap: (){
               //            Navigator.pushNamed(context, '/profilephoto');
               //          },
               //          child: Container(
               //            padding: EdgeInsets.all(15),
               //              // color: Colors.greenAccent,
               //              decoration: BoxDecoration(
               //                shape: BoxShape.circle,
               //                color: Colors.greenAccent,
               //              ),
               //              child: Image.asset(profileimage2==null?'assets/images/p2.png':profileimage2,height: MediaQuery.of(context).devicePixelRatio*20,)),
               //        ),
               //      ),
               //
               //
               //      Container(
               //        margin: EdgeInsets.only(left:  MediaQuery.of(context).size.height*0.03),
               //        child: Column(
               //          crossAxisAlignment: CrossAxisAlignment.start,
               //          children: [
               //            Text(capitalize(name),style: TextStyle(fontSize: MediaQuery.of(context).devicePixelRatio*10,color: Colors.white),),
               //            Text(capitalize(email),style: TextStyle(fontSize:  MediaQuery.of(context).devicePixelRatio*6,color: Colors.white),),
               //          ],
               //        ),
               //      ),
               //    ],
               //  ),

              // Text(userid,style: TextStyle(fontSize: 18,color: Colors.white),),
              Container(margin: EdgeInsets.symmetric(vertical:  MediaQuery.of(context).size.height*0.025),),
              ListTile(
                onTap: (){},
                // subtitle: Text('Change phone number, Transfer account, Delete account',style: TextStyle(fontSize: MediaQuery.of(context).devicePixelRatio*4,color: Colors.grey),),
                leading: Icon(CupertinoIcons.person_alt_circle,color: Colors.white,size:MediaQuery.of(context).devicePixelRatio*10 ,),
                title: Text('Account',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).devicePixelRatio*6),),),

              ListTile(
                onTap: (){},
                leading: Icon(CupertinoIcons.doc_append,color: Colors.white,size:MediaQuery.of(context).devicePixelRatio*10 ,),
                title: Text('Appearance',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).devicePixelRatio*6),),),

                ListTile(
                onTap: (){},
                leading: Icon(CupertinoIcons.chat_bubble,color: Colors.white,size:MediaQuery.of(context).devicePixelRatio*10 ,),
                title: Text('Chats',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).devicePixelRatio*6),),),

                ListTile(
                onTap: (){},
                leading: Icon(CupertinoIcons.bell,color: Colors.white,size:MediaQuery.of(context).devicePixelRatio*10 ,),
                title: Text('Notifications',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).devicePixelRatio*6),),),


                ListTile(
                onTap: (){},
                leading: Icon(CupertinoIcons.lock,color: Colors.white,size:MediaQuery.of(context).devicePixelRatio*10 ,),
                title: Text('Privacy',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).devicePixelRatio*6),),),


                ListTile(
                onTap: (){},
                leading: Icon(CupertinoIcons.chart_pie,color: Colors.white,size:MediaQuery.of(context).devicePixelRatio*10 ,),
                title: Text('Data and Storage',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).devicePixelRatio*6),),),

              Container(margin: EdgeInsets.symmetric(vertical:  MediaQuery.of(context).size.height*0.025,),child: Divider(color: Colors.blueGrey,),),


              ListTile(
                onTap: (){},
                leading: Icon(CupertinoIcons.question_circle,color: Colors.white,size:MediaQuery.of(context).devicePixelRatio*10 ,),
                title: Text('Help',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).devicePixelRatio*6),),),

                ListTile(
                onTap: (){},
                leading: Icon(CupertinoIcons.paperplane,color: Colors.white,size:MediaQuery.of(context).devicePixelRatio*10 ,),
                title: Text('Invite a friend',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).devicePixelRatio*6),),),



              Container(margin: EdgeInsets.symmetric(vertical:  MediaQuery.of(context).size.height*0.025,),child: Divider(color: Colors.blueGrey,),),


              ListTile(
                onTap: (){
                  showDialog(
                            context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor:  Color(0xFFF223847),
                          // backgroundColor: Color(0xFFF062121),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          title: Text(
                            'Are you sure you want to log out?',
                            style: TextStyle(color: Colors.white),
                          ),
                          icon: Icon(
                            Icons.output,
                            color: Colors.white,
                          ),

                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  await _auth.signOut();

                                  SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                                  prefs.remove('email');
                                  prefs.remove('userid');
                                  prefs.remove('name');
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, '/signin', (route) => false);

                                  // Navigator.pushReplacement(context, CupertinoPageRoute(builder: (BuildContext context){
                                  //   return SignIn();
                                  // }));
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(color: Color(0xFFF1e2324)),
                                      borderRadius: BorderRadius.all(Radius.circular(20))),
                                  backgroundColor: Colors.red,
                                ),
                                child: Text('Yes',
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop('dialog');
                                },
                                child: Text(
                                  'No',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(color: Color(0xFFF1e2324)),
                                      borderRadius: BorderRadius.all(Radius.circular(20))),
                                  backgroundColor: Colors.green,
                                ),
                              )
                            ],
                          ),
                        );
                      });
                },
                leading: Icon(Icons.logout,color: Colors.white,size:MediaQuery.of(context).devicePixelRatio*10 ,),
                title: Text('Logout',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).devicePixelRatio*6),),),




            ],)






              ],
            ),
          ),
        ),
      ),

    );
  }
}
