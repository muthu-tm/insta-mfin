import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instamfin/screens/app/TakePicturePage.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/services/storage/image_uploader.dart';
import 'package:path_provider/path_provider.dart';

class ProfilePictureUpload extends StatefulWidget {
  ProfilePictureUpload(this.type, this.picPath, this.fileName, this.id);

  final int type; // 0 - User, 1 - Customer, 2 - Finance
  final String picPath;
  final String fileName;
  final int id;

  @override
  _ProfilePictureUploadState createState() => _ProfilePictureUploadState();
}

class _ProfilePictureUploadState extends State<ProfilePictureUpload> {
  String selectedImagePath = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        height: 300,
        width: MediaQuery.of(context).size.width * 0.75,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Spacer(),
            Text(
              widget.type == 0
                  ? 'Set Profile Photo'
                  : widget.type == 1 ? 'Customer Photo' : "Finance Logo",
              style: TextStyle(
                  color: CustomColors.mfinBlack,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
            Spacer(),
            selectedImagePath == ""
                ? Container(
                    height: 250,
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        widget.picPath == ""
                            ? Container(
                                width: 120,
                                height: 120,
                                margin: EdgeInsets.only(bottom: 5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: CustomColors.mfinFadedButtonGreen,
                                      style: BorderStyle.solid,
                                      width: 2.0),
                                ),
                                child: Icon(
                                  Icons.person,
                                  size: 45.0,
                                  color: CustomColors.mfinBlue,
                                ),
                              )
                            : CircleAvatar(
                                radius: 70.0,
                                backgroundImage: NetworkImage(widget.picPath),
                                backgroundColor: Colors.transparent,
                              ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: FlatButton(
                                padding: EdgeInsets.all(5),
                                color: CustomColors.mfinBlue,
                                child: Text(
                                  "Select Image",
                                  style: TextStyle(
                                      color: CustomColors.mfinButtonGreen,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.start,
                                ),
                                onPressed: () {
                                  _previewImage(ImageSource.gallery);
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: FlatButton(
                                padding: EdgeInsets.all(5),
                                color:
                                    CustomColors.mfinAlertRed.withOpacity(0.5),
                                child: Text(
                                  "Take Picture",
                                  style: TextStyle(
                                      color: CustomColors.mfinBlack,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.start,
                                ),
                                onPressed: () async {
                                  String tempPath =
                                      (await getTemporaryDirectory()).path;
                                  String filePath = '$tempPath/ifin_image.png';
                                  if (File(filePath).existsSync())
                                    await File(filePath).delete();
                                  await _showCamera(filePath);
                                },
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                      ],
                    ),
                  )
                : Container(
                    height: 250,
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Spacer(),
                        CircleAvatar(
                          radius: 70.0,
                          backgroundImage:
                              Image.file(File(selectedImagePath)).image,
                          backgroundColor: Colors.transparent,
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: FlatButton(
                                padding: EdgeInsets.all(5),
                                color: CustomColors.mfinBlue,
                                child: Text(
                                  "Change",
                                  style: TextStyle(
                                      color: CustomColors.mfinButtonGreen,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.start,
                                ),
                                onPressed: () {
                                  setState(() {
                                    selectedImagePath = "";
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: FlatButton(
                                padding: EdgeInsets.all(5),
                                color: CustomColors.mfinBlue,
                                child: Text(
                                  "Upload",
                                  style: TextStyle(
                                      color: CustomColors.mfinButtonGreen,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.start,
                                ),
                                onPressed: () =>
                                    _uploadImage(selectedImagePath),
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        FlatButton(
                          color: CustomColors.mfinAlertRed,
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                color: CustomColors.mfinWhite,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.start,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  Future<void> _showCamera(String filePath) async {
    final cameras = await availableCameras();
    final camera = cameras.first;

    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TakePicturePage(
                  camera: camera,
                  path: filePath,
                )));
    if (result != null) {
      setState(() {
        selectedImagePath = result;
      });
    }
  }

  Future _previewImage(ImageSource source) async {
    PickedFile selected = await ImagePicker().getImage(source: source);
    if (selected != null) {
      setState(() {
        selectedImagePath = selected.path.toString();
      });
    }
  }

  Future _uploadImage(String path) async {
    if (path != null) {
      CustomDialogs.actionWaiting(context, "Uploading!");
      Uploader.uploadImage(
        widget.type,
        widget.type == 0
            ? "user_profile_org"
            : widget.type == 1 ? "cust_profile_org" : "finance_profile_org",
        path,
        widget.fileName,
        widget.id,
        () {
          if (widget.type == 0) {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
          } else {
            Navigator.pop(context);
            Navigator.pop(context);
          }
        },
      );
    }
  }
}
