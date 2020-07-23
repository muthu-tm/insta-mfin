import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class TakePicturePage extends StatefulWidget {
  final CameraDescription camera;
  final String path;

  TakePicturePage({@required this.camera, this.path});

  @override
  _TakePicturePageState createState() => _TakePicturePageState();
}

class _TakePicturePageState extends State<TakePicturePage> {
  CameraController _cameraController;
  Future<void> _initializeCameraControllerFuture;

  @override
  void initState() {
    super.initState();

    _cameraController =
        CameraController(widget.camera, ResolutionPreset.medium);
    _initializeCameraControllerFuture = _cameraController.initialize()
      ..then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Take Picture"),
        backgroundColor: CustomColors.mfinBlue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: CustomColors.mfinAlertRed.withOpacity(0.6),
        onPressed: () async {
          await _takePicture(context);
        },
        label: Text(
          "Capture",
          style: TextStyle(
              color: CustomColors.mfinButtonGreen,
              fontSize: 14.0,
              fontWeight: FontWeight.bold),
        ),
        icon: Icon(
          Icons.broken_image,
          size: 35,
          color: CustomColors.mfinButtonGreen,
        ),
      ),
      body: FutureBuilder(
        future: _initializeCameraControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_cameraController);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<void> _takePicture(BuildContext context) async {
    try {
      await _initializeCameraControllerFuture;
      await _cameraController.takePicture(widget.path);

      Navigator.pop(context, widget.path);
    } catch (e) {
      print(e.toString());
    }
  }
}
