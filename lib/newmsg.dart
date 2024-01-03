import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'chat/chatdetail.dart';
import 'main.dart';






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



class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {

  final srch = TextEditingController();
  Future<List<Map<String, dynamic>>>? _futureData;


  @override
  void initState() {
    super.initState();

    _futureData = getAllDataFromCollection('users');



  }


  TextInputType keybt = TextInputType.name;




  FocusNode _focusNode = FocusNode();
  bool _isNumericKeyboard = false;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleKeyboardType() {
    setState(() {
      _isNumericKeyboard = !_isNumericKeyboard;
      if (_isNumericKeyboard) {
        _focusNode.requestFocus();
      } else {
        _focusNode.unfocus();
      }
    });
  }

















  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('New message',style: TextStyle(fontSize: 20),),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.more_vert))
        ],

      ),
      body:

      Container(
        margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.03,vertical: MediaQuery.of(context).size.height*0.02),
        child: GestureDetector(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.09)),
              child: TextFormField(
                controller: srch,


                cursorColor: Colors.white,

                focusNode: _focusNode,
                keyboardType: _isNumericKeyboard ? TextInputType.number : TextInputType.text,

                decoration: InputDecoration(
                  iconColor: Colors.white,



                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Color(0xFFF223847),
                  border: InputBorder.none,
                  suffixIcon: IconButton(icon: Icon(Icons.dialpad,color: Colors.white,),onPressed: (){
                    _toggleKeyboardType;
                  },),





                ),
                style: TextStyle(color: Colors.white),
              ),
            ),


            Container(
              margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.02),


              child: ListTile(
                onTap: (){},
                title: Text('New Group',style: TextStyle(color: Colors.white),),
                leading: Container(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.03),
                    decoration: BoxDecoration(
                      color: Color(0xFFF223847),
                      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.07)
                    ),
                    child: Icon(Icons.group_add,color: Colors.white,)),
              ),
            ),

            Container(
                margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.05,vertical: MediaQuery.of(context).size.height*0.02),

                child: Text('Contacts',style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),)
            ),

              ListTile(
                onTap: (){},
                title: Text('VDC Support ',style: TextStyle(
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).devicePixelRatio *6,
                ),),
                subtitle: Text('Coming soon',style: TextStyle(color: Colors.grey),),

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
                        color:  Colors.white,
                      ),
                      child: Image.asset(
                        'assets/images/icon.png' ,
                        height: MediaQuery.of(context).devicePixelRatio * 20,
                      ),
                    ),
                  ),
                ),
              ),








              StreamBuilder<DocumentSnapshot>(

                stream: FirebaseFirestore.instance.collection('users').doc(userid).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    // return TwoRotatingArc(color: Colors.white, size:  MediaQuery.of(context).size.height*0.09 );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // return TwoRotatingArc(color: Colors.white, size:  MediaQuery.of(context).size.height*0.09 );
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return SizedBox();
                    // return Center(child: Text('Find a friend ',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.height*0.02),));
                  }

                  var data = snapshot.data!.data() as Map<String, dynamic>;
                  var dataArray = data['contactlist'] ;

                  return dataArray==null?Container():Expanded(
                    child: ListView.builder(
                      itemCount: dataArray.length,
                      itemBuilder: (BuildContext context, int index) {
                        var documentId = dataArray[index];
                        print(documentId);

                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance.collection('users').doc(documentId).get(),
                          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasError) {
                              // return Text('Error: ${snapshot.error}');
                            }

                            if (snapshot.connectionState == ConnectionState.waiting) {
                              // return Center(child: StaggeredDotsWave(color: Colors.white, size:  MediaQuery.of(context).size.height*0.09 ));

                            }

                            if (!snapshot.hasData || !snapshot.data!.exists) {
                              // return Text('No data available');
                              return SizedBox();
                            }

                            var data = snapshot.data!.data() as Map<String, dynamic>;
                            var title = data['name'];
                            var subtitle = data['email'];
                            print(title);
                            String userName = data['name'] ?? '';
                            String profile = data['profilephotopath'] ?? '';
                            String id = data['id'];

                            return Container(
                              margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.01),

                              child: ListTile(
                                onTap: () {
                                  Navigator.push(context, CupertinoPageRoute(builder: (context) {
                                    return ChatDetail(id, userName, profile);
                                  }));
                                },
                                // trailing: IconButton(icon: Icon(Icons.person_add_alt,color: Colors.red,),onPressed: (){
                                //   addToContactList(userid, id);
                                //   removeFromContactList(userid, id);
                                // }.=
                                // ),
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
                                        color:           profile == '' ?Colors.white:null,
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  userName,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: MediaQuery.of(context).devicePixelRatio * 7,
                                  ),
                                ),
                                // subtitle: Text(
                                //   'message',
                                //   style: TextStyle(
                                //     color: Colors.grey,
                                //     fontSize: MediaQuery.of(context).devicePixelRatio * 5,
                                //   ),
                                // ),
                                // Other ListTile properties or widget structure as needed
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
















              // FutureBuilder<List<Map<String, dynamic>>>(
              //   future: _futureData,
              //   builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return Center(
              //         child: TwoRotatingArc(size: MediaQuery.of(context).size.height*0.08, color: Colors.white),
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
              //
              //         return ListTile(
              //
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
              //         shrinkWrap: true, // Add this line to allow the list to be placed inside a SingleChildScrollView
              //         physics: NeverScrollableScrollPhysics(), // Disable scrolling of the inner list
              //
              //         children: userList,
              //       );
              //     } else {
              //       return Text('No data found in the collection.');
              //     }
              //   },
              // )

          ],),
        ),
      ),
    );
  }
}
