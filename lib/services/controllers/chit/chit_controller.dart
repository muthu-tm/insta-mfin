import 'package:instamfin/db/models/chit_collection.dart';
import 'package:instamfin/db/models/chit_fund.dart';
import 'package:instamfin/db/models/chit_requesters.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/analytics/analytics.dart';
import 'package:instamfin/services/utils/response_utils.dart';

class ChitController {
  Future create(ChitFund chit) async {
    try {
      await chit.create();

      Analytics.sendAnalyticsEvent({
        "type": 'chit_create',
        'chit_id': chit.getID(),
        'finance_id': chit.financeID,
      }, 'chit');

      return CustomResponse.getSuccesReponse("Published New Chit Successfully");
    } catch (err) {
      Analytics.reportError({
        "type": 'chit_create_error',
        'chit_name': chit.chitName,
        'error': err.toString()
      }, 'chit');
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future addRequester(String financeId, String branchName, String subBranchName,
      int chitID, ChitRequesters requesters) async {
    try {
      await requesters.create(
        financeId,
        branchName,
        subBranchName,
        chitID,
      );

      return CustomResponse.getSuccesReponse(
          "Chit Requester added successfully");
    } catch (err) {
      Analytics.reportError({
        "type": 'chit_req_add_error',
        'chit_name': chitID,
        'error': err.toString()
      }, 'chit');
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future<List<ChitCollection>> getAllChitsByDateRange(
      String financeId,
      String branchName,
      String subBranchName,
      DateTime startDate,
      DateTime endDate) async {
    try {
      List<int> dates = DateUtils.getDaysInBeteween(startDate, endDate);

      List<ChitCollection> collections = [];
      if (dates.length > 10) {
        //firestore arraycontains restiction
        int limit = 10;

        for (int i = 0; i + limit <= dates.length; i = i + limit) {
          Iterable<int> rDates = dates.getRange(i, i + limit);
          List<ChitCollection> colls = await ChitCollection()
              .getAllCollectionDetailsByDateRange(
                  financeId, branchName, subBranchName, rDates.toList());

          if (colls != null) {
            collections.addAll(colls);
          }
        }

        if ((dates.length % 10) != 0) {
          Iterable<int> rDates =
              dates.getRange(dates.length - (dates.length % 10), dates.length);
          List<ChitCollection> colls = await ChitCollection()
              .getAllCollectionDetailsByDateRange(
                  financeId, branchName, subBranchName, rDates.toList());

          if (colls != null) {
            collections.addAll(colls);
          }
        }
      } else {
        List<ChitCollection> colls = await ChitCollection()
            .getAllCollectionDetailsByDateRange(
                financeId, branchName, subBranchName, dates);

        if (colls != null) {
          collections.addAll(colls);
        }
      }

      return collections;
    } catch (err) {
      Analytics.reportError({
        "type": 'chit_get_error',
        'finance_id': financeId,
        'error': err.toString()
      }, 'chit');
      throw err;
    }
  }

  Future updateCollectionDetails(
      String financeId,
      String branchName,
      String subBranchName,
      int chitID,
      int mNumber,
      int chitNumber,
      bool isPaid,
      bool isAdd,
      Map<String, dynamic> collectionDetails) async {
    try {
      await ChitCollection().updateCollectionDetails(
          financeId,
          branchName,
          subBranchName,
          chitID,
          mNumber,
          chitNumber,
          isPaid,
          isAdd,
          collectionDetails);
      return CustomResponse.getSuccesReponse(
          "Chit's Collection updated for Chit $chitID");
    } catch (err) {
      Analytics.reportError({
        "type": 'chit_update_coll_error',
        'chit_id': chitID,
        'error': err.toString()
      }, 'chit');
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future removeChitFund(int chitID) async {
    try {
      bool received = await ChitFund().isChitReceived(chitID);

      if (received) {
        return null;
      }
      await ChitFund().removeChit(chitID);

      return CustomResponse.getSuccesReponse(
          "Removed the ChitFund successfully!!");
    } catch (err) {
      Analytics.reportError({
        "type": 'chit_remove_error',
        'chit_id': chitID,
        'error': err.toString()
      }, 'chit');
      return CustomResponse.getFailureReponse(err.toString());
    }
  }
}
