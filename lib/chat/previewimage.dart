import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../main.dart';

var fileName;


class ImagePreviewScreen extends StatefulWidget {
  final File image;
  final otheruid;

  ImagePreviewScreen({required this.image, required this.otheruid});

  @override
  State<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  TextEditingController caption = TextEditingController();







var imageURL;




  Future<void> uploadImageToFirebaseStorage( File imageFile) async {
    // Create a Firebase Storage reference
    Reference storageRef = FirebaseStorage.instance.ref();

    // Create the folder name by concatenating the user IDs
    String folderName = '${userid}_${widget.otheruid}';

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




    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      double progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
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
    // Print the download URL
    print('Download URL: $downloadURL');
  }






















  void addSenderMessage() async{






    String documentId = '${userid}_${widget.otheruid}';
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
    Map<String, dynamic> mapEntryData = {
      'message': '##imgload',
      'filename': fileName,
      'receiverId': widget.otheruid,
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




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.close_rounded),onPressed: (){Navigator.of(context).pop();},),
        title: Text(
          'Image Preview',
          style: TextStyle(fontSize: 20),
        ),
        toolbarHeight: MediaQuery.of(context).size.height * 0.08,
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        // height: MediaQuery.of(context).size.height - kToolbarHeight,
        child: Stack(
          children: [
            Center(child: Image.file(widget.image,fit: BoxFit.fitHeight)),


            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                // margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.08),
                child: Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width * 0.09)),
                        child: TextFormField(
                          controller: caption,
                          cursorColor: Colors.white,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            iconColor: Colors.white,
                            hintText: 'Search',
                            hintStyle: TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Color(0xFFF223847),
                            border: InputBorder.none,
                            prefixIcon: IconButton(icon: Icon(Icons.insert_emoticon_sharp, color: Colors.white), onPressed: () {}),
                            suffixIcon: IconButton(icon: Icon(Icons.camera_alt_outlined, color: Colors.white), onPressed: () {}),
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    FloatingActionButton(
                      backgroundColor: Colors.deepPurpleAccent,
                      onPressed: () {
// addSenderMessage();
// uploadImageToFirebaseStorage(widget.image);
// print(imageURL);

Navigator.pop(context, 'yes');
},
                      child: Icon(Icons.send, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
