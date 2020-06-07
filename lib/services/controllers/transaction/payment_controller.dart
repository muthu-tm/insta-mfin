import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:instamfin/services/utils/response_utils.dart';

class PaymentController {
  Future createPayment(
      int custNumber,
      String paymentID,
      DateTime dateOfPay,
      int tAmount,
      int pAmount,
      int tenure,
      int amountPerColl,
      int collectionMode,
      DateTime collectionDate,
      int collectionDay,
      int docCharge,
      int surcharge,
      double iRate,
      String givenTo,
      String givenBy,
      String notes) async {
    try {
      UserController _uc = UserController();
      Payment pay = Payment();
      pay.setCustomerNumber(custNumber);
      pay.setPaymentID(paymentID);
      pay.setDOP(dateOfPay);
      pay.setGivenTo(givenTo);
      pay.setGivenBy(givenBy);
      pay.setAddedBy(_uc.getCurrentUserID());
      pay.setTotalAmount(tAmount);
      pay.setPrincipalAmount(pAmount);
      pay.setTenure(tenure);
      pay.setCollectionAmount(amountPerColl);
      pay.setCollectionMode(collectionMode);
      pay.setDocumentCharge(docCharge);
      pay.setSurcharge(surcharge);
      pay.setInterestRate(iRate);
      pay.setNotes(notes);
      pay.setIsActive(true);
      pay.setCSF(collectionDate);
      pay.setCollectionDay(collectionDay);

      await pay.create(custNumber);

      return CustomResponse.getSuccesReponse(
          "Created new Payment successfully");
    } catch (err) {
      print("Error while creating payment for $custNumber: " + err.toString());
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
      print("Error while retrieving payments for customer $custNumber:" +
          err.toString());
      throw err;
    }
  }

  Future<List<Payment>> getAllPaymentsByDateRage(
      String financeId,
      String branchName,
      String subBranchName,
      DateTime startDate,
      DateTime endDate) async {
    try {
      List<Payment> payments = await Payment().getAllPaymentsByDateRage(
          financeId, branchName, subBranchName, startDate, endDate);

      if (payments == null) {
        return [];
      }

      return payments;
    } catch (err) {
      print(
          "Error while retrieving payments with Date Range: " + err.toString());
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
      print(
          "Error while removing customer's Payment for customer $custNumber: " +
              err.toString());
      return CustomResponse.getFailureReponse(err.toString());
    }
  }
}
