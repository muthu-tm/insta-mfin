import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instamfin/db/sqlite/sql_users.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:instamfin/db/models/user.dart' as fb;

class Uploader {
  static UserDao _userDao = UserDao(database);

  static String userImageLocalPath = "";
  static String userImageCloudPath = "";

  static String getUserImagePath() {
    if (userImageLocalPath.isEmpty) {
      return userImageCloudPath;
    }

    return userImageLocalPath;
  }

  static Future<void> copyToAppDirectory(File image, String emailID) async {
    try {
      // getting a directory path for saving
      final String path = (await getApplicationDocumentsDirectory()).path;

      File file = await image.copy('$path/$emailID.png');
      userImageLocalPath = file.path;
    } catch (err) {
      print("Error while copying image file: " + err.toString());
    }
    print("Local User Profile Image Path: " + userImageLocalPath);
  }

  static void uploadImage(String fileDir, String originalFile, String emailID,
      Function onUploaded, Function onFailed) async {
    File fileToUpload = new File(originalFile);

    String filePath = '$fileDir/$emailID.png';
    StorageReference reference = FirebaseStorage.instance.ref().child(filePath);
    StorageUploadTask uploadTask = reference.putFile(fileToUpload);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;

    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      print("Image uploaded; downloadURL - " + downloadUrl);
      userImageCloudPath = downloadUrl;
      updateUserData(emailID);
      onUploaded(userImageCloudPath);
    }).catchError((err) {
      print("Error while uploading image file: " + err.toString());
      updateUserData(emailID);
      onFailed();
    });
  }

  static void updateUserData(String emailID) {
    try {
      fb.User user = fb.User(emailID);
      user.update(emailID, {
        'display_profile_local': userImageLocalPath,
        'display_profile_cloud': userImageCloudPath
      });

      _userDao.updateByEmailID(
          UserModelCompanion(
              displayProfileCloud: Value(userImageCloudPath),
              displayProfileLocal: Value(userImageLocalPath),
              updatedAt: Value(DateTime.now().toString())),
          emailID);
    } catch (err) {
      print(
          "Error occurred while updting user data with display profile Image path: " +
              err.toString());
    }
  }
}
