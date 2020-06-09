import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instamfin/db/models/customer.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/services/analytics/analytics.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class Uploader {
  static void uploadImage(bool isUser, String fileDir, String originalFile,
      String fileName, int number, Function onUploaded) async {
    File fileToUpload = new File(originalFile);

    String filePath = '$fileDir/$fileName.png';
    StorageReference reference = FirebaseStorage.instance.ref().child(filePath);
    StorageUploadTask uploadTask = reference.putFile(fileToUpload);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;

    storageTaskSnapshot.ref.getDownloadURL().then((profilePathUrl) {
      print("Image uploaded; downloadURL - " + profilePathUrl);
      if (isUser)
        updateUserData('profile_path_org', number, profilePathUrl);
      else
        updateCustData('profile_path_org', number, profilePathUrl);

      UserController().getCurrentUser().profilePathOrg = profilePathUrl;
    }).catchError((err) {
      Analytics.reportError({
        "type": 'image_upload_error',
        'user_id': number,
        'error': err.toString()
      });
    });
    await Future.delayed(Duration(seconds: 5));

    filePath = '${fileDir.replaceAll('_org', "")}/$fileName.png';
    reference = FirebaseStorage.instance.ref().child(filePath);

    if (reference == null)
      await Future.delayed(Duration(seconds: 5));

    reference.getDownloadURL().then((profilePathUrl) {
      print("Resized image downloadURL - " + profilePathUrl);
      if (isUser)
        updateUserData('profile_path', number, profilePathUrl);
      else
        updateCustData('profile_path', number, profilePathUrl);

      UserController().getCurrentUser().profilePath = profilePathUrl;
    }).catchError((err) {
      print(err.toString());
      Analytics.reportError({
        "type": 'image_resize_error',
        'user_id': number,
        'error': err.toString()
      });
    });

    onUploaded();
  }

  static void updateUserData(
      String field, int mobileNumber, String profilePathUrl) {
    try {
      User user = User(mobileNumber);
      user.update({field: profilePathUrl});
    } catch (err) {
      Analytics.reportError({
        "type": 'url_update_error',
        'user_id': mobileNumber,
        'path': profilePathUrl,
        'error': err.toString()
      });
    }
  }

  static void updateCustData(
      String field, int mobileNumber, String profilePathUrl) {
    try {
      Customer cust = Customer();
      cust.setMobileNumber(mobileNumber);
      cust.update({field: profilePathUrl});
    } catch (err) {
      Analytics.reportError({
        "type": 'url_update_error',
        'cust_number': mobileNumber,
        'path': profilePathUrl,
        'error': err.toString()
      });
    }
  }
}
