import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/services/controllers/user/user_service.dart';
import 'package:instamfin/services/utils/response_utils.dart';

UserService _userService = locator<UserService>();

class UserController {
  Future replaceUser(User user) async {
    try {
      var result = await user.replace();

      _userService.setCachedUser(User.fromJson(await user.getByID(user.mobileNumber.toString())));
      
      return CustomResponse.getSuccesReponse(result);
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future updateUser(Map<String, dynamic> userJson) async {
    try {
      User user = User(userJson['mobile_number']);
      var result = await user.update(userJson);

      _userService.setCachedUser(User.fromJson(await user.getByID(user.mobileNumber.toString())));
      
      return CustomResponse.getSuccesReponse(result);
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future updatePrimaryFinance(int userNumber, String financeID, String branchID,
      String subBranchID) async {
    try {
      User user = User(userNumber);

      await user.update({
        'primary_finance': financeID,
        'primary_branch': branchID,
        'primary_sub_branch': subBranchID
      });

      return CustomResponse.getSuccesReponse(user);
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future getByMobileNumber(int mobileNumber) async {
    try {
      User user = User(mobileNumber);
      var userJson = await user.getByID(mobileNumber.toString());
      if (userJson == null) {
        return CustomResponse.getFailureReponse(
            "No user found for this mobile number!");
      }

      return CustomResponse.getSuccesReponse(userJson);
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }
}
