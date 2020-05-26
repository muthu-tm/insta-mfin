import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/services/analytics/analytics.dart';

class Uploader {
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
      Analytics.reportError({
        "type": 'image_upload_error',
        'user_id': mobileNumber,
        'error': err.toString()
      });
      onFailed();
    });
  }

  static void updateUserData(int mobileNumber, String profilePathUrl) {
    try {
      User user = User(mobileNumber);
      user.update({'display_profile_path': profilePathUrl});
    } catch (err) {
      Analytics.reportError({
        "type": 'image_url_update_error',
        'user_id': mobileNumber,
        'path': profilePathUrl,
        'error': err.toString()
      });
    }
  }
}
