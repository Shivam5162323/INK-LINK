import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xy/Signinup/signin.dart';
import 'package:xy/requests.dart';
import 'package:xy/stories/stories.dart';

import 'Calls/calls.dart';
import 'chat/Chat.dart';
import 'main.dart';




var searchitem='';

Future<String?> fetchEmailFromSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? email = prefs.getString('email');
  return email;
}
Future<String?> getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('userid');
}

class Home extends StatefulWidget {


  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _auth = FirebaseAuth.instance;

  // var _email;

  String _email = "";



  final srchcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPreferences();

    // SharedPreferences prefs = await SharedPreferences.getInstance();
    //
    // var email = prefs.getString('email');
    // userid = prefs.getString('userid');
    // name = prefs.getString('name');
    // profilephoto = prefs.getString('profilephoto');
  }


  Future<void> getEmailFromSharedPreferences() async {
    String? storedEmail = await fetchEmailFromSharedPreferences();
    setState(() {
      email = storedEmail;
    });
  }


  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email') ?? "";
    userid = prefs.getString('userid');
    setState(() {
      _email = email;
    });
  }

  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[Chats(), Calls(), Stories()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget logout() {
    return ElevatedButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Colors.black38,
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
                        // Navigator.pushNamedAndRemoveUntil(
                        //     context, '/signin', (route) => false);

                        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (BuildContext context){
                          return Signin();
                        }));
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(5)),
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
                            side: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(5)),
                        backgroundColor: Colors.green,
                      ),
                    )
                  ],
                ),
              );
            });
      },
      child: Text('Logout'),
    );
  }

  bool isSearching = false;

  @override
  Widget build(BuildContext context) {


    // _loadEmailFromPreferences();
    return WillPopScope(
      onWillPop: () async {
        if (isSearching) {
          setState(() {
            isSearching = false;
          });
          return false; // Prevent back navigation
        }
        return true; // Allow back navigation
      },
      child: Scaffold(
        backgroundColor: Color(0xFFF1e2324),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xFFF1e2324),
          title: isSearching ? _buildSearchField() : Text('Ink Link'),
          actions: [



            IconButton(
                onPressed: () {
                  setState(() {
                    isSearching = !isSearching;
                  });
                },
                icon: Icon(Icons.search)
            ),


            IconButton(
                onPressed: () {
                  // setState(() {
                  //   isSearching = !isSearching;
                  // });

                  Navigator.push(context, CupertinoPageRoute(builder: (context) {
                    return Requests();
                    // return TestClass();
                  }));
                },
                icon: Icon(CupertinoIcons.heart,color: Colors.red,)
            ),






            PopupMenuButton(
              icon: Icon(
                Icons.more_vert,
                color: Colors.white, // Set the desired color for the icon
              ),
              color: Color(0xFFF223847),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(17))),

              // color: Color(0xFFF223847),
              itemBuilder: (BuildContext context) {
                return <PopupMenuEntry>[
                  PopupMenuItem(
                    value: 'Logout',
                    child: logout(),
                  ),
                  PopupMenuItem(
                    value: 'Requests',
                    child: Text(
                      'Requests',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'Settings',
                    child:
                    Text('Settings', style: TextStyle(color: Colors.white)),
                  ),
                ];
              },
              onSelected: (value) {
                // Handle the selected option
                if (value == 'page1') {
                  Navigator.pushNamed(context, '/settings');
                } else if (value == 'Settings') {
                  Navigator.pushNamed(context, '/settings');
                }
              },
            )




          ],
        ),






        body: isSearching?Search():_widgetOptions.elementAt(_selectedIndex),



        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          color: Color(0xFFF223847),
          child: BottomNavigationBar(
            backgroundColor: Color(0xFFF223847),

            // elevation: 0,

            unselectedItemColor: Colors.blueGrey,

            showUnselectedLabels: true,
            showSelectedLabels: true,

            currentIndex: _selectedIndex,
            onTap: (index) => setState(() => _selectedIndex = index),
            unselectedIconTheme: IconThemeData(
              color: Colors.white,
            ),
            landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            selectedFontSize: 14,
            unselectedFontSize: 14,

            selectedItemColor: Colors.white,
            iconSize: 29,
            items: [
              BottomNavigationBarItem(
                icon: Container(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Icon(CupertinoIcons.chat_bubble)),
                activeIcon: Container(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Icon(CupertinoIcons.chat_bubble_fill)),
                label: 'Chats',
                // backgroundColor: Color(0xFFF07191f)
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.blue,
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Icon(CupertinoIcons.phone),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Icon(CupertinoIcons.phone_fill),
                ),

                label: 'Calls',
                // backgroundColor: Color(0xFFF07191f)
              ),
              BottomNavigationBarItem(
                  backgroundColor: Colors.blue,
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Image.asset(
                      'assets/images/cards.png',
                      color: Colors.white,
                      scale: 4,
                    ),
                  ),
                  label: 'Stories',
                  activeIcon: Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Image.asset(
                      'assets/images/cards2.png',
                      color: Colors.white,
                      scale: 4,
                    ),
                  )
                // backgroundColor: Color(0xFFF07191f)
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      width: isSearching ? MediaQuery.of(context).size.width  : 0,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(17)),
        child: TextFormField(
          controller: srchcontroller,

          cursorColor: Colors.white,
          onFieldSubmitted: (_){
            setState(() {
              searchitem = srchcontroller.text;
            });
          },

          onChanged: (_){
            setState(() {
              searchitem = srchcontroller.text;
            });

          },
          onTapOutside: (_) {
            setState(() {
              isSearching == false;

            });
          },
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            iconColor: Colors.white,
            prefixIcon: IconButton(
              color: Colors.white,

              onPressed: (){
                setState(() {


                });
              },
              icon: Icon(Icons.arrow_back_sharp),
            ) ,


            hintText: 'Search',
            hintStyle: TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Color(0xFFF223847),
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}











































