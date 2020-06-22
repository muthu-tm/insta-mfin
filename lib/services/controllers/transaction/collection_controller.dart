import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instamfin/db/models/collection.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/utils/response_utils.dart';

class CollectionController {
  Future createCollection(
    String financeID,
    String branchName,
    String subBranchName,
    int custNumber,
    String payID,
    DateTime createdAt,
    int cNumber,
    int type,
    int collAmount,
    int collDate,
    Map<String, dynamic> collection,
  ) async {
    try {
      Collection coll = Collection();
      Collection res;
      if (type != 0) {
        res = await coll.getCollectionByID(financeID, branchName, subBranchName,
            custNumber, createdAt, (collDate + type).toString());
      } else {
        res = await coll.getCollectionByID(financeID, branchName, subBranchName,
            custNumber, createdAt, collDate.toString());
      }

      if (res != null)
        return CustomResponse.getFailureReponse(
            'Found a Collection on the selected DATE and TYPE. Please use that to add amount!');

      coll.setFinanceID(financeID);
      coll.setBranchName(branchName);
      coll.setSubBranchName(subBranchName);
      coll.setCollectionAmount(collAmount);
      coll.setCustomerNumber(custNumber);
      coll.setPaymentID(payID);
      coll.setcollectionNumber(cNumber);
      coll.setType(type);
      coll.setCollectionDate(collDate);
      bool cAlready = false;

      if (collection.containsKey('amount')) {
        cAlready = true;
      }

      await coll.create(createdAt, cAlready, collection);

      return CustomResponse.getSuccesReponse(
          "Added new Collection successfully for $custNumber customer's payment ${createdAt.toString()}");
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future<Collection> getCollectionByID(
      String financeId,
      String branchName,
      String subBranchName,
      int custNumber,
      DateTime createdAt,
      String collID) async {
    try {
      Collection collection = Collection();
      return await collection.getCollectionByID(
          financeId, branchName, subBranchName, custNumber, createdAt, collID);
    } catch (err) {
      print(
          "Error while retrieving colletction of $custNumber customer's payment createdAt ${createdAt.toString()}: " +
              err.toString());
      return null;
    }
  }

  Future<List<Collection>> getAllCollectionsForPayment(
      String financeId,
      String branchName,
      String subBranchName,
      int custNumber,
      DateTime createdAt) async {
    try {
      List<Collection> payments = await Collection()
          .getAllCollectionsForCustomerPayment(
              financeId, branchName, subBranchName, custNumber, createdAt);

      if (payments == null) {
        return [];
      }

      return payments;
    } catch (err) {
      print(
          "Error while retrieving collection of $custNumber customer's payment createdAt ${createdAt.toString()}: " +
              err.toString());
      throw err;
    }
  }

  Stream<List<Collection>> streamCollectionsByStatus(
      String financeId,
      String branchName,
      String subBranchName,
      int number,
      DateTime createdAt,
      List<int> status,
      bool fetchAll) async* {
    try {
      Collection coll = new Collection();
      Stream<QuerySnapshot> stream = coll.streamCollectionsForPayment(
          financeId, branchName, subBranchName, number, createdAt);

      if (await stream.isEmpty) {
        yield [];
      }

      List<Collection> colls = [];

      if (fetchAll) {
        await for (var event in stream) {
          for (var doc in event.documents) {
            colls.add(Collection.fromJson(doc.data));
          }
          yield colls;
        }
      } else {
        await for (var event in stream) {
          for (var doc in event.documents) {
            Collection coll = Collection.fromJson(doc.data);
            if (status.contains(coll.getStatus())) colls.add(coll);
          }
          yield colls;
        }
      }
    } catch (err) {
      throw err;
    }
  }

  Future<List<Collection>> getAllCollectionByDateRange(
      String financeId,
      String branchName,
      String subBranchName,
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
                  financeId, branchName, subBranchName, rDates.toList());

          if (colls != null) {
            collections.addAll(colls);
          }
        }

        if ((dates.length % 10) != 0) {
          Iterable<int> rDates =
              dates.getRange(dates.length - (dates.length % 10), dates.length);
          List<Collection> colls = await Collection()
              .getAllCollectionDetailsByDateRange(
                  financeId, branchName, subBranchName, rDates.toList());

          if (colls != null) {
            collections.addAll(colls);
          }
        }
      } else {
        List<Collection> colls = await Collection()
            .getAllCollectionDetailsByDateRange(
                financeId, branchName, subBranchName, dates);

        if (colls != null) {
          collections.addAll(colls);
        }
      }

      return collections;
    } catch (err) {
      print("Error while retrieving collections with Date Range: " +
          err.toString());
      throw err;
    }
  }

  Future updateCollection(
      String financeId,
      String branchName,
      String subBranchName,
      int custNumber,
      DateTime paymentCreatedAt,
      String collID,
      Map<String, dynamic> collectionJSON) async {
    try {
      await Collection().update(financeId, branchName, subBranchName,
          custNumber, paymentCreatedAt, collID, collectionJSON);

      return CustomResponse.getSuccesReponse(
          "Updated $custNumber customer's collection $collID");
    } catch (err) {
      print(
          "Error while updating $custNumber customer's collection with ID $collID: " +
              err.toString());
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future updateCollectionDetails(
    String financeId,
    String branchName,
    String subBranchName,
    int custNumber,
    DateTime createdAt,
    int collDate,
    bool isAdd,
    Map<String, dynamic> collectionDetails,
    bool hasPenalty,
  ) async {
    try {
      await Collection().updateCollectionDetails(
          financeId,
          branchName,
          subBranchName,
          custNumber,
          createdAt,
          collDate,
          isAdd,
          collectionDetails,
          hasPenalty);
      return CustomResponse.getSuccesReponse(
          "Payment's Collection updated for customer $custNumber");
    } catch (err) {
      print(
          "Error while updating Payment's Collection for customer $custNumber: " +
              err.toString());
      return CustomResponse.getFailureReponse(err.toString());
    }
  }
}
