import 'package:instamfin/db/models/user.dart';

class UserController {

  Future updateUser(User user) async {
    try {
      user = await user.replace();

      await user.setUserState();

      return {
        "is_success": true,
        "message": user
      };
    } catch (err) {
      return {
        "is_success": true,
        "message": err.toString()
      };

    }
  }
}