import 'package:cloud_firestore/cloud_firestore.dart';
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
      double iRate) async {
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
      temp.setInterestRate(iRate);

      await temp.createTemplate();

      return CustomResponse.getSuccesReponse("Created new Payment template");
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
      print("Error while retrieving Payment template for ID $tempID: " +
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
      print("Error while retrieving Payment templates:" + err.toString());
      throw err;
    }
  }

  Stream<List<PaymentTemplate>> streamAllPaymentTemplates() async* {
    try {
      Stream<QuerySnapshot> stream = PaymentTemplate().streamTemplates();

      if (await stream.isEmpty) {
        yield [];
      }

      List<PaymentTemplate> paymentTemplates = [];

      await for (var event in stream) {
        for (var doc in event.documents) {
          PaymentTemplate templates = PaymentTemplate.fromJson(doc.data);
          paymentTemplates.add(templates);
          yield paymentTemplates;
        }
      }
    } catch (err) {
      throw err;
    }
  }

  Future updateTemp(String tempID, Map<String, dynamic> tempJSON) async {
    try {
      await PaymentTemplate().update(tempID, tempJSON);

      return CustomResponse.getSuccesReponse(
          "Updated Payment template $tempID");
    } catch (err) {
      print("Error while updating Payment template with ID $tempID: " +
          err.toString());
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future removeTemp(String tempID) async {
    try {
      await PaymentTemplate().remove(tempID);
      return CustomResponse.getSuccesReponse(
          "removed Payment template $tempID");
    } catch (err) {
      print("Error while removing Payment template with ID $tempID: " +
          err.toString());
      return CustomResponse.getFailureReponse(err.toString());
    }
  }
}
