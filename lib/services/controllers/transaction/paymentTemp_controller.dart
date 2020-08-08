import 'package:instamfin/db/models/payment_template.dart';
import 'package:instamfin/services/analytics/analytics.dart';
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
      Analytics.reportError(
          {"type": 'loan_temp_create_error', 'error': err.toString()},
          'loan_temp');
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future<PaymentTemplate> getTempByID(String tempID) async {
    try {
      return await PaymentTemplate().getTemplateByID(tempID);
    } catch (err) {
      Analytics.reportError({
        "type": 'loan_temp_get_error',
        'temp_id': tempID,
        'error': err.toString()
      }, 'loan_temp');
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
      Analytics.reportError(
          {"type": 'loan_temp_get_error', 'error': err.toString()},
          'loan_temp');
      throw err;
    }
  }

  Future updateTemp(String tempID, Map<String, dynamic> tempJSON) async {
    try {
      await PaymentTemplate().update(tempID, tempJSON);

      return CustomResponse.getSuccesReponse("Updated Loan template $tempID");
    } catch (err) {
      Analytics.reportError({
        "type": 'loan_temp_get_error',
        'temp_id': tempID,
        'error': err.toString()
      }, 'loan_temp');
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future removeTemp(String tempID) async {
    try {
      await PaymentTemplate().remove(tempID);
      return CustomResponse.getSuccesReponse("removed Loan template $tempID");
    } catch (err) {
      Analytics.reportError({
        "type": 'loan_temp_remove_error',
        'temp_id': tempID,
        'error': err.toString()
      }, 'loan_temp');
      return CustomResponse.getFailureReponse(err.toString());
    }
  }
}
