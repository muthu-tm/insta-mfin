import 'package:instamfin/db/enums/payment_status.dart';
import 'package:instamfin/db/models/collection.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/services/controllers/customer/cust_controller.dart';
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
      int collectionMode,
      DateTime collectionDate,
      int collectionDay,
      int docCharge,
      int surcharge,
      double iRate,
      String givenTo,
      String givenBy,
      int status,
      int totalPaid,
      String notes) async {
    try {
      UserController _uc = UserController();
      Payment payment = Payment();
      payment.setCustomerNumber(custNumber);
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
      payment.setCollectionMode(collectionMode);
      payment.setDocumentCharge(docCharge);
      payment.setSurcharge(surcharge);
      payment.setInterestRate(iRate);
      payment.setNotes(notes);
      payment.setCollectionDate(collectionDate);
      payment.setCollectionDay(collectionDay);

      await payment.create(custNumber);

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

  Future<List<Payment>> getAllPaymentsByDateRage(String financeId,
      String branchName, String subBranchName, DateTime startDate, DateTime endDate) async {
    try {
      List<Payment> payments = await Payment().getAllPaymentsByDateRage(
          financeId, branchName, subBranchName, startDate, endDate);

      if (payments == null) {
        return [];
      }

      return payments;
    } catch (err) {
      print("Error while retrieving payments with Date Range: " +
          err.toString());
      throw err;
    }
  }

  Future<List<Payment>> getAllPaymentsByStatus(String financeId,
      String branchName, String subBranchName, int status) async {
    try {
      List<Payment> payments = await Payment()
          .getAllPaymentsByStatus(financeId, branchName, subBranchName, status);

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

  Future<int> getPaymentsAmountByStatus(String financeId, String branchName,
      String subBranchName, int status) async {
    try {
      List<Payment> payments = await getAllPaymentsByStatus(
          financeId, branchName, subBranchName, status);

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

  Future<Map<String, int>> getPaymentsCountByStatus(
      String financeId, String branchName, String subBranchName) async {
    try {
      Map<String, int> paymentsCount = Map();

      List<Payment> totalPayments = await Payment().getAllPayments(
        financeId,
        branchName,
        subBranchName,
      );
      paymentsCount['total_payments'] = totalPayments.length;

      List<Payment> activePayments = await getAllPaymentsByStatus(
          financeId, branchName, subBranchName, PaymentStatus.Active.name);
      paymentsCount['active_payments'] = activePayments.length;

      List<Payment> pendingPayments = await getAllPaymentsByStatus(
          financeId, branchName, subBranchName, PaymentStatus.Pending.name);
      paymentsCount['pending_payments'] = pendingPayments.length;

      List<Payment> closedPayments = await getAllPaymentsByStatus(
          financeId, branchName, subBranchName, PaymentStatus.Closed.name);
      paymentsCount['closed_payments'] = closedPayments.length;

      return paymentsCount;
    } catch (err) {
      print("Error while retrieving payments count:" + err.toString());
      throw err;
    }
  }

  Future updatePayment(
      Payment payment,
      Map<String, dynamic> paymentJSON) async {
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
      List<Collection> colls = await Collection()
          .getAllCollectionsForCustomerPayment(
              financeId, branchName, subBranchName, custNumber, createdAt);
      bool isNewPayment = true;
      for (int i=0; i< colls.length; i++){
        Collection coll = colls[i];
        // check for paid collections
        if (coll.status == 1) {
          isNewPayment = false;
        }
      }
      if (!isNewPayment) {
        return CustomResponse.getFailureReponse(
            "Unable to Remove Payment. It has PAID Collections! Remove this Payment's collections first.");
      }

      // Remove payment
      await Payment().removePayment(
          financeId, branchName, subBranchName, custNumber, createdAt);

      // Update customer status
      try {
        int custStatus = 0;
        List<Payment> payments = await getAllPaymentsForCustomer(financeId, branchName, subBranchName, custNumber);
        for (int index = 0; index < payments.length; index++ ) {
          Payment payment = payments[index];
          if (payment.status == 2) {
            custStatus = 2;
            break;
          } else if (payment.status == 3) {
            custStatus = 3;
          } else if (payment.status == 1) {
            custStatus = 1;
          }
        }

        await CustController().updateCustomer({'customer_status': custStatus}, custNumber);
      } catch (err) {
        throw 'Remove Payment, but unable to update customer status; Edit Customer status manually';
      }

      // Return success response
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
