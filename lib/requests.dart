import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class Requests extends StatefulWidget {
  const Requests({Key? key}) : super(key: key);

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {






  void addToContactList(String userId, String nameToAdd) {
    final firestoreInstance = FirebaseFirestore.instance;
    final documentReference = firestoreInstance.collection('users').doc(userId);

    documentReference.get().then((documentSnapshot) {
      if (documentSnapshot.exists) {
        documentReference.update({
          'contactlist': FieldValue.arrayUnion([nameToAdd])
        }).then((_) {
          print('Name added to the requestlist array');
        }).catchError((error) {
          print('Error adding name to the requestlist array: $error');
        });
      } else {
        documentReference.set({
          'requestlist': [nameToAdd]
        }).then((_) {
          print('Document created with the requestlist array containing the name');
        }).catchError((error) {
          print('Error creating document with the requestlist array: $error');
        });
      }
    }).catchError((error) {
      print('Error checking if document exists: $error');
    });
  }











  void removeFromContactList(String userId, String nameToRemove) {
    final firestoreInstance = FirebaseFirestore.instance;
    final documentReference = firestoreInstance.collection('users').doc(userId);

    documentReference.get().then((documentSnapshot) {
      if (documentSnapshot.exists) {
        documentReference.update({
          'requestlist': FieldValue.arrayRemove([nameToRemove])
        }).then((_) {
          print('Name removed from the contactlist array');
        }).catchError((error) {
          print('Error removing name from the contactlist array: $error');
        });
      } else {
        print('Document does not exist');
      }
    }).catchError((error) {
      print('Error checking if document exists: $error');
    });
  }








  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFF1e2324),
        title: Text('Requests'),
        // leading: Icon(CupertinoIcons.heart_circle,color: Colors.red,),




      ),
      body:
      StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(userid).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Text('No data available');
          }

          var data = snapshot.data!.data() as Map<String, dynamic>;
          var dataArray = data['requestlist'] ;
          var chatArray = data['chatlist'] ;
          // print(chatArray);

          return dataArray==null?Container(

            child:                 Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/notfound.png',color: Colors.white,),

                Container(
                    margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.03),
                    child: Text("No Request found!" , style: TextStyle(fontSize: MediaQuery.textScaleFactorOf(context)*27,fontWeight:FontWeight.bold,color: Colors.white),)),
              ],
            )),


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

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Text('No data available');
                  }

                  var data = snapshot.data!.data() as Map<String, dynamic>;
                  var title = data['name'];
                  var subtitle = data['email'];
                  print(title);
                  String userName = data['name'] ?? '';
                  String profile = data['profilephotopath'] ?? '';
                  String id = data['id'];
                  print(id);

                  return userid==id?Container(
                    child:                 Center(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/notfound.png',color: Colors.white,),

                        Container(
                            margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.03),
                            child: Text("No Request found!" , style: TextStyle(fontSize: MediaQuery.textScaleFactorOf(context)*27,fontWeight:FontWeight.bold,color: Colors.white),)),
                      ],
                    )),
                  ):ListTile(
                    onTap: () {
                      // Navigator.push(context, CupertinoPageRoute(builder: (context) {
                      //   return ChatDetail(id, userName, profile);
                      // }));
                    },
                    trailing: IntrinsicWidth(
                      child: Row(
                        children: [
                          IconButton(icon: Icon(Icons.person_add_alt,color: Colors.red,),onPressed: (){
                            addToContactList(userid, id);
                            addToContactList(id,userid );
                            removeFromContactList(userid, id);
    }
                          ),

                          IconButton(icon: Icon(Icons.delete_outline,color: Colors.red,),onPressed: (){

                            removeFromContactList(userid, id);
                          }
                          ),
                        ],
                      ),
                    ),

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
                            color: profile == '' ?Colors.white:null,
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
                    subtitle: Text(
                      'message',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: MediaQuery.of(context).devicePixelRatio * 5,
                      ),
                    ),
                    // Other ListTile properties or widget structure as needed
                  );
                },
              );
            },
          );
        },
      ),


    );
  }
}
