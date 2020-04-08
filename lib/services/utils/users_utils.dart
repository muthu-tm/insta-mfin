import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/db/sqlite/sql_users.dart';
import 'package:instamfin/db/models/user.dart' as fb;

Map<String, dynamic> _userState;
Map<String, dynamic> get userState {
  if (_userState == null || _userState.isEmpty) {
    _userState = UserUtils.getUserState();

    print("USER STATE Change occurred:" + _userState.toString());
  }

  return _userState;
}

class UserUtils {
  static setUserState(Map<String, dynamic> userData) {
    _userState = userData;
  }

  static Map<String, dynamic> getUserState() {
    if (localUserState == null) {
      return fb.cloudUserState;
    }

    return localUserState;
  }

  static dynamic getUserDisplayImage() {
    if (userState['display_profile_local'] == "") {
      return CachedNetworkImageProvider(userState['display_profile_cloud']);
    }

    return new AssetImage(userState['display_profile_local']);
  }
}
