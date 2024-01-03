// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:path_provider/path_provider.dart';
//
// import '../main.dart';
// var imagepath2;
// late CameraController _controller;
//
// void _openCameraScreen(BuildContext context, CameraDescription camera) {
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) => CameraApp(camera: camera),
//     ),
//   );
// }
//
//
//
//
//
//
//
//
// class Music extends StatefulWidget {
//   final id;
//   final name;
//   final profile;
//
//   Music(this.id,this.name,this.profile);
//   @override
//   State<Music> createState() => _MusicState();
// }
//
// class _MusicState extends State<Music> {
//
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: ClipRRect(
//           borderRadius: BorderRadius.circular(27),
//           child: Container(
//             child: CameraApp(camera: frontCamera,),
//           ),
//         ),
//         title: Row(
//           children: [
//             Text(name.toString()[0].toUpperCase()+"  "),
//             Image.asset('assets/images/earpods2.png',color: Colors.white,scale: MediaQuery.of(context).size.height*0.004,),
//             Text("  "+ widget.name),
//           ],
//         ),
//         centerTitle: true,
//       ),
//       body: Column(children: [
//         Text('music'),
//         imagepath2==null?Container():Image.file(
//           File(imagepath2),
//         ),
//       ],),
//     );
//   }
// }
//
//
//
//
// //
// // class CameraScreen extends StatefulWidget {
// //   final List<CameraDescription> cameras;
// //
// //   CameraScreen({required this.cameras});
// //
// //   @override
// //   _CameraScreenState createState() => _CameraScreenState();
// // }
// //
// // class _CameraScreenState extends State<CameraScreen> {
// //   late CameraController _controller;
// //   late Future<void> _initializeControllerFuture;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _controller = CameraController(
// //       widget.cameras[0], // You can choose a specific camera here
// //       ResolutionPreset.medium,
// //     );
// //
// //     _initializeControllerFuture = _controller.initialize();
// //   }
// //
// //   @override
// //   void dispose() {
// //     _controller.dispose();
// //     super.dispose();
// //   }
// //
// //   Future<void> _takePicture() async {
// //     try {
// //       await _initializeControllerFuture;
// //
// //       final imageDirectory = await getTemporaryDirectory();
// //       final imagePath = '${DateTime.now()}.png';
// //       final file = File('${imageDirectory.path}/$imagePath');
// //
// //       await _controller.takePicture(file.path);
// //
// //       print('Photo saved as: $imagePath');
// //     } catch (e) {
// //       print('Error taking picture: $e');
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Camera Example'),
// //       ),
// //       body: FutureBuilder<void>(
// //         future: _initializeControllerFuture,
// //         builder: (context, snapshot) {
// //           if (snapshot.connectionState == ConnectionState.done) {
// //             return Center(
// //               child: Column(
// //                 children: <Widget>[
// //                   CameraPreview(_controller),
// //                   ElevatedButton(
// //                     onPressed: _takePicture,
// //                     child: Text('Take Photo'),
// //                   ),
// //                 ],
// //               ),
// //             );
// //           } else {
// //             return Center(child: CircularProgressIndicator());
// //           }
// //         },
// //       ),
// //     );
// //   }
// // }
//
//
//
//
//
//
//
//
//
// class CameraApp extends StatefulWidget {
//   final CameraDescription camera;
//
//   const CameraApp({required this.camera});
//
//   @override
//   _CameraAppState createState() => _CameraAppState();
// }
//
// class _CameraAppState extends State<CameraApp> {
//   late CameraController _controller;
//   late Timer _timer;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = CameraController(widget.camera, ResolutionPreset.medium);
//     _initializeCamera();
//   }
//
//   void _initializeCamera() async {
//     await _controller.initialize();
//     _timer = Timer.periodic(Duration(seconds: 12), (timer) {
//       _takePhotoAndSave();
//     });
//   }
//
//   void _takePhotoAndSave() async {
//     if (!_controller.value.isInitialized) {
//       return;
//     }
//
//     final Directory extDir = await getApplicationDocumentsDirectory();
//     final String dirPath = '${extDir.path}/Pictures/flutter_camera';
//     await Directory(dirPath).create(recursive: true);
//
//     final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
//     final String filePath = '$dirPath/$timestamp.jpg';
//
//     final XFile pictureFile = await _controller.takePicture();
//
//     final File savedFile = File(pictureFile.path);
//     await savedFile.rename(filePath);
//
//     print('Photo saved: $filePath');
//   }
//
//
//   @override
//   void dispose() {
//     _timer.cancel();
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: CameraPreview(_controller),
//         ),
//       ),
//     );
//   }
// }























import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';

class Music extends StatefulWidget {
  final id;
  final name;
  final profile;

  Music(this.id,this.name,this.profile);
  @override
  _MusicState createState() => _MusicState();
}

class _MusicState extends State<Music> {
  late CameraDescription _frontCamera;
  late CameraController _cameraController;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }




  void _initializeCamera() async {
    final cameras = await availableCameras();
    _frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    _cameraController = CameraController(
      _frontCamera,
      ResolutionPreset.medium,
    );


      await Future.delayed(Duration(milliseconds: 5)); // Adjust the delay as needed

    setState(() {

    });

    await _cameraController.initialize(); // Initialize the camera controller
  }

  void _handlePhotoSaved(String filePath) {
    print('Photo saved: $filePath');
    // You can perform additional actions with the photo file path
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Embedded Screen'),
      ),
      body: Center(
        child: _cameraController.value.isInitialized
            ? CameraScreen(
          cameraController: _cameraController,
          onPhotoSaved: _handlePhotoSaved,
        )
            : CircularProgressIndicator(),
      ),
    );
  }
}

class CameraScreen extends StatefulWidget {
  final CameraController cameraController;
  final Function(String) onPhotoSaved;

  const CameraScreen({
    required this.cameraController,
    required this.onPhotoSaved,
  });

  @override
  _CameraScreenState createState() => _CameraScreenState();
}



class _CameraScreenState extends State<CameraScreen> {
  Timer? _timer;
  bool _isCameraOpen = false;

  @override
  void initState() {
    super.initState();
    _startCameraCycle();
  }

  void _startCameraCycle() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }

    _timer = Timer.periodic(Duration(seconds: 14), (timer) {
      _toggleCamera(); // Toggle camera state every 14 seconds
    });
  }

  void _toggleCamera() async {
    setState(() {
      _isCameraOpen = !_isCameraOpen;
    });

    if (_isCameraOpen) {
      await _takePhotoAndSave(); // Take photo when camera is open
      setState(() {
        _isCameraOpen = false; // Close camera immediately after taking photo
      });
    }
  }

  Future<void> _takePhotoAndSave() async {
    if (!widget.cameraController.value.isInitialized || !_isCameraOpen) {
      return;
    }

    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_camera';
    await Directory(dirPath).create(recursive: true);

    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final String filePath = '$dirPath/$timestamp.jpg';

    final XFile pictureFile = await widget.cameraController.takePicture();

    final File savedFile = File(pictureFile.path);
    await savedFile.rename(filePath);

    widget.onPhotoSaved(filePath);
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isCameraOpen
        ? CameraPreview(widget.cameraController)
        : Container(); // Blank screen when camera is closed
  }
}
