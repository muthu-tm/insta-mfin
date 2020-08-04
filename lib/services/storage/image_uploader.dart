import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instamfin/db/models/customer.dart';
import 'package:instamfin/db/models/finance.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/services/analytics/analytics.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class Uploader {
  static void uploadImage(int type, String fileDir, File fileToUpload,
      String fileName, int id, Function onUploaded) async {
    String filePath = '$fileDir/$fileName.png';
    StorageReference reference = FirebaseStorage.instance.ref().child(filePath);
    StorageUploadTask uploadTask = reference.putFile(fileToUpload);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;

    storageTaskSnapshot.ref.getDownloadURL().then((profilePathUrl) {
      print("Image uploaded; downloadURL - " + profilePathUrl);
      if (type == 0) {
        updateUserData('profile_path_org', id, profilePathUrl);
        UserController().getCurrentUser().profilePathOrg = profilePathUrl;
      } else if (type == 1)
        updateCustData('profile_path_org', id, profilePathUrl);
      else if (type == 2)
        updateFinanceData('profile_path_org', fileName, id, profilePathUrl);
    }).catchError((err) {
      Analytics.reportError({
        "type": 'image_upload_error',
        'user_id': id,
        'error': err.toString()
      });
    });
    await Future.delayed(Duration(seconds: 8));

    filePath = '${fileDir.replaceAll('_org', "")}/$fileName.png';
    reference = FirebaseStorage.instance.ref().child(filePath);

    if (reference == null) await Future.delayed(Duration(seconds: 5));

    reference.getDownloadURL().then((profilePathUrl) {
      print("Resized image downloadURL - " + profilePathUrl);
      if (type == 0) {
        updateUserData('profile_path', id, profilePathUrl);
        UserController().getCurrentUser().profilePath = profilePathUrl;
      } else if (type == 1)
        updateCustData('profile_path', id, profilePathUrl);
      else if (type == 2)
        updateFinanceData('profile_path', fileName, id, profilePathUrl);
    }).catchError((err) {
      print(err.toString());
      Analytics.reportError({
        "type": 'image_resize_error',
        'user_id': id,
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

  static void updateCustData(String field, int id, String profilePathUrl) {
    try {
      Customer cust = Customer();
      cust.id = id;
      cust.update({field: profilePathUrl});
    } catch (err) {
      Analytics.reportError({
        "type": 'url_update_error',
        'cust_id': id,
        'path': profilePathUrl,
        'error': err.toString()
      });
    }
  }

  static void updateFinanceData(
      String field, String id, int mobileNumber, String profilePathUrl) {
    try {
      Finance fin = Finance();
      fin.updateByID({field: profilePathUrl}, id);
    } catch (err) {
      Analytics.reportError({
        "type": 'url_update_error',
        'user_id': mobileNumber,
        'finance_id': id,
        'path': profilePathUrl,
        'error': err.toString()
      });
    }
  }
}
