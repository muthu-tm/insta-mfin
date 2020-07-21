import 'package:instamfin/db/models/collection.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/utils/response_utils.dart';

class CollectionController {
  Future createCollection(
    String financeID,
    String branchName,
    String subBranchName,
    int custID,
    String paymentID,
    int cNumber,
    int type,
    int collAmount,
    bool isPaid,
    int collDate,
    Map<String, dynamic> collection,
  ) async {
    try {
      Collection coll = Collection();
      Collection res;
      if (type != 0) {
        res = await coll.getCollectionByID(financeID, branchName, subBranchName,
            paymentID, (collDate + type).toString());
      } else {
        res = await coll.getCollectionByID(financeID, branchName, subBranchName,
            paymentID, collDate.toString());
      }

      if (res != null)
        return CustomResponse.getFailureReponse(
            'Found a Collection on the selected DATE and TYPE. Please use that to add amount!');

      coll.setFinanceID(financeID);
      coll.setBranchName(branchName);
      coll.setSubBranchName(subBranchName);
      coll.setCollectionAmount(collAmount);
      coll.setIsPaid(isPaid);
      coll.setCustomerID(custID);
      coll.setPaymentID(paymentID);
      coll.setcollectionNumber(cNumber);
      coll.setType(type);
      coll.setCollectionDate(collDate);
      bool cAlready = false;

      if (collection.containsKey('amount')) {
        cAlready = true;
      }

      await coll.create(cAlready, collection);

      return CustomResponse.getSuccesReponse(
          "Added new Collection successfully for Payment $paymentID}");
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future<Collection> getCollectionByID(String financeId, String branchName,
      String subBranchName, String paymentID, String collID) async {
    try {
      Collection collection = Collection();
      return await collection.getCollectionByID(
          financeId, branchName, subBranchName, paymentID, collID);
    } catch (err) {
      return null;
    }
  }

  Future<List<Collection>> getAllCollectionsForPayment(String financeId,
      String branchName, String subBranchName, String paymentID) async {
    try {
      List<Collection> payments = await Collection()
          .getAllCollectionsForCustomerPayment(
              financeId, branchName, subBranchName, paymentID);

      if (payments == null) {
        return [];
      }

      return payments;
    } catch (err) {
      throw err;
    }
  }

  Future<List<Collection>> getAllCollectionByDateRange(
      String financeId,
      String branchName,
      String subBranchName,
      List<int> types,
      DateTime startDate,
      DateTime endDate) async {
    try {
      List<int> dates = DateUtils.getDaysInBeteween(startDate, endDate);

      List<Collection> collections = [];
      if (dates.length > 10) {
        //firestore arraycontains restiction
        int limit = 10;

        for (int i = 0; i + limit <= dates.length; i = i + limit) {
          Iterable<int> rDates = dates.getRange(i, i + limit);
          List<Collection> colls = await Collection()
              .getAllCollectionDetailsByDateRange(
                  financeId, branchName, subBranchName, rDates.toList(), types);

          if (colls != null) {
            collections.addAll(colls);
          }
        }

        if ((dates.length % 10) != 0) {
          Iterable<int> rDates =
              dates.getRange(dates.length - (dates.length % 10), dates.length);
          List<Collection> colls = await Collection()
              .getAllCollectionDetailsByDateRange(
                  financeId, branchName, subBranchName, rDates.toList(), types);

          if (colls != null) {
            collections.addAll(colls);
          }
        }
      } else {
        List<Collection> colls = await Collection()
            .getAllCollectionDetailsByDateRange(
                financeId, branchName, subBranchName, dates, types);

        if (colls != null) {
          collections.addAll(colls);
        }
      }

      return collections;
    } catch (err) {
      throw err;
    }
  }

  Future updateCollection(
      String financeId,
      String branchName,
      String subBranchName,
      String paymentID,
      String collID,
      Map<String, dynamic> collectionJSON) async {
    try {
      await Collection().update(financeId, branchName, subBranchName, paymentID,
          collID, collectionJSON);

      return CustomResponse.getSuccesReponse(
          "Updated $paymentID Payment's collection $collID");
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future updateCollectionDetails(
    String financeId,
    String branchName,
    String subBranchName,
    String paymentID,
    int collDate,
    bool isPaid,
    bool isAdd,
    Map<String, dynamic> collectionDetails,
    bool hasPenalty,
  ) async {
    try {
      await Collection().updateCollectionDetails(
          financeId,
          branchName,
          subBranchName,
          paymentID,
          collDate,
          isPaid,
          isAdd,
          collectionDetails,
          hasPenalty);
      return CustomResponse.getSuccesReponse(
          "Payment's Collection updated for Payment $paymentID");
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }
}
