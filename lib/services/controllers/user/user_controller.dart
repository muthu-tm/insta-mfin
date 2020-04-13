import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/services/utils/response_utils.dart';

class UserController {
  Future updateUser(User user) async {
    try {
      user = await user.replace();

      await user.setUserState();

      return CustomResponse.getFailureReponse(user);
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }
}
