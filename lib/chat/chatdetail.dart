import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:split_view/split_view.dart';
import 'package:transparent_image/transparent_image.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:xy/chat/previewimage.dart';




import '../main.dart';
import '../progressindi.dart';
import 'Chat.dart';
import 'canvas.dart';
import 'music.dart';
String drafttext  ='';

class ChatDetail extends StatefulWidget {
  final id;
  final name;
  final profile;

  ChatDetail(this.id,this.name,this.profile);

  @override
  State<ChatDetail> createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {


  Future<List<Map<String, dynamic>>>? _futureData;

  var otherid;

  var id;

  var nextid;
  bool isTextEmpty = true;



var readstatus=false;

  TextEditingController msg = TextEditingController();


  String? _filePath;

  @override
  void dispose() {
    msg.dispose();
    _cameraController.dispose();


    super.dispose();
  }


  late ImagePicker _imagePicker;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _futureData = getAllDataFromCollection('chats');
    id = userid;
    print(id);
    otherid= widget.id;



    _imagePicker = ImagePicker();

    _initializeCamera();





  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getDataFromFirestore() {
    // Replace 'your_collection' and 'your_document_id' with the appropriate values
    return FirebaseFirestore.instance
        .collection('chats')
        .doc('${userid}_${widget.id}')
        .get();
  }




// Check if the text in the controller contains only an emoji
  // Check if the text contains only emojis
  // Check if the text contains exactly one emoji
  bool containsOneEmoji(String text) {
    final RegExp regex = RegExp(
      r'^('
      r'\p{Extended_Pictographic}'
      r'|[\u0023-\u0039]\ufe0f?\u20e3' // Numbers and keycap emoji
      r'|[\ud83c\udde6-\ud83c\uddff]' // Flag emoji
      r'|[\ud83d\udc00-\ud83d\udfff]' // Various emoticons
      r'|[\ud83e\udd10-\ud83e\udd3e]' // Additional emoticons
      r')+$',
      unicode: true,
    );
    return regex.hasMatch(text);
  }







  void addSenderMessage() async{






    String documentId = '${userid}_${widget.id}';



// Retrieve the document reference
    DocumentReference documentRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(documentId);

// Generate a unique ID for the new map entry
    String mapEntryId = documentRef
        .collection('messages')
        .doc()
        .id;

// Create the map entry data

    var dc = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
    Map<String, dynamic> mapEntryData = {
      'message': msg.text.trim(),
      'receiverId': widget.id,
      'timestamp': DateTime.now(),
      'senderId': id,
      'messageid': dc



    };

// Add the map entry to Firestore


    await documentRef
        .collection('chats')
        .doc(dc)
        .set(mapEntryData)
        .then((value) {
      print('Map entry added successfully');
    })
        .catchError((error) {
      print('Failed to add map entry: $error');
    });






  }


  Future<void> addReceiverMessage() async {


    String documentId = '${widget.id}_${userid}';

// Retrieve the document reference
    DocumentReference documentRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(documentId);

// Generate a unique ID for the new map entry
    String mapEntryId = documentRef
        .collection('messages')
        .doc()
        .id;

// Create the map entry data

    var dc = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
    Map<String, dynamic> mapEntryData = {
      'message': msg.text.trim(),
      'receiverId': widget.id,
      'timestamp': DateTime.now(),
      'senderId': id,
      'messageid': dc

    };

// Add the map entry to Firestore


    await documentRef
        .collection('chats')
        .doc(dc)
        .set(mapEntryData)
        .then((value) {
      print('Map entry added successfully');
    })
        .catchError((error) {
      print('Failed to add map entry: $error');
    });
  }


  Stream<QuerySnapshot<Map<String, dynamic>>> messageStream() {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc('${userid}_${widget.id}')
        .collection('chats')
        .orderBy(
        'timestamp', descending: true) // Optional: Order messages by timestamp
        .snapshots();
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> messagereadstream() {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc('${widget.id}_${userid}')
        .collection('messages')
        .snapshots();
  }








  void updateTypingStatus(bool isTyping) {
    final chatCollection = FirebaseFirestore.instance
        .collection('chats')
        .doc('${widget.id}_${userid}')
        .collection('chats');

    // Update the typing status field in the document
    chatCollection.doc('typingStatus').set({
      'isTyping': isTyping,
    });
  }


  Stream<DocumentSnapshot<Map<String, dynamic>>> otherusertypingStatusStream() {
    final chatCollection = FirebaseFirestore.instance
        .collection('chats')
        .doc('${userid}_${widget.id}')
        .collection('chats');

    return chatCollection.doc('typingStatus').snapshots();
  }














  void updateReadStatus(bool readornot) {
    final chatCollection = FirebaseFirestore.instance
        .collection('chats')
        .doc('${widget.id}_${userid}')
        .collection('chats');

    // Update the typing status field in the document
    chatCollection.doc('typingStatus').set({
      'readstats': readornot,
    });
  }



  Stream<DocumentSnapshot<Map<String, dynamic>>> readStatusStream() {
    final chatCollection = FirebaseFirestore.instance
        .collection('chats')
        .doc('${userid}_${widget.id}')
        .collection('chats');

    return chatCollection.doc('readstatus').snapshots();
  }







  Stream<String> fetchVariable() {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc('${userid}_${widget.id}')
        .snapshots()
        .map((snapshot) => snapshot.data()!['read'] as String);
  }





  Future<void> deleteMessageforme(String messageId) async {
    try {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc('${userid}_${widget.id}')
          .collection('chats')
          .doc(messageId)
          .delete();
      print('Message deleted successfully');
    } catch (error) {
      print('Error deleting message: $error');
    }
  }

  Future<void> deleteMessageforEveryone(String messageId) async {
    try {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc('${userid}_${widget.id}')
          .collection('chats')
          .doc(messageId)
          .delete();

      await FirebaseFirestore.instance
          .collection('chats')
          .doc('${widget.id}_${userid}')
          .collection('chats')
          .doc(messageId)
          .delete();
      print('Message deleted successfully');
    } catch (error) {
      print('Error deleting message: $error');
    }


  }















  Future<void> readmsg() async {



    // String documentId = generateDocumentId(email);

    DocumentReference users = FirebaseFirestore.instance.collection('chats').doc('${widget.id}_${userid}');
    // documentId = users.id;
    // userid = documentId;
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString('userid', documentId);


    // print(_drivelink);
    // Call the user's CollectionReference to add a new user
    return users
        .set({
      'read': 'yes',


    })
        .then((value) => print("read "))
        .catchError((error) => print("Failed to read: $error"));

  }






  Future<void> unreadmsg() async {



    // String documentId = generateDocumentId(email);

    DocumentReference users = FirebaseFirestore.instance.collection('chats').doc('${widget.id}_${userid}');
    // documentId = users.id;
    // userid = documentId;
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString('userid', documentId);


    // print(_drivelink);
    // Call the user's CollectionReference to add a new user
    return users
        .set({
      'read': 'no',


    })
        .then((value) => print("unread "))
        .catchError((error) => print("Failed to read: $error"));

  }



  var currUser;



  String convertTimestampToTime(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    DateFormat outputFormat = DateFormat("HH:mm");
    String formattedTime = outputFormat.format(dateTime);
    return formattedTime;
  }






  var longpresscolor = false;


  Color longpress(){

      return Colors.lightGreen;



  }



  bool isMessageLongPressed = false;
  String selectedMessage = '';
  bool typing =false;








bool extrasvisbible = false;


  var msgid;




  void addTochatList(String userId, String idToAdd) {
    final firestoreInstance = FirebaseFirestore.instance;
    final documentReference = firestoreInstance.collection('users').doc(userId);

    documentReference.get().then((documentSnapshot) {
      if (documentSnapshot.exists) {
        List<dynamic>? chatList = documentSnapshot.data()?['chatlist'];
        if (chatList != null) {
          if (chatList.contains(idToAdd)) {
            chatList.remove(idToAdd);
          }
          chatList.insert(0, idToAdd);
        } else {
          chatList = [idToAdd];
        }

        documentReference.update({
          'chatlist': chatList,
        }).then((_) {
          print('ID added to the beginning of the chatlist array');
        }).catchError((error) {
          print('Error adding ID to the chatlist array: $error');
        });
      } else {
        documentReference.set({
          'chatlist': [idToAdd],
        }).then((_) {
          print('Document created with the chatlist array containing the ID');
        }).catchError((error) {
          print('Error creating document with the chatlist array: $error');
        });
      }
    }).catchError((error) {
      print('Error checking if document exists: $error');
    });
  }






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
          'contactlist': [nameToAdd]
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











  void updateChangeMadeField(String userId) {
    final firestoreInstance = FirebaseFirestore.instance;
    final documentReference = firestoreInstance.collection('users').doc(userId);

    documentReference.get().then((documentSnapshot) {
      if (documentSnapshot.exists) {
        documentReference.update({
          'changemade': FieldValue.serverTimestamp(),
        }).then((_) {
          print('changemade field updated');
        }).catchError((error) {
          print('Error updating changemade field: $error');
        });
      } else {
        documentReference.set({
          'changemade': FieldValue.serverTimestamp(),
        }).then((_) {
          print('changemade field created');
        }).catchError((error) {
          print('Error creating changemade field: $error');
        });
      }
    }).catchError((error) {
      print('Error checking if document exists: $error');
    });
  }






var isCurrentUser;

  var copytext;








  Future<void> copttexttoclipboard(String messageId) async {
    try {
      var txt = await FirebaseFirestore.instance
          .collection('chats')
          .doc('${userid}_${widget.id}')
          .collection('chats')
          .doc(messageId)
          .get();



      var text = txt['message'];

      // var text = message['message'];

      // Copy the text to the clipboard
      Clipboard.setData(ClipboardData(text: text));

      // This will fail because the argument type is 'String?'
      // copyTextToClipboard(null);


      print('Message copied successfully');
    } catch (error) {
      print('Error deleting message: $error');
    }


  }











  late File? _image;





var imageurl;
var loadingimage;
  var getImage;
  var progress;

  late CameraDescription _frontCamera;
  late CameraController _cameraController;



  void _initializeCamera() async {
    final cameras = await availableCameras();
    _frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    _cameraController = CameraController(
      _frontCamera,
      ResolutionPreset.medium,
    );

    await _cameraController.initialize(); // Initialize the camera controller
  }

  void _handlePhotoSaved(String filePath) {
    print('Photo saved: $filePath');
    // You can perform additional actions with the photo file path
  }



  Future<void> _openCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });

