import 'package:instamfin/db/models/chit_fund_details.dart';
import 'package:instamfin/db/models/chit_template.dart';
import 'package:instamfin/services/analytics/analytics.dart';
import 'package:instamfin/services/utils/response_utils.dart';

class ChitTemplateController {
  Future createTemplate(
      String name,
      int tAmount,
      int tenure,
      double commission,
      int collectionDay,
      String type,
      String notes,
      List<ChitFundDetails> fundDetails) async {
    try {
      ChitTemplate temp = ChitTemplate();
      temp.setTempName(name);
      temp.setchitAmount(tAmount);
      temp.setInterestRate(commission);
      temp.setNotes(notes);
      temp.setTenure(tenure);
      temp.setCollectionDay(collectionDay);
      temp.setType(type);
      temp.setFundDetails(fundDetails);

      await temp.createTemplate();

      return CustomResponse.getSuccesReponse("Created new Chit template");
    } catch (err) {
      Analytics.reportError({
        "type": 'chit_temp_create_error',
        'temp_name': name,
        'error': err.toString()
      }, 'chit');
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future<ChitTemplate> getTempByID(String tempID) async {
    try {
      ChitTemplate temp = ChitTemplate();
      return await temp.getTemplateByID(tempID);
    } catch (err) {
      Analytics.reportError({
        "type": 'chit_temp_get_error',
        'temp_id': tempID,
        'error': err.toString()
      }, 'chit');
      return null;
    }
  }

  Future<List<ChitTemplate>> getAllTemplates() async {
    try {
      return await ChitTemplate().getAllChitTemplates();
    } catch (err) {
      Analytics.reportError(
          {"type": 'chit_temp_getall_error', 'error': err.toString()}, 'chit');
      return null;
    }
  }

  Future updateTemp(String tempID, Map<String, dynamic> tempJSON) async {
    try {
      await ChitTemplate().updateByID(tempJSON, tempID);

      return CustomResponse.getSuccesReponse("Updated Chit template $tempID");
    } catch (err) {
      Analytics.reportError({
        "type": 'chit_temp_update_error',
        'temp_id': tempID,
        'error': err.toString()
      }, 'chit');
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future removeTemp(String tempID) async {
    try {
      await ChitTemplate().removeChitTemplate(tempID);
      return CustomResponse.getSuccesReponse("removed Chit template $tempID");
    } catch (err) {
      Analytics.reportError({
        "type": 'chit_temp_remove_error',
        'temp_id': tempID,
        'error': err.toString()
      }, 'chit');
      return CustomResponse.getFailureReponse(err.toString());
    }
  }
}
