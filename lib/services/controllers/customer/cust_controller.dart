import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/db/models/customer.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:instamfin/services/utils/response_utils.dart';

class CustController {
  UserController uc = UserController();

  Future createCustomer(String name, String customerID, String profession,
      int mobileNumber, Address address, int age, int guarantiedBy) async {
    try {
      Customer cust = Customer();
      User user = uc.getCurrentUser();

      Customer customer = await cust.getByMobileNumber(mobileNumber);
      if (customer != null) {
        throw 'Unable to create! Found an existing customer ${customer.name} with this contact number!';
      }

      cust.setName(name);
      cust.setCustomerID(customerID);
      cust.setMobileNumber(mobileNumber);
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

      return CustomResponse.getSuccesReponse(cust.toJson());
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
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

      return CustomResponse.getSuccesReponse("Successfully removed customer!");
    } catch (err) {
      print("Error while removing customer $mobileNumber: " + err.toString());
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future replaceCustomer(Customer customer) async {
    try {
      customer = await customer.replace();

      return CustomResponse.getFailureReponse(customer.toJson());
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }
}
