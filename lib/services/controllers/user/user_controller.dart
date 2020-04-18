import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/services/utils/response_utils.dart';

class UserController {
  Future updateUser(User user) async {
    try {
      user = await user.replace();

      await user.setUserState();

      return CustomResponse.getSuccesReponse(user);
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future getByMobileNumber(int mobileNumber) async {
    try {
      User user = User(mobileNumber);
      var userJson = await user.getByID();
      if (userJson == null) {
        return CustomResponse.getFailureReponse("No user found for this mobile number!");
      }

      return CustomResponse.getSuccesReponse(userJson);
    } catch (err) {
      return  CustomResponse.getFailureReponse(err.toString());
    }
  }
}
