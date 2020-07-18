import 'package:instamfin/db/models/chit_fund_details.dart';
import 'package:instamfin/db/models/chit_template.dart';
import 'package:instamfin/services/utils/response_utils.dart';

class ChitTemplateController {
  Future createTemplate(String name, int tAmount, int tenure, int collectionDay,
      String type, String notes, List<ChitFundDetails> fundDetails) async {
    try {
      ChitTemplate temp = ChitTemplate();
      temp.setTempName(name);
      temp.setchitAmount(tAmount);
      temp.setNotes(notes);
      temp.setTenure(tenure);
      temp.setCollectionDay(collectionDay);
      temp.setType(type);
      temp.setFundDetails(fundDetails);

      await temp.createTemplate();

      return CustomResponse.getSuccesReponse("Created new Chit template");
    } catch (err) {
      print("Error while creating $name template: " + err.toString());
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future<ChitTemplate> getTempByID(String tempID) async {
    try {
      ChitTemplate temp = ChitTemplate();
      return await temp.getTemplateByID(tempID);
    } catch (err) {
      print("Error while retrieving Chit template for ID $tempID: " +
          err.toString());
      return null;
    }
  }

  Future<List<ChitTemplate>> getAllTemplates() async {
    try {
      return await ChitTemplate().getAllChitTemplates();
    } catch (err) {
      print("Error while retrieving ALL Chit templates: " +
          err.toString());
      return null;
    }
  }

  Future updateTemp(String tempID, Map<String, dynamic> tempJSON) async {
    try {
      await ChitTemplate().updateByID(tempJSON, tempID);

      return CustomResponse.getSuccesReponse("Updated Chit template $tempID");
    } catch (err) {
      print("Error while updating Chit template with ID $tempID: " +
          err.toString());
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future removeTemp(String tempID) async {
    try {
      await ChitTemplate().removeChitTemplate(tempID);
      return CustomResponse.getSuccesReponse(
          "removed Payment template $tempID");
    } catch (err) {
      print("Error while removing Payment template with ID $tempID: " +
          err.toString());
      return CustomResponse.getFailureReponse(err.toString());
    }
  }
}
