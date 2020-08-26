import 'package:instamfin/db/models/user.dart';

User cachedLocalUser; //<----- Cached Here

class UserService {
  User getCachedUser() {
    return cachedLocalUser;
  }

  void setCachedUser(User user) {
    print("USER STATE change occurred: " + user.toJson().toString());

    cachedLocalUser = user;
  }
}