class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {






  void addToRequestList(String userId, String nameToAdd) {
    print('reaced');
    final firestoreInstance = FirebaseFirestore.instance;
    final documentReference = firestoreInstance.collection('users').doc(userId);

    documentReference.get().then((documentSnapshot) {
      if (documentSnapshot.exists) {
        documentReference.update({
          'requestlist': FieldValue.arrayUnion([nameToAdd])
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













  bool reqsent = false;






  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [










        FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection('users')
              .where('name', isEqualTo: searchitem)
              .get(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              // return  Center(child: Container(
              //     margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.03),
              //
              //     child:StaggeredDotsWave(size: MediaQuery.of(context).size.height*0.08, color: Colors.white,)));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Container(
                  margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.03),
                  child: Text('No User Found!',style: TextStyle(color: Colors.grey,fontSize: MediaQuery.of(context).size.height*0.02))));
            }

            var document = snapshot.data!.docs[0];
            var data = document.data();
            var title = data['name'];
            var idtosendreq = data['id'];
            var subtitle = data['email'];
            print(title);

            String userName = data['name'] ?? '';
            String profile = data['profilephotopath'] ?? '';
            String id = data['id'];
            var chatlist = data['chatlist'];
            var isfriend= false;

            if(chatlist!= null){
              isfriend  = chatlist.any((element){
                return userid == element;
              });

            }


            print(chatlist);
            return idtosendreq==userid?Container(child:Center(child: Container(
                margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.03),
                child: Text('No User Found!',style: TextStyle(color: Colors.grey,fontSize: MediaQuery.of(context).size.height*0.02))))
            ):ListTile(


              trailing: isfriend? ElevatedButton(onPressed: (){}, child: Text('Following',style: TextStyle(color: Colors.white),)): IconButton(
                icon: reqsent==true?Icon(Icons.done_all,color: Colors.greenAccent,):Icon(CupertinoIcons.person_add,color: Colors.greenAccent,),
                onPressed: (){


                  if(reqsent==false){
                    print(idtosendreq);
                    print(userid);
                    addToRequestList(idtosendreq, userid);

                    setState(() {
                      reqsent=true;
                    });
                  }


                },
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
        )










      ],),
    );
  }
}

