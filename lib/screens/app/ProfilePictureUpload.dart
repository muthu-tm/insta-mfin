import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:instamfin/services/storage/image_uploader.dart';

class ProfilePictureUpload extends StatefulWidget {
  @override
  _ProfilePictureUploadState createState() => _ProfilePictureUploadState();
}

class _ProfilePictureUploadState extends State<ProfilePictureUpload> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final User _user = UserController().getCurrentUser();
  String imagePath;
  String selectedImagePath = "";

  @override
  void initState() {
    super.initState();
    imagePath = _user.getProfilePicPath();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          imagePath == ""
              ? Container(
                  width: 90,
                  height: 90,
                  margin: EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: CustomColors.mfinFadedButtonGreen,
                      style: BorderStyle.solid,
                      width: 2.0,
                    ),
                    // image:
                  ),
                  child: FlatButton(
                    onPressed: () async => _pickImage(),
                    child: Text(
                      "Upload",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: CustomColors.mfinLightGrey,
                      ),
                    ),
                  ))
              : Container(
                  child: Stack(
                    children: <Widget>[
                      FlatButton(
                        onPressed: () => _pickImage(),
                        child: CircleAvatar(
                          radius: 45.0,
                          backgroundImage:
                              NetworkImage(_user.getProfilePicPath()),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                      Positioned(
                        bottom: -5,
                        left: 45,
                        child: FlatButton(
                          onPressed: () => _pickImage(),
                          child: CircleAvatar(
                            backgroundColor: CustomColors.mfinButtonGreen,
                            radius: 15,
                            child: Icon(
                              Icons.edit,
                              color: CustomColors.mfinWhite,
                              size: 25.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  /// Select an image via gallery or camera
  _pickImage() async {
    print('initial: $selectedImagePath');
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text(
              'Set profile photo',
              style: TextStyle(
                  color: CustomColors.mfinBlack,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
            content: selectedImagePath == ""
                ? Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 45.0,
                          backgroundImage:
                              NetworkImage(_user.getProfilePicPath()),
                          backgroundColor: Colors.transparent,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            FlatButton(
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
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 45.0,
                          backgroundImage: ExactAssetImage(selectedImagePath),
                          backgroundColor: Colors.transparent,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                        ),
                        FlatButton(
                          color: CustomColors.mfinBlue,
                          child: Text(
                            "Upload",
                            style: TextStyle(
                                color: CustomColors.mfinButtonGreen,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.start,
                          ),
                          onPressed: () => _uploadImage(selectedImagePath),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
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
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                            ),
                            FlatButton(
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
                                _previewImage(ImageSource.gallery);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
          );
        });
      },
    );
  }

  Future _previewImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);
    if (selected != null) {
      setState(() {
        selectedImagePath = selected.path.toString();
        _pickImage();
      });
    }
  }

  Future _uploadImage(String path) async {
    if (path != null) {
      Uploader.uploadImage("user_profile_org", path, _user.mobileNumber, () {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
      });
    }
  }
}
