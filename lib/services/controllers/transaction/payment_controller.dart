import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:instamfin/services/utils/response_utils.dart';

class PaymentController {
  Future createPayment(
    int custNumber,
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

      await payment.create(custNumber);

      return CustomResponse.getSuccesReponse(
          "Created new Payment successfully");
    } catch (err) {
      print("Error while creating payment for $custNumber: " + err.toString());
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future<Payment> getPaymentByID(int custNumber, String paymentID) async {
    try {
      Payment payment = Payment();
      return await payment.getPaymentByID(custNumber, paymentID);
    } catch (err) {
      print("Error while retrieving Payment for ID $paymentID: " +
          err.toString());
      return null;
    }
  }

  Future<List<Payment>> getAllPayments(int custNumber) async {
    try {
      List<Payment> payments = await Payment().getAllPayments(custNumber);

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

  Future updatePayment(int custNumber, String paymentID,
      Map<String, dynamic> paymentJSON) async {
    try {
      await Payment().update(custNumber, paymentID, paymentJSON);

      return CustomResponse.getSuccesReponse("Updated Payment $paymentID");
    } catch (err) {
      print(
          "Error while updating Payment with ID $paymentID: " + err.toString());
      return CustomResponse.getFailureReponse(err.toString());
    }
  }
}
