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

  File _imageFile;
  bool isPicAdd = false;
  final User _user = UserController().getCurrentUser();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _user.getProfilePicPath() == ""
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
                onPressed: () => _pickImage(ImageSource.gallery),
                child: Text(
                  "Upload",
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: CustomColors.mfinLightGrey,
                  ),
                ),
              ))
              : CircleAvatar(
            radius: 45.0,
            backgroundImage:
            NetworkImage(_user.getProfilePicPath()),
            backgroundColor: Colors.transparent,
          ),
        ],
      ),
    );
  }

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    if (_imageFile != null) {
      print("UPLOADING image file: " + _imageFile.toString());
      Uploader.uploadImage(
          "user_profile_org", _imageFile.path, _user.mobileNumber, () {
        Navigator.pop(context);
      });
    }

    setState(() {
      _imageFile = selected;
      isPicAdd = true;
    });
  }

}
