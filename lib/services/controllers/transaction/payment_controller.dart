import 'package:instamfin/db/models/collection.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:instamfin/services/utils/response_utils.dart';

class PaymentController {
  Future createPayment(
      int custNumber,
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
      double iRate,
      String givenBy,
      String notes) async {
    try {
      UserController _uc = UserController();
      Payment pay = Payment();
      pay.setCustomerNumber(custNumber);
      pay.setCustomerName(custName);
      pay.setPaymentID(paymentID);
      pay.setDOP(dateOfPay);
      pay.setGivenBy(givenBy);
      pay.setAddedBy(_uc.getCurrentUserID());
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
      pay.setInterestRate(iRate);
      pay.setNotes(notes);
      pay.setIsSettled(false);
      pay.setCSF(collectionDate);

      await pay.create(custNumber);

      return CustomResponse.getSuccesReponse(
          "Created new Payment successfully");
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future<Payment> getPaymentByID(String financeId, String branchName,
      String subBranchName, int custNumber, DateTime createdAt) async {
    try {
      Payment payment = Payment();
      return await payment.getPaymentByID(
          financeId, branchName, subBranchName, custNumber, createdAt);
    } catch (err) {
      print(
          "Error while retrieving $custNumber customer's Payment createdAt ${createdAt.toString()}: " +
              err.toString());
      return null;
    }
  }

  Future<List<Payment>> getAllPaymentsForCustomer(String financeId,
      String branchName, String subBranchName, int custNumber) async {
    try {
      List<Payment> payments = await Payment().getAllPaymentsForCustomer(
          financeId, branchName, subBranchName, custNumber);

      if (payments == null) {
        return [];
      }

      return payments;
    } catch (err) {
      throw err;
    }
  }

  Future<List<Payment>> getTodaysPayments(
      String financeId, String branchName, String subBranchName) async {
    try {
      List<Payment> payments = await Payment().getAllPaymentsByDate(
          financeId,
          branchName,
          subBranchName,
          DateUtils.getUTCDateEpoch(DateUtils.getCurrentDate()));

      if (payments == null) {
        return [];
      }

      return payments;
    } catch (err) {
      throw err;
    }
  }

  Future<List<Payment>> getThisWeekPayments(
      String financeId, String branchName, String subBranchName) {
    try {
      DateTime today = DateUtils.getCurrentDate();

      return getAllPaymentsByDateRange(
          financeId,
          branchName,
          subBranchName,
          today.subtract(Duration(days: today.weekday)),
          today.add(Duration(days: 1)));
    } catch (err) {
      throw err;
    }
  }

  Future<List<Payment>> getThisMonthPayments(
      String financeId, String branchName, String subBranchName) {
    try {
      DateTime today = DateUtils.getCurrentDate();

      return getAllPaymentsByDateRange(
          financeId,
          branchName,
          subBranchName,
          DateTime(today.year, today.month, 1, 0, 0, 0, 0),
          today.add(Duration(days: 1)));
    } catch (err) {
      throw err;
    }
  }

  Future<List<Payment>> getAllPaymentsByDateRange(
      String financeId,
      String branchName,
      String subBranchName,
      DateTime startDate,
      DateTime endDate) async {
    try {
      List<Payment> payments = await Payment().getAllPaymentsByDateRange(
          financeId,
          branchName,
          subBranchName,
          DateUtils.getUTCDateEpoch(startDate),
          DateUtils.getUTCDateEpoch(endDate));

      if (payments == null) {
        return [];
      }

      return payments;
    } catch (err) {
      throw err;
    }
  }

  Future updatePayment(
      Payment payment, Map<String, dynamic> paymentJSON) async {
    try {
      await Payment().updatePayment(payment, paymentJSON);

      return CustomResponse.getSuccesReponse(
          "Updated ${payment.customerNumber} customer's Payment");
    } catch (err) {
      print(
          "Error while updating ${payment.customerNumber}customer's Payment: " +
              err.toString());
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future settlement(Payment payment, Map<String, dynamic> paymentJSON) async {
    try {
      Collection coll = await Collection().getCollectionByID(
          payment.financeID,
          payment.branchName,
          payment.subBranchName,
          payment.customerNumber,
          payment.createdAt,
          paymentJSON['settled_date'].toString());

      if (coll != null && coll.getReceived() > 0) {
        String sDate = DateUtils.formatDate(
            DateTime.fromMillisecondsSinceEpoch(paymentJSON['settled_date']));
        throw "Already a Collection received on this day $sDate";
      }

      await payment.settlement(paymentJSON);

      return CustomResponse.getSuccesReponse(
          "Updated ${payment.customerNumber} customer's Payment");
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future removePayment(
    String financeId,
    String branchName,
    String subBranchName,
    int custNumber,
    DateTime createdAt,
  ) async {
    try {
      await Payment().removePayment(
          financeId, branchName, subBranchName, custNumber, createdAt);

      return CustomResponse.getSuccesReponse(
          "Removed customer's Payment for customer $custNumber");
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }
}
