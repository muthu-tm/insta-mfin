import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/db/sqlite/sql_users.dart';
import 'package:instamfin/db/models/user.dart' as fb;

class Utils {
  static dynamic getUserDisplayImage() {
    String displayProfileLocal = "";
    String displayProfileCloud = "";
    if(localUserState == null) {
      displayProfileLocal = fb.cloudUserState.displayProfileLocal;
      displayProfileCloud = fb.cloudUserState.displayProfileCloud;
    } else {
      displayProfileLocal = localUserState.displayProfileLocal;
      displayProfileCloud = localUserState.displayProfileCloud;
    }

    if (displayProfileLocal == "") {
      return CachedNetworkImageProvider(displayProfileCloud);
    } 

    return new AssetImage(displayProfileLocal);
  }
}