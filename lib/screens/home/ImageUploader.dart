import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class Uploader {
  static void uploadImage(String originalFile, String emailID, Function onUploaded, Function onFailed) async {
    File fileToUpload = new File(originalFile);

    String filePath = 'images/$emailID.png';
    StorageReference reference = FirebaseStorage.instance.ref().child(filePath);
    StorageUploadTask uploadTask = reference.putFile(fileToUpload);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;

    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      print("Image uploaded; downloadURL - " + downloadUrl);

      onUploaded(downloadUrl);
    }).catchError((err) {
      print("Error while uploading image file: " + err.toString());
      onFailed();
    });
  }
}
