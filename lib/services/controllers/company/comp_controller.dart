import 'package:flutter/material.dart';
import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/db/models/company.dart';

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

      return {"is_success": true, "message": financeCompany};
    } catch (err) {
      return {"is_success": true, "message": err.toString()};
    }
  }

  Future updateCompany(Company finance) async {
    try {
      finance = await finance.replace();

      return {"is_success": true, "message": finance};
    } catch (err) {
      return {"is_success": true, "message": err.toString()};
    }
  }
}
