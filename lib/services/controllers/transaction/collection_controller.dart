import 'package:instamfin/db/enums/collection_status.dart';
import 'package:instamfin/db/enums/payment_status.dart';
import 'package:instamfin/db/models/collection.dart';
import 'package:instamfin/db/models/collection_details.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:instamfin/services/utils/response_utils.dart';

class PaymentController {
  Future createCollection(
    int custNumber,
    DateTime createdAt,
    int collAmount,
    DateTime collDate,
    int status,
    List<CollectionDetails> collections,
  ) async {
    try {
      Collection coll = Collection();
      coll.addCollections(collections);
      coll.setCollectionAmount(collAmount);
      coll.setStatus(status);
      coll.setCollectionDate(collDate);

      await coll.create(custNumber, createdAt);

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

  Future updateCollection(String financeId,
      String branchName,
      String subBranchName, int custNumber, DateTime paymentCreatedAt, String collID,
      Map<String, dynamic> collectionJSON) async {
    try {
      await Collection().update(financeId,
          branchName,
          subBranchName, custNumber, paymentCreatedAt, collID, collectionJSON);

      return CustomResponse.getSuccesReponse("Updated $custNumber customer's collection $collID");
    } catch (err) {
      print(
          "Error while updating $custNumber customer's collection with ID $collID: " + err.toString());
      return CustomResponse.getFailureReponse(err.toString());
    }
  }
}