      // Navigate to the preview screen


      getImage =await Navigator.push<String?>(
        context,
        MaterialPageRoute(builder: (context) => ImagePreviewScreen(image: _image!,otheruid: widget.id,)),
      );

      print(getImage);

      if(getImage=='yes'){

        setState(() {

          uploadImageToFirebaseStorage(_image!);
          loadingimage=_image;
          // getImage=='No';

        });

      }

      // setState(() {
      //   imageurl=imageUrl;
      // });
    }
  }




  var imageURL;





  Future<void> uploadImageToFirebaseStorage( File imageFile) async {
    // Create a Firebase Storage reference
    Reference storageRef = FirebaseStorage.instance.ref();

    // Create the folder name by concatenating the user IDs
    String folderName = '${userid}_${widget.id}';

    // Check if the folder already exists
    firebase_storage.ListResult listResult = await storageRef.child(folderName).listAll();
    bool folderExists = listResult.items.isNotEmpty;

    // If the folder doesn't exist, create it
    if (!folderExists) {
      await storageRef.child(folderName).putString('');
    }

    // Get the image file name
    fileName = imageFile.path.split('/').last;

    // Upload the image file to the folder
    firebase_storage.UploadTask uploadTask = storageRef.child('$folderName/$fileName').putFile(imageFile);

    addSenderImage();


    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {

      setState(() {

      progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
      });
      print('Upload progress: $progress%');
    }, onError: (Object error) {
      print('Upload error: $error');
    });

    await uploadTask.whenComplete(() {
      print('Upload complete');
    });

    // Wait for the upload to complete
    await uploadTask.whenComplete(() => print('Image uploaded'));

    // Get the download URL of the uploaded image
    String downloadURL = await storageRef.child('$folderName/$fileName').getDownloadURL();
    imageURL = downloadURL;
    updateImageURL();
    addReceiverImage(downloadURL);
    // Print the download URL
    print('Download URL: $downloadURL');
  }








