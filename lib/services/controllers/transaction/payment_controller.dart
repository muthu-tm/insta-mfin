import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:instamfin/services/utils/response_utils.dart';

class PaymentController {
  Future createPayment(
    String custID,
    int tAmount,
    int pAmount,
    int tenure,
    int amountPerColl,
    int tenureType,
    int docCharge,
    int surcharge,
    double iRate,
    String givenTo,
    String givenBy,
    int status,
    int totalPaid,
  ) async {
    try {
      UserController _uc = UserController();
      Payment payment = Payment();
      payment.setGivenTo(givenTo);
      payment.setGivenBy(givenBy);
      payment.setPaymentStatus(status);
      payment.setTotalPaid(totalPaid);
      payment.setAddedBy(_uc.getCurrentUserID());
      payment.setTotalAmount(tAmount);
      payment.setPrincipalAmount(pAmount);
      payment.setTenure(tenure);
      payment.setCollectionAmount(amountPerColl);
      payment.setTenureType(tenureType);
      payment.setDocumentCharge(docCharge);
      payment.setSurcharge(surcharge);
      payment.setInterestRate(iRate);

      await payment.create(custID);

      return CustomResponse.getSuccesReponse(
          "Created new Payment successfully");
    } catch (err) {
      print("Error while creating payment for $custID: " + err.toString());
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future<Payment> getPaymentByID(String custID, String paymentID) async {
    try {
      Payment payment = Payment();
      return await payment.getPaymentByID(custID, paymentID);
    } catch (err) {
      print("Error while retrieving Payment for ID $paymentID: " +
          err.toString());
      return null;
    }
  }

  Future<List<Payment>> getAllPayments(String custID) async {
    try {
      List<Payment> payments = await Payment().getAllPayments(custID);

      if (payments == null) {
        return [];
      }

      return payments;
    } catch (err) {
      print("Error while retrieving payments for custID $custID:" +
          err.toString());
      throw err;
    }
  }

  Future updatePayment(
      String custID, String paymentID, Map<String, dynamic> paymentJSON) async {
    try {
      await Payment().update(custID, paymentID, paymentJSON);

      return CustomResponse.getSuccesReponse("Updated Payment $paymentID");
    } catch (err) {
      print(
          "Error while updating Payment with ID $paymentID: " + err.toString());
      return CustomResponse.getFailureReponse(err.toString());
    }
  }
}
