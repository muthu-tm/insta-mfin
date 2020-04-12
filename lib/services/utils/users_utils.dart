import 'package:cached_network_image/cached_network_image.dart';
import 'package:instamfin/db/models/user.dart';

class UserUtils {

  static dynamic getUserDisplayImage() {
      return CachedNetworkImageProvider(userState.displayProfilePath);
  }
}