var docid;

  void addSenderImage() async{






    String documentId = '${userid}_${widget.id}';
    print(documentId);

// Retrieve the document reference
    DocumentReference documentRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(documentId);

// Generate a unique ID for the new map entry
    String mapEntryId = documentRef
        .collection('messages')
        .doc()
        .id;

// Create the map entry data

    var dc = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();

    docid=dc;
    Map<String, dynamic> mapEntryData = {
      'message': '##imgload',
      // 'imageURL' : imageURL,
      'filename': fileName.toString(),
      'receiverId': widget.id,
      'timestamp': DateTime.now(),
      'senderId': userid,
      'messageid': dc



    };

// Add the map entry to Firestore


    await documentRef
        .collection('chats')
        .doc(dc)
        .set(mapEntryData)
        .then((value) {
      print('Map entry added successfully');
    })
        .catchError((error) {
      print('Failed to add map entry: $error');
    });






  }











  void addReceiverImage(String urli) async{






    String documentId = '${widget.id}_${userid}';
    print(documentId);

// Retrieve the document reference
    DocumentReference documentRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(documentId);

// Generate a unique ID for the new map entry
    String mapEntryId = documentRef
        .collection('messages')
        .doc()
        .id;

// Create the map entry data

    var dc = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();

    docid=dc;
    Map<String, dynamic> mapEntryData = {
      'message': 'url',
      'imageURL' :urli,
      'filename': fileName.toString(),
      'receiverId': widget.id,
      'timestamp': DateTime.now(),
      'senderId': userid,
      'messageid': dc



    };

// Add the map entry to Firestore


    await documentRef
        .collection('chats')
        .doc(dc)
        .set(mapEntryData)
        .then((value) {
      print('Map entry added successfully');
    })
        .catchError((error) {
      print('Failed to add map entry: $error');
    });






  }




  void updateImageURL() async{






    String documentId = '${userid}_${widget.id}';
    print(documentId);

// Retrieve the document reference
    DocumentReference documentRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(documentId);

// Generate a unique ID for the new map entry
    String mapEntryId = documentRef
        .collection('messages')
        .doc(docid)
        .id;

// Create the map entry data


    Map<String, dynamic> mapEntryData = {
      'imageURL' : imageURL,
      'message' : 'url'




    };

// Add the map entry to Firestore


    await documentRef
        .collection('chats')
        .doc(docid)
        .update(mapEntryData)
        .then((value) {
      print('Map entry added successfully');
    })
        .catchError((error) {
      print('Failed to add map entry: $error');
    });






  }


















