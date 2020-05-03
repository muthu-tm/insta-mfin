import 'package:instamfin/db/models/coll_template.dart';
import 'package:instamfin/services/utils/response_utils.dart';

class CollectionTempController {

  Future createTemplate(
      String name,
      int tAmount,
      int pAmount,
      int tenure,
      int amountPerColl,
      int tenureType,
      int docCharge,
      int surcharge,
      double iRate) async {
    try {
      CollectionTemp temp = CollectionTemp();
      temp.setTempName(name);
      temp.setTotalAmount(tAmount);
      temp.setPrincipalAmount(pAmount);
      temp.setTenure(tenure);
      temp.setCollectionAmount(amountPerColl);
      temp.setTenureType(tenureType);
      temp.setDocumentCharge(docCharge);
      temp.setSurcharge(surcharge);
      temp.setInterestRate(iRate);

      await temp.createTemplate();

      return CustomResponse.getSuccesReponse("Created new collection template");
    } catch (err) {
      print("Error while creating $name template: " + err.toString());
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future<CollectionTemp> getTempByID(String tempID) async {
    try {
      CollectionTemp temp = CollectionTemp();
      return await temp.getTemplateByID(tempID);
    } catch (err) {
      print("Error while retrieving Collection template for ID $tempID: " + err.toString());
      return null;
    }
  }

  Future<List<CollectionTemp>> getAllTemplates() async {
    try {
      List<CollectionTemp> temps =
          await CollectionTemp().getAllTemplates();

      if (temps == null) {
        return [];
      }

      return temps;
    } catch (err) {
      print("Error while retrieving collection templates:" + err.toString());
      throw err;
    }
  }

  Future updateTemp(String tempID,
      Map<String, dynamic> tempJSON) async {
    try {
      await CollectionTemp().update(tempID, tempJSON);

      return CustomResponse.getSuccesReponse("Updated Collection template $tempID");
    } catch (err) {
      print("Error while updating Collection template with ID $tempID: " + err.toString());
      return CustomResponse.getFailureReponse(err.toString());
    }
  }
}
