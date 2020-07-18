import 'package:instamfin/db/models/chit_fund.dart';
import 'package:instamfin/services/utils/response_utils.dart';

class ChitController {

  Future create(ChitFund chit) async {
    try {
      await chit.create();

      return CustomResponse.getSuccesReponse("Published New Chit Successfully");
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }
}