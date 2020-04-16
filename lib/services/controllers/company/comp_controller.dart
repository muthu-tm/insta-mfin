import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/db/models/company.dart';
import 'package:instamfin/services/utils/response_utils.dart';

class CompanyController {
  Future createFinance(String name, String registeredID, List<String> emails,
      Address address, DateTime dateOfRegistration, int addedBy) async {
    try {
      Company financeCompany = Company();
      financeCompany.setFianceName(name);
      financeCompany.setRegistrationID(registeredID);
      financeCompany.setAddress(address);
      financeCompany.addEmails(emails);
      financeCompany.addAdmins([addedBy]);
      financeCompany.setAddedBy(addedBy);

      financeCompany = await financeCompany.create();

      return CustomResponse.getSuccesReponse(financeCompany.toJson());
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future getFinanceByUserID(String userID) async {
    try {
      Company finance = Company();
      List<Company> finances = await finance.getFinanceByUserID(userID);

      if (finances == null) {
        return [];
      }

      return finances;
    } catch (err) {
      print("Error while retrieving finace for an user: " + userID);
      return null;
    }
  }

  Future updateCompany(Company finance) async {
    try {
      finance = await finance.replace();

      return CustomResponse.getSuccesReponse(finance.toJson());
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }
}
