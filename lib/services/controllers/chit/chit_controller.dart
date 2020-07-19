import 'package:instamfin/db/models/chit_collection.dart';
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

  Future updateCollectionDetails(
      String financeId,
      String branchName,
      String subBranchName,
      String chitID,
      int mNumber,
      int chitNumber,
      bool isPaid,
      bool isAdd,
      Map<String, dynamic> collectionDetails) async {
    try {
      await ChitCollection().updateCollectionDetails(
          financeId,
          branchName,
          subBranchName,
          chitID,
          mNumber,
          chitNumber,
          isPaid,
          isAdd,
          collectionDetails);
      return CustomResponse.getSuccesReponse(
          "Chit's Collection updated for Chit $chitID");
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }
}
