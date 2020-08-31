import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instamfin/db/models/customer.dart';
import 'package:instamfin/db/models/finance.dart';
import 'package:instamfin/services/analytics/analytics.dart';
import 'package:instamfin/services/controllers/user/user_service.dart';

class Uploader {
  Future<void> uploadImage(int type, String fileDir, File fileToUpload,
      String fileName, int id, Function onUploaded) async {
    String filePath = '$fileDir/$fileName.png';
    StorageReference reference = FirebaseStorage.instance.ref().child(filePath);
    StorageUploadTask uploadTask = reference.putFile(fileToUpload);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;

    try {
      var profilePathUrl = await storageTaskSnapshot.ref.getDownloadURL();
      if (type == 0) {
        await updateUserData('profile_path', profilePathUrl);
        cachedLocalUser.profilePath = profilePathUrl;
      } else if (type == 1)
        await updateCustData('profile_path', id, profilePathUrl);
      else if (type == 2)
        await updateFinanceData('profile_path', fileName, id, profilePathUrl);
    } catch (err) {
      Analytics.reportError({
        "type": 'image_upload_error',
        'user_id': id,
        'error': err.toString()
      }, 'storage');
    }

    onUploaded();
  }

  Future<void> updateUserData(
      String field, String profilePathUrl) async {
    try {
      await cachedLocalUser.update({field: profilePathUrl});
    } catch (err) {
      Analytics.reportError({
        "type": 'url_update_error',
        'user_id': cachedLocalUser.getID(),
        'path': profilePathUrl,
        'error': err.toString()
      }, 'storage');
    }
  }

  Future<void> updateCustData(
      String field, int id, String profilePathUrl) async {
    try {
      Customer cust = Customer();
      cust.id = id;
      await cust.update({field: profilePathUrl});
    } catch (err) {
      Analytics.reportError({
        "type": 'url_update_error',
        'cust_id': id,
        'path': profilePathUrl,
        'error': err.toString()
      }, 'storage');
    }
  }

  Future<void> updateFinanceData(
      String field, String id, int mobileNumber, String profilePathUrl) async {
    try {
      await Finance().updateByID({field: profilePathUrl}, id);
    } catch (err) {
      Analytics.reportError({
        "type": 'url_update_error',
        'user_id': mobileNumber,
        'finance_id': id,
        'path': profilePathUrl,
        'error': err.toString()
      }, 'storage');
    }
  }
}
