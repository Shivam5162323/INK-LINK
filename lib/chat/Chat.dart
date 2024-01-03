import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import '../newmsg.dart';
import '../progressindi.dart';
import 'chatdetail.dart';
// import 'package:rxdart/rxdart.dart';


// import '../newmsg.dart';
// import '../progressindi.dart';





// Retrieve all data from a single collection
Future<List<Map<String, dynamic>>> getAllDataFromCollection(
    String collectionPath) async {
  final QuerySnapshot snapshot =
  await FirebaseFirestore.instance.collection(collectionPath).orderBy('time',descending: true).get();

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







Future<List<Map<String, dynamic>>> getchatlist(
    String collectionPath) async {
  final QuerySnapshot snapshot =
  await FirebaseFirestore.instance.collection('users').get();

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



class Chats extends StatefulWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {



  Future<DocumentSnapshot<Map<String, dynamic>>> getchatlist() {
    // Replace 'your_collection' and 'your_document_id' with the appropriate values
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userid)
        .get();
  }



  Future<List<Map<String, dynamic>>>? _futureData;




  String convertTimestampToTime(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();

    DateTime currentDate = DateTime.now();
    DateTime previousDate = currentDate.subtract(Duration(days: 1));

    if (dateTime.year == currentDate.year && dateTime.month == currentDate.month && dateTime.day == currentDate.day) {
      DateFormat outputFormat = DateFormat("h:mm a");
      String formattedTime = outputFormat.format(dateTime);
      return formattedTime;
    } else if (dateTime.year == previousDate.year && dateTime.month == previousDate.month && dateTime.day == previousDate.day) {
      return "Yesterday";
    } else {
      DateFormat outputFormat = DateFormat("h:mm a, d MMMM yyyy");
      String formattedTime = outputFormat.format(dateTime);
      return formattedTime;
    }
  }








  @override
  void initState() {
    super.initState();

    _futureData = getAllDataFromCollection('users');



  }
















  void addSenderMessage() async{






    String documentId = 'adf';



// Retrieve the document reference
    DocumentReference documentRef = FirebaseFirestore.instance
        .collection('users')
        .doc(documentId);

// Generate a unique ID for the new map entry
    String mapEntryId = documentRef.id;

// Create the map entry data

    var dc = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
    Map<String, dynamic> mapEntryData = {
      'message': 'abc',
      'receiverId': userid,
      'timestamp': DateTime.now(),





    };

// Add the map entry to Firestore


    await documentRef
        .collection('users')
        .doc('acf')
        .set(mapEntryData)
        .then((value) {
      print('Map entry added successfully');
    })
        .catchError((error) {
      print('Failed to add map entry: $error');
    });






  }

















  late String documentId;
  void addUsertoDatabase() async {



    // String documentId = generateDocumentId(email);
    DocumentReference users = FirebaseFirestore.instance.collection('users').doc();
    documentId = users.id;
    userid = documentId;
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString('userid', users.id);

    // print('User id======= $users.id');





    // print(_drivelink);
    // Call the user's CollectionReference to add a new user
    return users
        .set({
      // 'phone': phoneno.text,
      // 'name': name.text ,
      'email':email,
      'id': users.id,
      // 'pass': password.text,
      'time': DateTime.now(),


    })
        .then((value) => print("user Added"))
        .catchError((error) => print("Failed to add user: $error"));

    print('User id======= $users.id');

  }




  final Stream<QuerySnapshot> _usersStream =
  FirebaseFirestore.instance.collection('users').snapshots();







  //
  //
  // Future<List<Map<String, dynamic>>> fetchChatDocuments() async {
  //   final snapshot = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(userid)
  //       .get();
  //
  //   if (snapshot.exists) {
  //     final data = snapshot.data() as Map<String, dynamic>;
  //     List<String> chatList = List<String>.from(data['chatlist']);
  //
  //     // Fetch data for each document in the chatlist array
  //     List<Future<DocumentSnapshot<Map<String, dynamic>>>> futures = chatList.map((docId) {
  //       return FirebaseFirestore.instance.collection('chats').doc(docId).get();
  //     }).toList();
  //
  //     // Wait for all the document fetches to complete
  //     List<DocumentSnapshot<Map<String, dynamic>>> snapshots = await Future.wait(futures);
  //
  //     // Extract the data from the fetched documents
  //     List<Map> chatData = snapshots.map((snapshot) {
  //       if (snapshot.exists) {
  //         return snapshot.data() as Map<String, dynamic>;
  //       } else {
  //         return {}; // Return an empty map if the document doesn't exist
  //       }
  //     }).toList();
  //
  //     return chatData.cast<Map<String, dynamic>>();
  //   } else {
  //     return [];
  //   }
  // }


  Future<List<dynamic>> fetchArrayFromFirestore(String userId) async {
    List<dynamic> result = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('userId', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        result = querySnapshot.docs.first.get('yourArrayField');
      }
    } catch (e) {
      print('Error fetching array: $e');
    }

    return result;
  }


















  Stream<QuerySnapshot<Map<String, dynamic>>> messageStream(String id) {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc('${userid}_${id}')
        .collection('chats')
        .orderBy(
        'timestamp', descending: true) // Optional: Order messages by timestamp
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> messagereadstream(String id) {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc('${id}_${userid}')
        .collection('messages')
        .snapshots();
  }







  Stream<String> fetchVariable(String id) {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc('${userid}_${id}')
        .snapshots()
        .map((snapshot) => snapshot.data()!['read'] as String);
  }





  String? lastMessage;
  DateTime?  lastMessagetime;

  @override
  Widget build(BuildContext context) {






    return Scaffold(
      backgroundColor: Color(0xFFF1e2324),




      body:


      // FutureBuilder<List<Map<String, dynamic>>>(
      //   future: _futureData,
      //   builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     } else if (snapshot.hasData) {
      //       final currentUserID = userid; // Replace 'current user id' with the actual value
      //
      //
      //
      //       final userList = snapshot.data!
      //           .where(((userData) => userData['id'] != currentUserID))
      //           .map((userData) {
      //         String userName = userData['name'] ?? '';
      //         String profile = userData['profilephotopath']?? '';
      //         String id = userData['id'];
      //
      //
      //         return ListTile(
      //
      //
      //           onTap: (){
      //             Navigator.push(context, CupertinoPageRoute(builder: (context){
      //               return ChatDetail(id, userName,profile);
      //             }));
      //
      //           },
      //           leading:   ClipRRect(
      //             borderRadius: BorderRadius.all(Radius.circular(60)),
      //             child: GestureDetector(
      //               onTap: (){
      //                 // Navigator.pushNamed(context, '/profilephoto');
      //               },
      //               child: Container(
      //                   padding: EdgeInsets.all(15),
      //                   // color: Colors.greenAccent,
      //                   decoration: BoxDecoration(
      //                     shape: BoxShape.circle,
      //                     color: profile==''?Color(0xFFF161f1d):Colors.greenAccent,
      //                   ),
      //                   child: Image.asset(profile==''?'assets/images/noprofile.png':profile,height: MediaQuery.of(context).devicePixelRatio*20,)),
      //             ),
      //           ),
      //
      //           title: Text(userName,style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).devicePixelRatio*7 ),),
      //
      //
      //
      //
      //
      //
      //
      //
      //
      //
      //
      //
      //
      //
      //
      //
      //           subtitle:
      //
      //
      //
      //
      //           Text('message',style: TextStyle(color: Colors.grey,fontSize: MediaQuery.of(context).devicePixelRatio*5 ),),
      //
      //           // Other ListTile properties or widget structure as needed
      //         );
      //       })
      //           .toList();
      //
      //       return ListView(
      //         children: userList,
      //       );
      //     } else {
      //       return Text('No data found in the collection.');
      //     }
      //   },
      // ),





















      //
      //
      // StreamBuilder<DocumentSnapshot>(
      //   stream: FirebaseFirestore.instance.collection('users').doc(userid).snapshots(),
      //   builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
      //     if (snapshot.hasError) {
      //       return Text('Error: ${snapshot.error}');
      //     }
      //
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return CircularProgressIndicator();
      //     }
      //
      //     if (!snapshot.hasData || !snapshot.data!.exists) {
      //       return Text('No data available');
      //     }
      //
      //     var data = snapshot.data!.data() as Map<String, dynamic>;
      //     var dataArray = data['chatlist'] as List<dynamic>;
      //
      //     return ListView.builder(
      //       itemCount: dataArray.length,
      //       itemBuilder: (BuildContext context, int index) {
      //         var documentId = dataArray[index];
      //         print(documentId);
      //
      //         return FutureBuilder<DocumentSnapshot>(
      //           future: FirebaseFirestore.instance.collection('users').doc(documentId).get(),
      //           builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
      //             if (snapshot.hasError) {
      //               return Text('Error: ${snapshot.error}');
      //             }
      //
      //             if (snapshot.connectionState == ConnectionState.waiting) {
      //               return CircularProgressIndicator();
      //             }
      //
      //             if (!snapshot.hasData || !snapshot.data!.exists) {
      //               return Text('No data available');
      //             }
      //
      //             var data = snapshot.data!.data() as Map<String, dynamic>;
      //             var title = data['name'];
      //             var subtitle = data['email'];
      //
      //             return ListTile(
      //               title: Text(title),
      //               subtitle: Text(subtitle),
      //             );
      //           },
      //         );
      //       },
      //     );
      //   },
      // ),


      //
      //
      // FutureBuilder<DocumentSnapshot>(
      //   future: FirebaseFirestore.instance.collection('users').doc('EUwC8ycETABzQrefuO3i').get(),
      //   builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
      //     if (snapshot.hasError) {
      //       return Text('Error: ${snapshot.error}');
      //     }
      //
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //     }
      //
      //     if (!snapshot.hasData || !snapshot.data!.exists) {
      //       return Text('No data available');
      //     }
      //
      //     var data = snapshot.data!.data() as Map<String, dynamic>;
      //     var title = data['name'];
      //     var subtitle = data['email'];
      //     print(title);
      //             String userName = data['name'] ?? '';
      //             String profile = data['profilephotopath']?? '';
      //             String id = data['id'];
      //
      //
      //             return ListTile(
      //
      //
      //               onTap: (){
      //                 Navigator.push(context, CupertinoPageRoute(builder: (context){
      //                   return ChatDetail(id, userName,profile);
      //                 }));
      //
      //               },
      //               leading:   ClipRRect(
      //                 borderRadius: BorderRadius.all(Radius.circular(60)),
      //                 child: GestureDetector(
      //                   onTap: (){
      //                     // Navigator.pushNamed(context, '/profilephoto');
      //                   },
      //                   child: Container(
      //                       padding: EdgeInsets.all(15),
      //                       // color: Colors.greenAccent,
      //                       decoration: BoxDecoration(
      //                         shape: BoxShape.circle,
      //                         color: profile==''?Color(0xFFF161f1d):Colors.greenAccent,
      //                       ),
      //                       child: Image.asset(profile==''?'assets/images/noprofile.png':profile,height: MediaQuery.of(context).devicePixelRatio*20,color: Colors.white,)),
      //                 ),
      //               ),
      //
      //               title: Text(userName,style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).devicePixelRatio*7 ),),
      //
      //
      //
      //
      //
      //
      //
      //
      //
      //
      //
      //
      //
      //
      //
      //
      //               subtitle:
      //
      //
      //
      //
      //               Text('message',style: TextStyle(color: Colors.grey,fontSize: MediaQuery.of(context).devicePixelRatio*5 ),),
      //
      //               // Other ListTile properties or widget structure as needed
      //             );
      //   },
      // ),
      //






      StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(userid).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
          }

          if (!snapshot.hasData || snapshot.data == null || !snapshot.data!.exists) {
            return Center(child: StaggeredDotsWave(color: Colors.white, size: MediaQuery.of(context).size.height * 0.09));
          }

          var data = snapshot.data!.data() as Map<String, dynamic>;
          var dataArray = data['chatlist'] ;

          // var t = data['changemade'];



          return dataArray==null?Container(
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [

                  Text("Message a Friend!" , style: TextStyle(fontSize: MediaQuery.textScaleFactorOf(context)*27,fontWeight:FontWeight.bold,color: Colors.white),),

                  Container(
                    margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.03,horizontal: MediaQuery.of(context).size.width*0.1),
                    // padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.03),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
                      color: Colors.white,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.03),

                        child: Row(

                          mainAxisAlignment: MainAxisAlignment.center,


                          children: [

                            Image.asset('assets/images/friends.png'),
                            Image.asset('assets/images/icon.png'),

                          ],),
                      ),
                    ),
                  ),
                ],
              )
          ):ListView.builder(
            itemCount: dataArray.length,
            itemBuilder: (BuildContext context, int index) {
              var documentId = dataArray[index];
              print(documentId);

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('users').doc(documentId).get(),
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                  }

                  if (!snapshot.hasData || snapshot.data == null || !snapshot.data!.exists) {
                    return Center(child: StaggeredDotsWave(color: Colors.white, size: MediaQuery.of(context).size.height * 0.09));
                  }

                  var data = snapshot.data!.data() as Map<String, dynamic>;
                  var title = data['name'];
                  var subtitle = data['email'];
                  print(title);
                  String userName = data['name'] ?? '';
                  String profile = data['profilephotopath'] ?? '';
                  String id = data['id'];
                  Timestamp changemadeTimestamp = data['changemade'] ?? Timestamp(0, 0);


                  return ListTile(
                      onTap: () {
                        Navigator.push(context, CupertinoPageRoute(builder: (context) {
                          return ChatDetail(id, userName, profile);
                        }));
                      },
                      leading: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(60)),
                        child: GestureDetector(
                          onTap: () {
                            // Navigator.pushNamed(context, '/profilephoto');
                          },
                          child: Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: profile == '' ? Color(0xFFF161f1d) : Colors.greenAccent,
                            ),
                            child: Image.asset(
                              profile == '' ? 'assets/images/noprofile.png' : profile,
                              height: MediaQuery.of(context).devicePixelRatio * 20,
                              color:  profile == '' ?Colors.white:null,
                            ),
                          ),
                        ),
                      ),
                      trailing: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: messageStream(id),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            // return Container(); // Display a loading indicator while waiting for data
                          }
                          if (snapshot.hasError) {
                            print('Error: ${snapshot.error}');
                          }
                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            // Display a message if there are no messages
                            return Text('No messages');
                          }

                          var message = snapshot.data!.docs.last.data();

                          final content = message['message'];
                          final senderId = message['senderId'];
                          final receiverId = message['receiverId'];
                          final time = message['timestamp'];
                          final isCurrentUser = senderId == id;



                          final isLastMessage = index == (snapshot.data!.docs.length );

                          final lastMessage = snapshot.data!.docs.first.data()['message'];
                          final lastMessagetime = snapshot.data!.docs.first.data()['timestamp'];

                          // currUser = isCurrentUser;
                          final alignment = isCurrentUser ? Alignment.bottomRight : Alignment.bottomLeft;






                          double maxLength = 120; // Maximum length of the message
                          double scalingFactor = 0.9; // Scaling factor for adjusting the border radius

                          double borderRadius = maxLength - content.length * scalingFactor;
                          borderRadius = borderRadius.clamp(0.0, double.infinity);

                          return Container(
                            child: Text(convertTimestampToTime(lastMessagetime),style: TextStyle(color: Colors.grey),),
                          );
                        },
                      ),
                      title: Text(
                        userName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).devicePixelRatio * 7,
                        ),
                      ),
                      subtitle:













                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: messageStream(id),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            // return Container(); // Display a loading indicator while waiting for data
                          }
                          if (snapshot.hasError) {
                            print('Error: ${snapshot.error}');
                          }
                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            // Display a message if there are no messages
                            return Text('No messages');
                          }

                          var message = snapshot.data!.docs.last.data();

                          final content = message['message'];
                          final senderId = message['senderId'];
                          final receiverId = message['receiverId'];
                          final time = message['timestamp'];
                          final isCurrentUser = senderId == id;



                          final isLastMessage = index == (snapshot.data!.docs.length );

                          final last2 = snapshot.data!.docs.first.data()['message'];
                          final pattern = RegExp(r'\b\w+\b');
                          String last = last2.replaceAll('\n', ' ').trim();

                          final lastMessage =last.length >30 ?last.substring(0, 30):last;


                          final lastMessagetime = snapshot.data!.docs.first.data()['timestamp'];

                          // currUser = isCurrentUser;
                          final alignment = isCurrentUser ? Alignment.bottomRight : Alignment.bottomLeft;






                          double maxLength = 120; // Maximum length of the message
                          double scalingFactor = 0.9; // Scaling factor for adjusting the border radius

                          double borderRadius = maxLength - content.length * scalingFactor;
                          borderRadius = borderRadius.clamp(0.0, double.infinity);

                          return Container(
                            child: Text(lastMessage,style: TextStyle(color: Colors.grey),),
                          );
                        },
                      )














                    // Text(
                    //   'message',
                    //   style: TextStyle(
                    //     color: Colors.grey,
                    //     fontSize: MediaQuery.of(context).devicePixelRatio * 5,
                    //   ),
                    // ),
                    // Other ListTile properties or widget structure as needed
                  );
                },
              );
            },
          );
        },
      ),


























      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom:20),
            child: FloatingActionButton(
              heroTag: null,
              onPressed: () {

                // addUsertoDatabase();
                // addSenderMessage();

              },child: Icon(CupertinoIcons.camera,size: 25,color: Colors.white,weight: 100,),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(17))),
              backgroundColor: Color(0xFFF223847),
            ),
          ),

          FloatingActionButton(
            heroTag: null,
            onPressed: (){

              Navigator.push(context, CupertinoPageRoute(builder: (context){
                return NewMessage();
              }));

            },child: Icon(CupertinoIcons.pen,size: 37,color: Colors.white,weight: 100,),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(17))),
            backgroundColor: Color(0xFFF223847),
          ),


        ],
      ),
    );
  }
}
























