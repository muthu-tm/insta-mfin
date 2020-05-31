import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instamfin/db/enums/collection_status.dart';
import 'package:instamfin/db/models/collection.dart';
import 'package:instamfin/db/models/collection_details.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/services/utils/date_utils.dart';
import 'package:instamfin/services/utils/response_utils.dart';

class CollectionController {
  Future createCollection(
    String financeId,
    String branchName,
    String subBranchName,
    int custNumber,
    DateTime createdAt,
    int collAmount,
    DateTime collDate,
    List<CollectionDetails> collections,
  ) async {
    try {
      Collection coll = Collection();
      coll.addCollections(collections);
      coll.setCollectionAmount(collAmount);
      coll.setCollectionDate(collDate);

      await coll.create(
          financeId, branchName, subBranchName, custNumber, createdAt);

      return CustomResponse.getSuccesReponse(
          "Added new Collection successfully for $custNumber customer's payment ${createdAt.toString()}");
    } catch (err) {
      print(
          "Error while creating collection for $custNumber customer's payment ${createdAt.toString()}: " +
              err.toString());
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
      Stream<QuerySnapshot> stream = coll.streamCollectionsByStatus(
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

  Future<List<Collection>> getAllCollectionsByStatus(
      String financeId,
      String branchName,
      String subBranchName,
      int custNumber,
      int status) async {
    try {
      List<Collection> collections = await Collection()
          .getAllCollectionsByStatus(
              financeId, branchName, subBranchName, status);

      if (collections == null) {
        return [];
      }

      return collections;
    } catch (err) {
      print(
          "Error while retrieving collections for $custNumber customer with status $status:" +
              err.toString());
      throw err;
    }
  }

  Future<List<Collection>> getAllCollectionByDateRage(
      String financeId,
      String branchName,
      String subBranchName,
      DateTime startDate,
      DateTime endDate) async {
    try {
      List<DateTime> dates = DateUtils.getDaysInBeteween(startDate, endDate);
      List<Collection> collections = await Collection()
          .getAllCollectionsByDateRage(
              financeId, branchName, subBranchName, dates);

      if (collections == null) {
        return [];
      }

      return collections;
    } catch (err) {
      print("Error while retrieving collections with Date Range: " +
          err.toString());
      throw err;
    }
  }

  Future<int> getCollectionsAmountByStatus(String financeId, String branchName,
      String subBranchName, int custNumber, int status) async {
    try {
      List<Collection> collections = await getAllCollectionsByStatus(
          financeId, branchName, subBranchName, custNumber, status);

      int tAmount = 0;
      if (collections == null) {
        return tAmount;
      }

      collections.forEach((coll) {
        tAmount += coll.collectionAmount;
      });

      return tAmount;
    } catch (err) {
      print(
          "Error while retrieving collections with status $status for $custNumber customer:" +
              err.toString());
      throw err;
    }
  }

  Future<Map<String, int>> getCollectionsCountForCustomerByStatus(
      String financeId,
      String branchName,
      String subBranchName,
      int custNumber) async {
    try {
      Map<String, int> collectionsCount = Map();

      List<Collection> totalCollections = await Collection()
          .getAllCollectionsForCustomer(
              financeId, branchName, subBranchName, custNumber);
      collectionsCount['total_collections'] = totalCollections.length;

      List<Collection> upcomingCollections = await getAllCollectionsByStatus(
          financeId,
          branchName,
          subBranchName,
          custNumber,
          CollectionStatus.Upcoming.name);
      collectionsCount['upcoming_collections'] = upcomingCollections.length;

      List<Collection> paidCollections = await getAllCollectionsByStatus(
          financeId,
          branchName,
          subBranchName,
          custNumber,
          CollectionStatus.Paid.name);
      collectionsCount['paid_collections'] = paidCollections.length;

      List<Collection> paidLateCollections = await getAllCollectionsByStatus(
          financeId,
          branchName,
          subBranchName,
          custNumber,
          CollectionStatus.PaidLate.name);
      collectionsCount['paid_late_collections'] = paidLateCollections.length;

      List<Collection> pendingCollections = await getAllCollectionsByStatus(
          financeId,
          branchName,
          subBranchName,
          custNumber,
          CollectionStatus.Pending.name);
      collectionsCount['pending_collections'] = pendingCollections.length;

      return collectionsCount;
    } catch (err) {
      print(
          "Error while retrieving collections count for customer $custNumber:" +
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
    DateTime collDate,
    bool isAdd,
    Map<String, dynamic> collectionDetails,
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
          collectionDetails);
      return CustomResponse.getSuccesReponse(
          "Payment's Collection updated for customer $custNumber");
    } catch (err) {
      print(
          "Error while updating Payment's Collection updated for customer $custNumber: " +
              err.toString());
      return CustomResponse.getFailureReponse(err.toString());
    }
  }
}
