import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../main.dart';
import 'chatdetail.dart';
bool splitscrcanva=false;


class CanvasScreen extends StatefulWidget {
  final String another;
  final String username;
  final String profile;
  CanvasScreen(this.another,this.username,this.profile);

  @override
  _CanvasScreenState createState() => _CanvasScreenState();
}

class _CanvasScreenState extends State<CanvasScreen> {
  final _firestore = FirebaseFirestore.instance;
  late String _chatDocId;
  List<List<Offset>> _drawings = [];
  StreamController<List<List<Offset>>> _drawingsStreamController =
  StreamController<List<List<Offset>>>();



  //
  // @override
  // void dispose() {
  //   _drawingsStreamController.close();
  //   super.dispose();
  // }

  @override
  void initState() {
    super.initState();
    _chatDocId = '${userid}_${widget.another}';
    _listenToDrawingData();
  }



  void _listenToDrawingData() {
    _firestore
        .collection('chats')
        .doc(_chatDocId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data();
        if (data != null && data['drawings'] != null) {
          final List<dynamic> drawingsData = data['drawings'];
          List<List<Offset>> drawings = drawingsData
              .map((drawingData) =>
              (drawingData['points'] as List<dynamic>)
                  .map((pointData) => Offset(pointData['x'], pointData['y']))
                  .toList())
              .toList();
          _drawingsStreamController.add(drawings);
        } else {
          _drawingsStreamController.add([]);
        }
      }
    });
  }



  void _uploadDrawing(List<Offset> points) {
    if (userid != null && userid.isNotEmpty) {
      List<Map<String, double>> data = _pointsToListOfMaps(points);
      _firestore.collection('chats').doc(_chatDocId).set(
        {
          'drawings': _drawings
              .map((drawing) {
            return {
              'points': drawing
                  .map((offset) => {'x': offset.dx, 'y': offset.dy})
                  .toList()
            };
          })
              .toList(),
        },
        SetOptions(merge: true),
      );
    }
  }

  void _uploadDrawingToUser(String userId, List<Offset> points) {
    if (userId != null && userId.isNotEmpty && userid != null && userid.isNotEmpty) {
      String docId = '${userId}_$userid';
      List<Map<String, double>> data = _pointsToListOfMaps(points);
      _firestore.collection('chats').doc(docId).set(
        {
          'drawings': _drawings
              .map((drawing) {
            return {
              'points': drawing
                  .map((offset) => {'x': offset.dx, 'y': offset.dy})
                  .toList()
            };
          })
              .toList(),
        },
        SetOptions(merge: true),
      );
    }
  }

  void _startNewDrawing() {
    setState(() {
      _drawings.add([]);
    });
  }

  void _resetDrawing() {
    setState(() {
      _drawings.clear();
    });
    _uploadDrawing([]);
  }

  List<Map<String, double>> _pointsToListOfMaps(List<Offset> points) {
    return points
        .map((offset) => {
      'x': offset.dx,
      'y': offset.dy,
    })
        .toList();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: splitscrcanva==false?AppBar(
        // title: Text('Drawing Canvas'),
        backgroundColor: Colors.transparent,
        leading: IconButton(icon: Icon(Icons.arrow_circle_left,color: Colors.black,),onPressed: (){Navigator.pop(context);},),
        elevation: 0,
        actions: [
          IconButton(onPressed: (){
            setState(() {
              splitscrcanva=!splitscrcanva;
              Navigator.pop(context, splitscrcanva);
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ChatDetail(widget.another, widget.username, widget.profile);
              }));
            });
          }, icon: Icon(Icons.splitscreen,color: Colors.black,))
        ],
      ):null,
      body: Center(
        child: GestureDetector(
          onPanStart: (_) {
            _startNewDrawing();
          },
          onPanUpdate: (details) {
            Offset localPosition = details.localPosition;
            setState(() {
              _drawings.last.add(localPosition);
            });
          },
          onPanEnd: (_) {
            _uploadDrawing(_drawings.last);
            _uploadDrawingToUser(widget.another, _drawings.last);
          },
          child: StreamBuilder<List<List<Offset>>>(
            stream: _drawingsStreamController.stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else {
                if (snapshot.hasData) {
                  _drawings = snapshot.data!;
                  return CustomPaint(
                    painter: _DrawingPainter(drawings: _drawings),
                    size: Size.infinite,
                  );
                } else {
                  return CustomPaint(
                    painter: _DrawingPainter(drawings: []),
                    size: Size.infinite,
                  );
                }
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: _resetDrawing,
        child: Icon(Icons.delete),
      ),
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<List<Offset>> drawings;

  _DrawingPainter({required this.drawings});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFFF161f1d)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0;

    for (var drawing in drawings) {
      for (int i = 0; i < drawing.length - 1; i++) {
        if (drawing[i] != null && drawing[i + 1] != null) {
          canvas.drawLine(drawing[i], drawing[i + 1], paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}








