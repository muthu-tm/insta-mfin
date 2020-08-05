import 'package:instamfin/db/models/payment_template.dart';
import 'package:instamfin/services/utils/response_utils.dart';

class PaymentTemplateController {
  Future createTemplate(
      String name,
      int tAmount,
      int pAmount,
      int tenure,
      int amountPerColl,
      int collectionMode,
      List<int> collectionDays,
      int docCharge,
      int surcharge,
      int iAmount) async {
    try {
      PaymentTemplate temp = PaymentTemplate();
      temp.setTempName(name);
      temp.setTotalAmount(tAmount);
      temp.setPrincipalAmount(pAmount);
      temp.setTenure(tenure);
      temp.setCollectionAmount(amountPerColl);
      temp.setCollectionMode(collectionMode);
      temp.setCollectionDays(collectionDays);
      temp.setDocumentCharge(docCharge);
      temp.setSurcharge(surcharge);
      temp.setInterestAmount(iAmount);

      await temp.createTemplate();

      return CustomResponse.getSuccesReponse("Created new Loan template");
    } catch (err) {
      print("Error while creating $name template: " + err.toString());
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future<PaymentTemplate> getTempByID(String tempID) async {
    try {
      PaymentTemplate temp = PaymentTemplate();
      return await temp.getTemplateByID(tempID);
    } catch (err) {
      print("Error while retrieving Loan template for ID $tempID: " +
          err.toString());
      return null;
    }
  }

  Future<List<PaymentTemplate>> getAllTemplates() async {
    try {
      List<PaymentTemplate> temps = await PaymentTemplate().getAllTemplates();

      if (temps == null) {
        return [];
      }

      return temps;
    } catch (err) {
      print("Error while retrieving Loan templates:" + err.toString());
      throw err;
    }
  }

  Future updateTemp(String tempID, Map<String, dynamic> tempJSON) async {
    try {
      await PaymentTemplate().update(tempID, tempJSON);

      return CustomResponse.getSuccesReponse(
          "Updated Loan template $tempID");
    } catch (err) {
      print("Error while updating Loan template with ID $tempID: " +
          err.toString());
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future removeTemp(String tempID) async {
    try {
      await PaymentTemplate().remove(tempID);
      return CustomResponse.getSuccesReponse(
          "removed Loan template $tempID");
    } catch (err) {
      print("Error while removing Loan template with ID $tempID: " +
          err.toString());
      return CustomResponse.getFailureReponse(err.toString());
    }
  }
}
