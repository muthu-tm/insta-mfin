import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:instamfin/db/models/user.dart';

class Uploader {

  // static Future<void> copyToAppDirectory(File image, String emailID) async {
  //   try {
  //     // getting a directory path for saving
  //     final String path = (await getApplicationDocumentsDirectory()).path;

  //     File file = await image.copy('$path/$emailID.png');
  //   print("Local User Profile Image Path: " + file.path);
  //   } catch (err) {
  //     print("Error while copying image file: " + err.toString());
  //   }
  // }

  static void uploadImage(String fileDir, String originalFile, int mobileNumber,
      Function onUploaded, Function onFailed) async {
    File fileToUpload = new File(originalFile);

    String filePath = '$fileDir/$mobileNumber.png';
    StorageReference reference = FirebaseStorage.instance.ref().child(filePath);
    StorageUploadTask uploadTask = reference.putFile(fileToUpload);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;

    storageTaskSnapshot.ref.getDownloadURL().then((profilePathUrl) {
      print("Image uploaded; downloadURL - " + profilePathUrl);
      updateUserData(mobileNumber, profilePathUrl);
      onUploaded();
    }).catchError((err) {
      print("Error while uploading image file: " + err.toString());
      onFailed();
    });
  }

  static void updateUserData(int mobileNumber, String profilePathUrl) {
    try {
      User user = User(mobileNumber);
      user.update({
        'display_profile_path': profilePathUrl
      });
    } catch (err) {
      print(
          "Error occurred while updting user data with display profile Image path: " +
              err.toString());
    }
  }
}
