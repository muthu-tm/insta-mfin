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
      financeCompany.setAddedBy(addedBy);

      await financeCompany.create();

      return CustomResponse.getSuccesReponse(financeCompany);
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future updateCompany(Company finance) async {
    try {
      finance = await finance.replace();

      return CustomResponse.getSuccesReponse(finance);
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }
}
