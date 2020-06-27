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
      cust.setFinanceID(user.primaryFinance);
      cust.setBranchName(user.primaryBranch);
      cust.setSubBranchName(user.primarySubBranch);
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

  Stream<List<Customer>> streamCustomersByStatus(
      int status, bool fetchAll) async* {
    try {
      Stream<QuerySnapshot> stream = Customer().streamAllCustomers();

      if (await stream.isEmpty) {
        yield [];
      }

      List<Customer> customers = [];

      if (fetchAll) {
        await for (var event in stream) {
          for (var doc in event.documents) {
            customers.add(Customer.fromJson(doc.data));
          }
          yield customers;
        }
      } else {
        await for (var event in stream) {
          for (var doc in event.documents) {
            Customer cust = Customer.fromJson(doc.data);
            if (status == await cust.getStatus(cust.mobileNumber))
              customers.add(cust);
          }
          yield customers;
        }
      }
    } catch (err) {
      throw err;
    }
  }

  Future updateCustomer(
      Map<String, dynamic> customerJson, int mobileNumber) async {
    try {
      Customer customer = Customer();
      String docID = customer.getDocumentID(mobileNumber);
      var result = await customer.updateByID(customerJson, docID);

      return CustomResponse.getSuccesReponse(result);
    } catch (err) {
      Analytics.reportError({
        "type": 'customer_update_error',
        "cust_number": mobileNumber,
        'error': err.toString()
      });
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future removeCustomer(int mobileNumber, bool isForce) async {
    try {
      Customer customer = Customer();
      if (!isForce) {
        var payments = await customer.getPayments(mobileNumber);

        if (payments != null) {
          return null;
        }
      }

      await customer.remove(mobileNumber);

      NUtils.financeNotify(
          "", "Customer Removed!", "Customer $mobileNumber removed!");

      return CustomResponse.getSuccesReponse("Successfully removed customer!");
    } catch (err) {
      Analytics.reportError({
        "type": 'customer_remove_error',
        "cust_number": mobileNumber,
        'error': err.toString()
      });
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future replaceCustomer(Customer customer) async {
    try {
      customer = await customer.replace();

      return CustomResponse.getFailureReponse(customer.toJson());
    } catch (err) {
      Analytics.reportError({
        "type": 'customer_replace_error',
        "cust_number": customer.mobileNumber,
        'error': err.toString()
      });
      return CustomResponse.getFailureReponse(err.toString());
    }
  }
}
