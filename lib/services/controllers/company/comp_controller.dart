import 'package:flutter/material.dart';
import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/db/models/company.dart';
import 'package:instamfin/services/utils/response_utils.dart';

class CompanyController {
  Future createFinance(String name, String registeredID, List<String> emails,
      Address address, DateTime dateOfRegistration) async {
    try {
      String financeID = "";

      if (registeredID != null || registeredID != "") {
        financeID = financeID + registeredID;
      } else {
        financeID += financeID + UniqueKey().toString();
      }

      financeID +=
          financeID + '_' + DateTime.now().millisecondsSinceEpoch.toString();
      Company financeCompany = Company();
      financeCompany.setFianceName(name);
      financeCompany.setRegistrationID(registeredID);
      financeCompany.setAddress(address);
      financeCompany.addEmails(emails);

      financeCompany = await financeCompany.create();

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
