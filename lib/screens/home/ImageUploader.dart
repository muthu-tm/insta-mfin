import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

class Uploader {
  static String userImageLocalPath = "";
  static String userImageCloudPath = "";

  static Future<String> copyToAppDirectory(File image, String emailID) async {
    try {
      // getting a directory path for saving
      final String path = (await getApplicationDocumentsDirectory()).path;

      File file = await image.copy('$path/$emailID.png');
      userImageLocalPath = file.path;
    } catch (err) {
      print("Error while copying image file: " + err.toString());
    }
    print("Local User Profile Image Path: " + userImageLocalPath);
    return userImageLocalPath;
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
      onUploaded(userImageCloudPath);
    }).catchError((err) {
      print("Error while uploading image file: " + err.toString());
      onFailed();
    });
  }
}
