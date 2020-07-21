import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/db/models/customer.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/services/analytics/analytics.dart';
import 'package:instamfin/services/controllers/notification/n_utils.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:instamfin/services/utils/response_utils.dart';

class CustController {
  UserController uc = UserController();

  Future createCustomer(
      String name,
      String customerID,
      String gender,
      String profession,
      int mobileNumber,
      int joinedAt,
      Address address,
      int age,
      int guarantiedBy) async {
    try {
      Customer cust = Customer();
      User user = uc.getCurrentUser();

      Customer customer = await cust.getByMobileNumber(mobileNumber);
      if (customer != null) {
        throw 'Unable to create! Found an existing customer ${customer.name} with this contact number!';
      }

      cust.setName(name);
      cust.setCustomerID(customerID);
      cust.setGender(gender);
      cust.setMobileNumber(mobileNumber);
      cust.setJoinedAt(joinedAt);
      cust.setAddress(address);
      cust.setAge(age);
      cust.setProfession(profession);
      if (guarantiedBy == 0) {
        cust.setGuarantiedBy(user.mobileNumber);
      } else {
        cust.setGuarantiedBy(guarantiedBy);
      }
      cust.setFinanceID(user.primary.financeID);
      cust.setBranchName(user.primary.branchName);
      cust.setSubBranchName(user.primary.subBranchName);
      cust.setAddedBy(user.mobileNumber);

      await cust.create();

      NUtils.financeNotify("", "NEW Customer OnBoard",
          "New Customer $name onboarded by ${user.mobileNumber}.!");

      return CustomResponse.getSuccesReponse(cust.toJson());
    } catch (err) {
      Analytics.reportError({
        "type": 'customer_create_error',
        "cust_number": mobileNumber,
        'name': name,
        'error': err.toString()
      });
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Stream<List<Customer>> streamPendingCustomers() async* {
    try {
      Stream<QuerySnapshot> stream = Customer().streamCustomersByStatus(1);

      if (await stream.isEmpty) {
        yield [];
      }

      List<Customer> customers = [];

      await for (var event in stream) {
        for (var doc in event.documents) {
          Customer cust = Customer.fromJson(doc.data);
          if (2 == await cust.getStatus(cust.id)) customers.add(cust);
        }
        yield customers;
      }
    } catch (err) {
      throw err;
    }
  }

  Future updateCustomer(Map<String, dynamic> customerJson, int custUUID) async {
    try {
      Customer customer = Customer();
      if (customerJson.containsKey('mobile_number') && customerJson['mobile_number'] != null) {
        Customer cust =
            await customer.getByMobileNumber(customerJson['mobile_number']);
        if (cust != null) {
          throw 'Unable to create! Found an existing customer ${customer.name} with this contact number!';
        }
      }

      String docID = customer.getDocumentID(custUUID);
      var result = await customer.updateByID(customerJson, docID);

      return CustomResponse.getSuccesReponse(result);
    } catch (err) {
      Analytics.reportError(
          {"type": 'customer_update_error', 'error': err.toString()});
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future removeCustomer(int custUUID) async {
    try {
      Customer customer = Customer();
      var payments = await customer.getPayments(custUUID);

      if (payments != null) {
        return null;
      }

      await customer.remove(custUUID);

      return CustomResponse.getSuccesReponse("Successfully removed customer!");
    } catch (err) {
      Analytics.reportError(
          {"type": 'customer_remove_error', 'error': err.toString()});
      return CustomResponse.getFailureReponse(err.toString());
    }
  }
}
