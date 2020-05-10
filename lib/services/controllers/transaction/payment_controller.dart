import 'package:instamfin/db/enums/payment_status.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:instamfin/services/utils/response_utils.dart';

class PaymentController {
  Future createPayment(
    int custNumber,
    DateTime dateOfPay,
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
      payment.setDOP(dateOfPay);
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

  Future<List<Payment>> getAllPaymentsForCustomer(int custNumber) async {
    try {
      List<Payment> payments =
          await Payment().getAllPaymentsForCustomer(custNumber);

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

  Future<List<Payment>> getAllPaymentsByStatus(int status) async {
    try {
      List<Payment> payments = await Payment().getAllPaymentsByStatus(status);

      if (payments == null) {
        return [];
      }

      return payments;
    } catch (err) {
      print("Error while retrieving payments with status $status:" +
          err.toString());
      throw err;
    }
  }

  Future<int> getPaymentsAmountByStatus(int status) async {
    try {
      List<Payment> payments = await getAllPaymentsByStatus(status);

      int tAmount = 0;
      if (payments == null) {
        return tAmount;
      }

      payments.forEach((payment) {
        tAmount += payment.totalAmount;
      });

      return tAmount;
    } catch (err) {
      print("Error while retrieving payments with status $status:" +
          err.toString());
      throw err;
    }
  }

  Future<Map<String, int>> getPaymentsCountByStatus() async {
    try {
      Map<String, int> paymentsCount = Map();

      List<Payment> totalPayments = await Payment().getAllPayments();
      paymentsCount['total_payments'] = totalPayments.length;

      List<Payment> activePayments =
          await getAllPaymentsByStatus(PaymentStatus.Active.name);
      paymentsCount['active_payments'] = activePayments.length;
      
      List<Payment> pendingPayments =
          await getAllPaymentsByStatus(PaymentStatus.Pending.name);
      paymentsCount['pending_payments'] = pendingPayments.length;
      
      List<Payment> closedPayments =
          await getAllPaymentsByStatus(PaymentStatus.Closed.name);
      paymentsCount['closed_payments'] = closedPayments.length;

      return paymentsCount;
    } catch (err) {
      print("Error while retrieving payments count:" + err.toString());
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
