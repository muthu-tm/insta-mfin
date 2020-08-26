import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/analytics/analytics.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:instamfin/services/controllers/user/user_service.dart';
import 'package:instamfin/services/utils/response_utils.dart';

class PaymentController {
  Future createPayment(
      int custID,
      String custName,
      String paymentID,
      int dateOfPay,
      int tAmount,
      int pAmount,
      int tenure,
      int amountPerColl,
      int collectionMode,
      List<int> collectionDays,
      int transferredMode,
      int aCollectedAmount,
      int collectionDate,
      int docCharge,
      int surcharge,
      int rCommission,
      int iAmount,
      String givenBy,
      String notes) async {
    try {
      UserController _uc = UserController();
      Payment pay = Payment();
      pay.setCustomerID(custID);
      pay.setCustomerName(custName);
      pay.setPaymentID(paymentID);
      pay.setDOP(dateOfPay);
      pay.setGivenBy(givenBy);
      pay.setAddedBy(cachedLocalUser.getIntID());
      pay.setTotalAmount(tAmount);
      pay.setPrincipalAmount(pAmount);
      pay.setTenure(tenure);
      pay.setCollectionAmount(amountPerColl);
      pay.setAlreadyCollectionAmount(aCollectedAmount);
      pay.setCollectionDays(collectionDays);
      pay.setTransferredMode(transferredMode);
      pay.setCollectionMode(collectionMode);
      pay.setDocumentCharge(docCharge);
      pay.setSurcharge(surcharge);
      pay.setCommission(rCommission);
      pay.setInterestAmount(iAmount);
      pay.setNotes(notes);
      pay.setIsSettled(false);
      pay.setCSF(collectionDate);

      await pay.create();

      return CustomResponse.getSuccesReponse("Created new Loan successfully");
    } catch (err) {
      Analytics.reportError({
        "type": 'loan_create_error',
        'cust_id': custID,
        'error': err.toString()
      }, 'loan');
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future<List<Payment>> getAllPaymentsForCustomer(int custID) async {
    try {
      List<Payment> payments =
          await Payment().getAllPaymentsForCustomer(custID);

      if (payments == null) {
        return [];
      }

      return payments;
    } catch (err) {
      Analytics.reportError({
        "type": 'loan_get_error',
        'cust_id': custID,
        'error': err.toString()
      }, 'loan');
      throw err;
    }
  }

  Future<List<Payment>> getPaymentsByDate(int epoch) async {
    try {
      List<Payment> payments = await Payment().getAllPaymentsByDate(epoch);

      if (payments == null) {
        return [];
      }

      return payments;
    } catch (err) {
      Analytics.reportError(
          {"type": 'loan_get_date_error', 'error': err.toString()}, 'loan');
      throw err;
    }
  }

  Future<List<Payment>> getThisWeekPayments() {
    try {
      DateTime today = DateUtils.getCurrentDate();

      return getAllPaymentsByDateRange(
          today.subtract(Duration(days: today.weekday)),
          today.add(Duration(days: 1)));
    } catch (err) {
      Analytics.reportError(
          {"type": 'loan_get_week_error', 'error': err.toString()}, 'loan');
      throw err;
    }
  }

  Future<List<Payment>> getThisMonthPayments() {
    try {
      DateTime today = DateUtils.getCurrentDate();

      return getAllPaymentsByDateRange(
          DateTime(today.year, today.month, 1, 0, 0, 0, 0),
          today.add(Duration(days: 1)));
    } catch (err) {
      Analytics.reportError(
          {"type": 'loan_get_month_error', 'error': err.toString()}, 'loan');
      throw err;
    }
  }

  Future<List<Payment>> getAllPaymentsByDateRange(
      DateTime startDate, DateTime endDate) async {
    try {
      List<Payment> payments = await Payment().getAllPaymentsByDateRange(
          DateUtils.getUTCDateEpoch(startDate),
          DateUtils.getUTCDateEpoch(endDate));

      if (payments == null) {
        return [];
      }

      return payments;
    } catch (err) {
      Analytics.reportError(
          {"type": 'loan_get_range_error', 'error': err.toString()}, 'loan');
      throw err;
    }
  }

  Future updatePayment(
      Payment payment, Map<String, dynamic> paymentJSON) async {
    try {
      if (paymentJSON.containsKey('payment_id')) {
        Payment pay = await Payment().getPaymentByID(paymentJSON['payment_id']);
        if (pay != null) {
          throw 'Already a Loan exist with this LOAN ID - ${paymentJSON["payment_id"]}';
        }
      }
      await Payment().updatePayment(payment, paymentJSON);

      return CustomResponse.getSuccesReponse(
          "Updated ${payment.custName} customer's Laon");
    } catch (err) {
      Analytics.reportError({
        "type": 'loan_update_error',
        'payment_id': payment.id,
        'error': err.toString()
      }, 'loan');
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future settlement(Payment payment, Map<String, dynamic> paymentJSON) async {
    try {
      // Collection coll = await Collection().getCollectionByID(
      //     payment.financeID,
      //     payment.branchName,
      //     payment.subBranchName,
      //     payment.id,
      //     paymentJSON['settled_date'].toString());

      // if (coll != null && coll.getReceived() > 0) {
      //   String sDate = DateUtils.formatDate(
      //       DateTime.fromMillisecondsSinceEpoch(paymentJSON['settled_date']));
      //   throw "Already a Collection received on this day $sDate";
      // }

      await payment.settlement(paymentJSON);

      return CustomResponse.getSuccesReponse(
          "Updated ${payment.custName} customer's Loan");
    } catch (err) {
      Analytics.reportError({
        "type": 'loan_settlement_error',
        'payment_id': payment.id,
        'error': err.toString()
      }, 'loan');
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future removePayment(
    String financeId,
    String branchName,
    String subBranchName,
    int paymentID,
  ) async {
    try {
      await Payment()
          .removePayment(financeId, branchName, subBranchName, paymentID);

      return CustomResponse.getSuccesReponse(
          "Removed customer's Loan $paymentID");
    } catch (err) {
      Analytics.reportError({
        "type": 'loan_remove_error',
        'payment_id': paymentID,
        'error': err.toString()
      }, 'loan');
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future forceRemovePayment(String financeId, String branchName,
      String subBranchName, int paymentID, bool isSettled) async {
    try {
      await Payment().forceRemovePayment(
          financeId, branchName, subBranchName, paymentID, isSettled);

      return CustomResponse.getSuccesReponse(
          "Force Removed customer's Loan $paymentID");
    } catch (err) {
      Analytics.reportError({
        "type": 'loan_force_remove_error',
        'payment_id': paymentID,
        'error': err.toString()
      }, 'loan');
      return CustomResponse.getFailureReponse(err.toString());
    }
  }
}