var emdon=false;
  void _toggleSwitch(bool value) {
    setState(() {
      emdon = value;
    });
  }




























  // var imageurl;
  var emotionloadingimage;
  // var getImage;
  // var progress;

  Future<void> _emotionCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      setState(() {
       emotionloadingimage = File(pickedImage.path);
      });


    }
  }












  @override
  Widget build(BuildContext context) {
    print(widget.id);
    print('${userid}_${widget.id}');
    readmsg();

    var alignment;


    Future<void> _refreshData() async {
      // Perform a refresh operation here, such as fetching new data from an API.
      await Future.delayed(Duration(seconds: 2));
      setState(() {
        _futureData;
      });
    }


    var ca;




    return WillPopScope(
      onWillPop: () async {
        if (isMessageLongPressed) {
          setState(() {
            isMessageLongPressed = false;
            selectedMessage = '';
          });
          return false; // Prevent back navigation
        }
        return true; // Allow back navigation
      },
      child: GestureDetector(
        onTap: () {
          setState(() {
            isMessageLongPressed = false;
            selectedMessage = '';
          });
        },
        child: Scaffold(
            appBar: AppBar(

              toolbarHeight: MediaQuery.of(context).size.height*0.08,
              titleSpacing: 0,
              backgroundColor: Color(0xFFF223847),
              leading: IconButton(icon: Icon(CupertinoIcons.arrow_left,color: Colors.white,),onPressed: (){Navigator.pop(context);},),
              title: isMessageLongPressed
                  ? null :Row(
                children: [
                  Container(
                    margin: EdgeInsets.all(7),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(60)),
                      child: GestureDetector(
                        onTap: (){
                          // Navigator.pushNamed(context, '/profilephoto');
                        },
                        child: Container(
                            padding: EdgeInsets.all(15),
                            // color: Colors.greenAccent,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: widget.profile==''?Color(0xFFF161f1d):Colors.greenAccent,
                            ),
                            child: Image.asset(widget.profile==''?'assets/images/noprofile.png':widget.profile,height: MediaQuery.of(context).devicePixelRatio*10,color:                widget.profile == '' ?Colors.white:null,
                                )),
                      ),
                    ),
                  ),
                  Expanded(child: Text(widget.name, style: TextStyle(color: Colors.white),overflow: TextOverflow.fade,)),

                ],
              ),

              actions: isMessageLongPressed
              ? [
              IconButton(
                icon: Icon(Icons.copy_sharp),
                onPressed: () {
                  // Handle copy action
                  copttexttoclipboard(msgid);



                },
              ),
              IconButton(
                icon: Icon(CupertinoIcons.delete),
                onPressed: () {














                  showDialog(
                  context: context,

                  builder: (context) {
                  return AlertDialog(


                  backgroundColor:  Color(0xFFF223847),
                  // backgroundColor: Color(0xFFF062121),
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
                  title: Text(
                  'Delete message?',
                  style: TextStyle(color: Colors.white),
                  ),
                  icon: Icon(
                  Icons.delete_outline,
                  color: Colors.white,
                  ),

                  content: IntrinsicHeight(
                    child: Column(
                    // mainAxisAlignmenrt: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(onPressed: (){
                        deleteMessageforme(msgid);
                        Navigator.of(context).pop();



                      }, child: Text('Delete for me')),







                      TextButton(onPressed: (){
                        deleteMessageforEveryone(msgid);

                        Navigator.of(context).pop();


                      }, child: Text('Delete for Everyone')),
                      // TextButton(onPressed: (){}, child: Text('Delete for me')),

                    ],
                    ),
                  ),
                  );
                  });
















                },
              ),


              IconButton(
                icon: Icon(CupertinoIcons.arrowshape_turn_up_right),
                onPressed: () {
                  // Handle forward action
                },
              ),
              ]:[
                IconButton(icon: Icon(Icons.videocam_outlined,color: Colors.white, ),onPressed: (){
                  // Navigator.push(context, CupertinoPageRoute(builder: (context){
                  //   return CameraScreen();
                  // }));

                },),
                IconButton(icon: Icon(CupertinoIcons.phone,color: Colors.white,),onPressed: (){

                },),
                splitscrcanva==true?IconButton(icon: Icon(Icons.close_fullscreen_outlined,color: Colors.white,),onPressed: (){
    setState(() {

    splitscrcanva =false;
    });

                },):SizedBox(),
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
                value: 'Emotion Dectector',
                child:

                Row(

                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Text('EMD  '),

                  Switch(
                      value: emdon, onChanged: (_){
                    setState(){
                      emdon=!emdon;
                    };
                  })
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'Canvas',
                child:
                Text('Canvas', style: TextStyle(color: Colors.white)),
              ),

              PopupMenuItem(
                value: 'Music',
                child:
                Text('Music', style: TextStyle(color: Colors.white)),
              ),
            ];
          },

          onSelected: (value) {


            // Handle the selected option


            if(value=='Canvas'){
              setState(() {

                splitscrcanva =false;
              });



              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CanvasScreen( widget.id,widget.name,widget.profile)),

              );


            }
            else if(value=='Music'){

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Music( widget.id,widget.name,widget.profile)),

              );



            }







          },
        )


              ],



            ),
            body:


            // FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            //   future: getDataFromFirestore(),
            //   builder: (context, snapshot) {
            //     if (snapshot.hasData) {
            //       final data = snapshot.data!.data();
            //       // final name = data!['name'];
            //       // final email = data['email'];
            //       final content = data!['message'];
            //       final senderId = data!['senderId'];
            //
            //       final isCurrentUser = senderId == id;
            //       final alignment = isCurrentUser ? Alignment.bottomLeft: Alignment.bottomRight;
            //
            //       // selectedphoto = profile;

            splitscrcanva==true?SplitView(



              viewMode:SplitViewMode.Vertical,
              indicator: Icon(Icons.drag_handle,color: Colors.orangeAccent,),
              activeIndicator:  Icon(Icons.swipe_up_outlined,color: Colors.white,),
              gripColor: Color(0xFFF223847),
              gripColorActive: Colors.white10,

              // gripSize: 0.0,




              children: [

                CanvasScreen(widget.id,widget.name,widget.profile),

                GestureDetector(

                  onTap: () {
                    setState(() {
                      isMessageLongPressed = false;
                      selectedMessage = '';
                    });
                  },
                  child: Container(
                    // decoration: BoxDecoration(
                    //   image: DecorationImage(
                    //     image: AssetImage('assets/images/back.jpg')
                    //
                    //
                    //   )
                    // ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,

                      children: [



                        Expanded(
                          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                            stream: messageStream(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                // return Container(); // Display a loading indicator while waiting for data
                              }
                              if (snapshot.hasError) {
                                print('Error: ${snapshot.error}');
                              }
                              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                return SizedBox();
                              }
                              return
                                // ListView.builder(
                                // reverse: true, // Reverse the order of messages to display the latest at the bottom
                                // itemCount: snapshot.data!.docs.length,
                                // itemBuilder: (BuildContext context, int index) {
                                //   var message = snapshot.data!.docs[index].data();
                                Container(
                                  width: double.infinity,
                                  // margin: EdgeInsets.only(top: 10),


                                  // padding: EdgeInsets.zero,
                                  child: ListView.builder(




                                    shrinkWrap: true,

                                    // itemExtent: 45,
                                    reverse: true,
                                    // Reverse the order of messages to display the latest at the bottom
                                    itemCount: snapshot.data?.docs.length ,
                                    itemBuilder: (BuildContext context, int index) {


                                      var message = snapshot.data!.docs[index].data();

                                      final isLastMessage = index == (snapshot.data!.docs.length );

                                      final lastMessage = snapshot.data!.docs.first.data()['message'];
                                      final lastMessagetime = snapshot.data!.docs.first.data()['timestamp'];





                                      final content = message!['message'];
                                            final senderId = message!['senderId'];
                                            final receiverId = message!['receiverId'];
                                            final time = message['timestamp'];
                                            late var url = message['imageURL'];
                                            final flenme = message['filename'];
                                      // Text(message['message'])


                                        isCurrentUser = senderId == id;



                                      currUser = isCurrentUser;
                                      // final chatlistid = senderId == userid?
                                      alignment = isCurrentUser ? Alignment.bottomRight: Alignment.bottomLeft;


                                      double maxLength = 120; // Maximum length of the message
                                      double scalingFactor = 0.9; // Scaling factor for adjusting the border radius

                                      double borderRadius = maxLength - content.length * scalingFactor;
                                      borderRadius = borderRadius.clamp(0.0, double.infinity);


                                      return GestureDetector(

                                        onLongPress: (){
                                          setState(() {
                                            isMessageLongPressed = true;
                                            selectedMessage = message['message'];
                                            msgid = message['messageid'];



                                          });
                                        },


                                        onTapCancel: (){
                                          setState(() {
                                            isMessageLongPressed = false;
                                            selectedMessage = message['message'];
                                          });

                                        },
                                        child: Container(

                                          color:      isMessageLongPressed ? msgid==message['messageid'] ?Color(0xFFF223847):null:null,


                                          child: Align(
                                              alignment: alignment,


                                              child: message['message']=='##imgload'?
                                                  Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 1,vertical: 7),
                                                    // margin: EdgeInsets.symmetric(horizontal: 12,vertical: 2),
                                                    child: Stack(children: [
                                                      ClipRRect(
                                                        borderRadius: BorderRadius.circular(17),

                                                        child: Image.file(_image!,
                                                          height:MediaQuery.of(context).size.height*0.2,
                                                          width: MediaQuery.of(context).size.height*0.15,
                                                        ),
                                                      ),
                                                      Text(progress.toString(),style: TextStyle(color: Colors.white),)
                                                    ],),
                                                  )
                                                  :
                                              message['message']=='url'?Container(
                                                padding: EdgeInsets.symmetric(horizontal: 15,vertical: 7),
                                                margin: EdgeInsets.symmetric(horizontal: 12,vertical: 2),
                                                child: ClipRRect(
                                                                   borderRadius: BorderRadius.circular(17)
                                            ,
                                                  child: CachedNetworkImage(

                                                    height:MediaQuery.of(context).size.height*0.2,
                                                    width: MediaQuery.of(context).size.height*0.15,

                                                    placeholder: (context, url) => CircularProgressIndicator(),
                                                    imageUrl: url
                                                    ,
                                                    errorWidget: (context, url, error) => Icon(Icons.error),

                                                  ),
                                                ),
                                              ):
                                              containsOneEmoji(message['message'])?
                                              GestureDetector(
                                                onLongPress: (){
                                                  setState(() {
                                                    longpresscolor = !longpresscolor;
                                                  });

                                                },
                                                child:



                                              Container(


                                                    padding: EdgeInsets.symmetric(horizontal: 15,vertical: 7),
                                                    margin: EdgeInsets.symmetric(horizontal: 12,vertical: 2),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Container(
                                                            margin: EdgeInsets.only(right:25),

                                                            child: Text(message['message'],style: TextStyle(color: isCurrentUser? Colors.white: Colors.black,fontSize: 38))),
                                                     Container(

                                                         child: Text('${convertTimestampToTime(time)}  ',style: TextStyle(color: isCurrentUser? Colors.white: Colors.black,fontSize: 9),))

                                                ],
                                                    )),
                                              ): Column(
                                                children: [


                                                  Container(


                                                    padding: EdgeInsets.symmetric(horizontal: 15,vertical: 7),
                                                    margin: EdgeInsets.symmetric(horizontal: 12,vertical: 2),

                                                    constraints: BoxConstraints(
                                                      maxWidth: MediaQuery.of(context).size.width*0.7,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:  BorderRadius.all(Radius.circular(17)),

                                                    color: isCurrentUser? Colors.deepPurpleAccent: Colors.greenAccent,


                                                    ),


                                                    child: IntrinsicWidth(
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,



                                                        children: [
                                                          Expanded(
                                                            child: Column(

                                                              crossAxisAlignment: CrossAxisAlignment.end,


                                                              children: [




                                                                Container(
                                                                  margin: EdgeInsets.only(right:25),
                                                                  child: Text(message['message'],style: TextStyle(color: isCurrentUser? Colors.white: Colors.black,fontSize: 13),
                                                                    overflow: TextOverflow.visible,
                                                                    maxLines: null,
                                                                    softWrap: true,
                                                                  ),
                                                                ),

                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                  children: [
                                                                    Align(
                                                                        alignment: Alignment.bottomRight,
                                                                        child: Text('${convertTimestampToTime(time)}  ',style: TextStyle(color: isCurrentUser? Colors.white: Colors.black,fontSize: 9),)),






                                                                    isCurrentUser?
                                                                    StreamBuilder<String>(
                                                                      stream: fetchVariable(),
                                                                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                                                        }
                                                                        if (snapshot.hasError) {
                                                                         print('Error: ${snapshot.error}');
                                                                        }
                                                                        if (!snapshot.hasData || snapshot.data == null ) {
                                                                          // return Center(child: StaggeredDotsWave(color: Colors.white, size:  MediaQuery.of(context).size.height*0.09 ));
                                                                       return SizedBox();
                                                                        }

                                                                        final variableValue = snapshot.data;

                                                                        return   lastMessage==message['message']? lastMessagetime==message['timestamp']? variableValue=='yes'?Icon(Icons.check_circle,color: Colors.white,size: 9,):Icon(CupertinoIcons.checkmark_alt_circle,color: Colors.grey,size: 9,):Container():Container()
                                                                        ;
                                                                      },
                                                                    ): Container()

                                                                  ],
                                                                ),




























                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ),
                                      );
                                    },
                                  ),
                                );


                              //   ListTile(
                              //   title: Text(message['message']),
                              //   subtitle: Text(message['timestamp'].toString()),
                              //   // Display other message details as needed
                              // );
                            },
                          ),
                        ),





                               // Align(
                               //   child: getImage=='yes'?Stack(
                               //     children: [
                               //       SizedBox(
                               //           height:MediaQuery.of(context).size.height*0.2,
                               //           width: MediaQuery.of(context).size.height*0.15,
                               //           child: Image.file(loadingimage,fit: BoxFit.cover,)),
                               //       Text(progress.toString(),style: TextStyle(color: Colors.white),),
                               //     ],
                               //   ):Container(),
                               // ),






                        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                          stream: otherusertypingStatusStream(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return SizedBox(); // Show a placeholder or loading indicator while waiting for data
                            }

                            if (!snapshot.hasData || !snapshot.data!.exists) {
                              return SizedBox(); // Handle the case when the document doesn't exist
                            }

                            var data = snapshot.data!.data();
                            var typingStatus2 = data!['isTyping'] ?? false; // Set default value to false if the field doesn't exist
                            print(typingStatus2);

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  // color: Colors.transparent,
                                  margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
                                  child: Visibility(
                                    visible: typingStatus2,
                                    child: HorizontalRotatingDots(color: Colors.deepPurple, size: MediaQuery.of(context).size.height * 0.05),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),











                        Container(
                          constraints: BoxConstraints(
                              maxHeight:  msg.text.split('\n').length>5? MediaQuery.of(context).size.height*0.15: msg.text.split('\n').length.toDouble()* 15 + MediaQuery.of(context).size.height*0.05
                              // maxHeight: MediaQuery.of(context).size.height*0.3\
                          ),
                          // height: MediaQuery.of(context).size.height*0.1,





                          margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.03,vertical: MediaQuery.of(context).size.height*0.015),
                          child: Row(
                            children: [




                              Expanded(


                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.09)),
                                  child: TextFormField(
                                      controller: msg,
                                      // initialValue: 'Abc',


                                      cursorColor: Colors.white,

                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,

                                      onChanged: (value){
                                        setState(() {
                                          isTextEmpty=false;
                                          isMessageLongPressed = false;
                                          selectedMessage = '';


                                            typing = value.isNotEmpty;

                                            drafttext=value;




                                        });
                                        updateTypingStatus(typing);
                                      },


                                      decoration: InputDecoration(
                                        iconColor: Colors.white,



                                        hintText: 'Search',

                                        hintStyle: TextStyle(color: Colors.grey),
                                        filled: true,
                                        fillColor: Color(0xFFF223847),
                                        border: InputBorder.none,

                                        prefixIcon: IconButton(icon: Icon(Icons.insert_emoticon_sharp,color: Colors.white,),onPressed: (){},),
                                        suffixIcon: msg.text!=''?null:IntrinsicWidth(
                                          child: Row(
                                            children: [
                                              IconButton(icon: Icon(Icons.camera_alt_outlined,color: Colors.white,),onPressed: _openCamera,),
                                              IconButton(icon: Icon(Icons.space_dashboard,color: Colors.white,),onPressed: _emotionCamera,),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [


                                                ],
                                              ),
                                            ],
                                          ),
                                        ),





                                      ),
                                      style: TextStyle(color: Colors.white),
                                      // keyboardAppearance: ,
                                    ),
                                ),
                              ),

                              ElevatedButton(

                                  style: ElevatedButton.styleFrom(
                                    shape: CircleBorder(),
                                    // Use CircleBorder for circular shape
                                    padding: EdgeInsets.all(
                                        0), // Remove default padding
                                    // Customize the button's text color
                                  ),
                                  onPressed: () {

                                      if(msg.text!=''){
                                        addReceiverMessage();
                                        addSenderMessage();
                                        addTochatList(userid, widget.id);
                                        addTochatList(widget.id, userid);
                                        addToContactList(userid, widget.id);
                                        addToContactList(widget.id,userid);

                                        updateChangeMadeField(widget.id);
                                        // updateChangeMadeField(userid);

                                        unreadmsg();
                                        msg.clear();

                                      }
                                      else if(msg.text.isEmpty){
                                        setState(() {
                                          extrasvisbible=!extrasvisbible;
                                        });
                                      }




                                  }, child: Padding(
                                padding: EdgeInsets.all(MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.03),
                                child: Icon(msg.text.isNotEmpty ? Icons.send : Icons.add, color: Colors.white,),
                              ))

                            ],
                          ),
                        ),

                        Visibility(
                            visible: extrasvisbible,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.03),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                              Column(
                                children: [
                                  Card(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),


                                      child: IconButton(onPressed: (){
                                        // _emotionCamera();
                                      },icon: Icon(CupertinoIcons.photo_on_rectangle),)),

                                  Text('Images',style: TextStyle(color: Colors.white),)
                                ],
                              ),
                              Column(
                                children: [
                                  Card(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),

                                      child: IconButton(onPressed: (){},icon: Icon(CupertinoIcons.doc_on_doc),)),
                                  Text('File',style: TextStyle(color: Colors.white),)

                                ],
                              ),
                              Column(
                                children: [
                                  Card(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),

                                      child: IconButton(onPressed: (){},icon: Icon(CupertinoIcons.person_alt_circle),)),
                                  Text('Contacts',style: TextStyle(color: Colors.white),)

                                ],
                              ),
                              Column(
                                children: [
                                  Card(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),

                                      child: IconButton(onPressed: (){},icon: Icon(CupertinoIcons.location_circle),)),
                                  Text('Location',style: TextStyle(color: Colors.white),)

                                ],
                              ),
                          ],
                        ),
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ):














            GestureDetector(

              onTap: () {
                setState(() {
                  isMessageLongPressed = false;
                  selectedMessage = '';
                });
              },
              child: Container(
                // decoration: BoxDecoration(
                //   image: DecorationImage(
                //     image: AssetImage('assets/images/back.jpg')
                //
                //
                //   )
                // ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,

                  children: [



                    Expanded(
                      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: messageStream(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            // return Container(); // Display a loading indicator while waiting for data
                          }
                          if (snapshot.hasError) {
                            print('Error: ${snapshot.error}');
                          }
                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return SizedBox();
                          }
                          return
                            // ListView.builder(
                            // reverse: true, // Reverse the order of messages to display the latest at the bottom
                            // itemCount: snapshot.data!.docs.length,
                            // itemBuilder: (BuildContext context, int index) {
                            //   var message = snapshot.data!.docs[index].data();
                            Container(
                              width: double.infinity,
                              // margin: EdgeInsets.only(top: 10),


                              // padding: EdgeInsets.zero,
                              child: ListView.builder(




                                shrinkWrap: true,

                                // itemExtent: 45,
                                reverse: true,
                                // Reverse the order of messages to display the latest at the bottom
                                itemCount: snapshot.data?.docs.length ,
                                itemBuilder: (BuildContext context, int index) {


                                  var message = snapshot.data!.docs[index].data();

                                  final isLastMessage = index == (snapshot.data!.docs.length );

                                  final lastMessage = snapshot.data!.docs.first.data()['message'];
                                  final lastMessagetime = snapshot.data!.docs.first.data()['timestamp'];





                                  final content = message!['message'];
                                  final senderId = message!['senderId'];
                                  final receiverId = message!['receiverId'];
                                  final time = message['timestamp'];
                                  late var url = message['imageURL'];
                                  final flenme = message['filename'];
                                  // Text(message['message'])


                                  isCurrentUser = senderId == id;



                                  currUser = isCurrentUser;
                                  // final chatlistid = senderId == userid?
                                  alignment = isCurrentUser ? Alignment.bottomRight: Alignment.bottomLeft;


                                  double maxLength = 120; // Maximum length of the message
                                  double scalingFactor = 0.9; // Scaling factor for adjusting the border radius

                                  double borderRadius = maxLength - content.length * scalingFactor;
                                  borderRadius = borderRadius.clamp(0.0, double.infinity);


                                  return GestureDetector(

                                    onLongPress: (){
                                      setState(() {
                                        isMessageLongPressed = true;
                                        selectedMessage = message['message'];
                                        msgid = message['messageid'];



                                      });
                                    },


                                    onTapCancel: (){
                                      setState(() {
                                        isMessageLongPressed = false;
                                        selectedMessage = message['message'];
                                      });

                                    },
                                    child: Container(

                                      color:      isMessageLongPressed ? msgid==message['messageid'] ?Color(0xFFF223847):null:null,


                                      child: Align(
                                          alignment: alignment,


                                          child: message['message']=='##imgload'?
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 1,vertical: 7),
                                            // margin: EdgeInsets.symmetric(horizontal: 12,vertical: 2),
                                            child: Stack(children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(17),

                                                child: Image.file(_image!,
                                                  height:MediaQuery.of(context).size.height*0.2,
                                                  width: MediaQuery.of(context).size.height*0.15,
                                                ),
                                              ),
                                              Text(progress.toString(),style: TextStyle(color: Colors.white),)
                                            ],),
                                          )
                                              :
                                          message['message']=='url'?Container(
                                            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 7),
                                            margin: EdgeInsets.symmetric(horizontal: 12,vertical: 2),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(17)
                                              ,
                                              child: CachedNetworkImage(

                                                height:MediaQuery.of(context).size.height*0.2,
                                                width: MediaQuery.of(context).size.height*0.15,

                                                placeholder: (context, url) => CircularProgressIndicator(),
                                                imageUrl: url
                                                ,
                                                errorWidget: (context, url, error) => Icon(Icons.error),

                                              ),
                                            ),
                                          ):
                                          containsOneEmoji(message['message'])?
                                          GestureDetector(
                                            onLongPress: (){
                                              setState(() {
                                                longpresscolor = !longpresscolor;
                                              });

                                            },
                                            child:



                                            Container(


                                                padding: EdgeInsets.symmetric(horizontal: 15,vertical: 7),
                                                margin: EdgeInsets.symmetric(horizontal: 12,vertical: 2),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                        margin: EdgeInsets.only(right:25),

                                                        child: Text(message['message'],style: TextStyle(color: isCurrentUser? Colors.white: Colors.black,fontSize: 38))),
                                                    Container(

                                                        child: Text('${convertTimestampToTime(time)}  ',style: TextStyle(color: isCurrentUser? Colors.white: Colors.black,fontSize: 9),))

                                                  ],
                                                )),
                                          ): Column(
                                            children: [


                                              Container(


                                                padding: EdgeInsets.symmetric(horizontal: 15,vertical: 7),
                                                margin: EdgeInsets.symmetric(horizontal: 12,vertical: 2),

                                                constraints: BoxConstraints(
                                                  maxWidth: MediaQuery.of(context).size.width*0.7,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:  BorderRadius.all(Radius.circular(17)),

                                                  color: isCurrentUser? Colors.deepPurpleAccent: Colors.greenAccent,


                                                ),


                                                child: IntrinsicWidth(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,



                                                    children: [
                                                      Expanded(
                                                        child: Column(

                                                          crossAxisAlignment: CrossAxisAlignment.end,


                                                          children: [




                                                            Container(
                                                              margin: EdgeInsets.only(right:25),
                                                              child: Text(message['message'],style: TextStyle(color: isCurrentUser? Colors.white: Colors.black,fontSize: 13),
                                                                overflow: TextOverflow.visible,
                                                                maxLines: null,
                                                                softWrap: true,
                                                              ),
                                                            ),

                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                              children: [
                                                                Align(
                                                                    alignment: Alignment.bottomRight,
                                                                    child: Text('${convertTimestampToTime(time)}  ',style: TextStyle(color: isCurrentUser? Colors.white: Colors.black,fontSize: 9),)),






                                                                isCurrentUser?
                                                                StreamBuilder<String>(
                                                                  stream: fetchVariable(),
                                                                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                                                    }
                                                                    if (snapshot.hasError) {
                                                                      print('Error: ${snapshot.error}');
                                                                    }
                                                                    if (!snapshot.hasData || snapshot.data == null ) {
                                                                      // return Center(child: StaggeredDotsWave(color: Colors.white, size:  MediaQuery.of(context).size.height*0.09 ));
                                                                      return SizedBox();
                                                                    }

                                                                    final variableValue = snapshot.data;

                                                                    return   lastMessage==message['message']? lastMessagetime==message['timestamp']? variableValue=='yes'?Icon(Icons.check_circle,color: Colors.white,size: 9,):Icon(CupertinoIcons.checkmark_alt_circle,color: Colors.grey,size: 9,):Container():Container()
                                                                    ;
                                                                  },
                                                                ): Container()

                                                              ],
                                                            ),




























                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )),
                                    ),
                                  );
                                },
                              ),
                            );


                          //   ListTile(
                          //   title: Text(message['message']),
                          //   subtitle: Text(message['timestamp'].toString()),
                          //   // Display other message details as needed
                          // );
                        },
                      ),
                    ),





                    // Align(
                    //   child: getImage=='yes'?Stack(
                    //     children: [
                    //       SizedBox(
                    //           height:MediaQuery.of(context).size.height*0.2,
                    //           width: MediaQuery.of(context).size.height*0.15,
                    //           child: Image.file(loadingimage,fit: BoxFit.cover,)),
                    //       Text(progress.toString(),style: TextStyle(color: Colors.white),),
                    //     ],
                    //   ):Container(),
                    // ),






                    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: otherusertypingStatusStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return SizedBox(); // Show a placeholder or loading indicator while waiting for data
                        }

                        if (!snapshot.hasData || !snapshot.data!.exists) {
                          return SizedBox(); // Handle the case when the document doesn't exist
                        }

                        var data = snapshot.data!.data();
                        var typingStatus2 = data!['isTyping'] ?? false; // Set default value to false if the field doesn't exist
                        print(typingStatus2);

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              // color: Colors.transparent,
                              margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
                              child: Visibility(
                                visible: typingStatus2,
                                child: HorizontalRotatingDots(color: Colors.deepPurple, size: MediaQuery.of(context).size.height * 0.05),
                              ),
                            ),
                          ],
                        );
                      },
                    ),











                    Container(
                      constraints: BoxConstraints( maxHeight:  msg.text.split('\n').length>5? MediaQuery.of(context).size.height*0.15: msg.text.split('\n').length.toDouble()* 15 + MediaQuery.of(context).size.height*0.05),
                      // height: MediaQuery.of(context).size.height*0.1,





                      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.03,vertical: MediaQuery.of(context).size.height*0.015),
                      child: Row(
                        children: [




                          Expanded(


                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.09)),
                              child: TextFormField(
                                controller: msg,
                                // initialValue: 'Abc',


                                cursorColor: Colors.white,

                                keyboardType: TextInputType.multiline,
                                maxLines: null,

                                onChanged: (value){
                                  setState(() {
                                    isTextEmpty=false;
                                    isMessageLongPressed = false;
                                    selectedMessage = '';


                                    typing = value.isNotEmpty;

                                    drafttext=value;




                                  });
                                  updateTypingStatus(typing);
                                },


                                decoration: InputDecoration(
                                  iconColor: Colors.white,



                                  hintText: 'Search',

                                  hintStyle: TextStyle(color: Colors.grey),
                                  filled: true,
                                  fillColor: Color(0xFFF223847),
                                  border: InputBorder.none,

                                  prefixIcon: IconButton(icon: Icon(Icons.insert_emoticon_sharp,color: Colors.white,),onPressed: (){},),
                                  suffixIcon: msg.text!=''?null:IntrinsicWidth(
                                    child: Row(
                                      children: [
                                        IconButton(icon: Icon(Icons.camera_alt_outlined,color: Colors.white,),onPressed: _openCamera,),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [


                                          ],
                                        ),
                                      ],
                                    ),
                                  ),





                                ),
                                style: TextStyle(color: Colors.white),
                                // keyboardAppearance: ,
                              ),
                            ),
                          ),

                          ElevatedButton(

                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                // Use CircleBorder for circular shape
                                padding: EdgeInsets.all(
                                    0), // Remove default padding
                                // Customize the button's text color
                              ),
                              onPressed: () {

                                if(msg.text!=''){
                                  addReceiverMessage();
                                  addSenderMessage();
                                  addTochatList(userid, widget.id);
                                  addTochatList(widget.id, userid);
                                  addToContactList(userid, widget.id);
                                  addToContactList(widget.id,userid);

                                  updateChangeMadeField(widget.id);
                                  // updateChangeMadeField(userid);

                                  unreadmsg();
                                  msg.clear();

                                }
                                else if(msg.text.isEmpty){
                                  setState(() {
                                    extrasvisbible=!extrasvisbible;
                                  });
                                }




                              }, child: Padding(
                            padding: EdgeInsets.all(MediaQuery
                                .of(context)
                                .size
                                .width * 0.03),
                            child: Icon(msg.text.isNotEmpty ? Icons.send : Icons.add, color: Colors.white,),
                          ))

                        ],
                      ),
                    ),

                    Visibility(
                        visible: extrasvisbible,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.03),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Card(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),


                                      child: IconButton(onPressed: (){},icon: Icon(CupertinoIcons.photo_on_rectangle),)),

                                  Text('Images',style: TextStyle(color: Colors.white),)
                                ],
                              ),
                              Column(
                                children: [
                                  Card(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),

                                      child: IconButton(onPressed: (){},icon: Icon(CupertinoIcons.doc_on_doc),)),
                                  Text('File',style: TextStyle(color: Colors.white),)

                                ],
                              ),
                              Column(
                                children: [
                                  Card(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),

                                      child: IconButton(onPressed: (){},icon: Icon(CupertinoIcons.person_alt_circle),)),
                                  Text('Contact',style: TextStyle(color: Colors.white),)

                                ],
                              ),
                              Column(
                                children: [
                                  Card(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),

                                      child: IconButton(onPressed: (){},icon: Icon(CupertinoIcons.location_circle),)),
                                  Text('Location',style: TextStyle(color: Colors.white),)

                                ],
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),

        ),
      ),
    );
  }


}


