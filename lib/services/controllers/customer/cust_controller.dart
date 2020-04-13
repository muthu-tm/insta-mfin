import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/db/models/customer.dart';
import 'package:instamfin/services/utils/response_utils.dart';

class CustController {
  Future createCustomer(String name, String customerID, String branchID, String subBranchID, int mobileNumber,
      Address address, int age, int guarantiedBy, String displayProfilePath, int addedBy) async {
    try {
      String custDocumentId = "";

      if (subBranchID != null || subBranchID != "") {
        custDocumentId = custDocumentId + subBranchID;
      } else {
        custDocumentId += custDocumentId + branchID;
      }

      custDocumentId = custDocumentId + '_' + customerID;
      Customer cust = Customer(custDocumentId);
      
      cust.setName(name);
      cust.setBranchID(branchID);
      cust.setSubBranchID(subBranchID);
      cust.setMobileNumber(mobileNumber);
      cust.setAddress(address);
      cust.setAge(age);
      cust.setGuarantiedBy(guarantiedBy);
      cust.setDisplayProfilePath(displayProfilePath);
      cust.setAddedBy(addedBy);

      await cust.create();

      return CustomResponse.getSuccesReponse(cust);
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future updateCompany(Customer customer) async {
    try {
      customer = await customer.replace();

      return CustomResponse.getFailureReponse(customer);
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }
}
