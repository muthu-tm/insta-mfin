import 'package:flutter/material.dart';
import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/AddressWidget.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/RowHeaderText.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/screens/utils/field_validator.dart';
import 'package:instamfin/services/controllers/finance/finance_controller.dart';
import 'package:instamfin/app_localizations.dart';

class AddFinancePage extends StatefulWidget {
  @override
  _AddFinancePageState createState() => _AddFinancePageState();
}

class _AddFinancePageState extends State<AddFinancePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();
  var dateFormatter = DateUtils.dateFormatter;
  String financeName;
  String registeredID = "";
  int registeredDate;
  String contactNumber = "";
  String emailID = "";

  Address address = Address();

  @override
  void initState() {
    super.initState();
    this._date.text = DateUtils.formatDate(selectedDate);
    this.registeredDate = DateUtils.getUTCDateEpoch(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('add_finance')),
        backgroundColor: CustomColors.mfinBlue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: CustomColors.mfinBlue,
        onPressed: () {
          _submit();
        },
        label: Text(
          AppLocalizations.of(context).translate('save'),
          style: TextStyle(
            fontSize: 17,
            fontFamily: "Georgia",
            fontWeight: FontWeight.bold,
          ),
        ),
        splashColor: CustomColors.mfinWhite,
        icon: Icon(
          Icons.check,
          size: 35,
          color: CustomColors.mfinFadedButtonGreen,
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            color: CustomColors.mfinLightGrey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RowHeaderText(
                    textName:
                        AppLocalizations.of(context).translate('finance_name')),
                ListTile(
                  title: TextFormField(
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)
                          .translate('finance_name'),
                      fillColor: CustomColors.mfinWhite,
                      filled: true,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: CustomColors.mfinWhite)),
                    ),
                    validator: (name) {
                      if (name.trim().isEmpty) {
                        return AppLocalizations.of(context)
                            .translate('enter_finance_name');
                      }

                      this.financeName = name.trim();
                      return null;
                    },
                  ),
                ),
                RowHeaderText(
                    textName: AppLocalizations.of(context)
                        .translate("registration_id")),
                ListTile(
                  title: TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)
                          .translate("registration_id"),
                      fillColor: CustomColors.mfinWhite,
                      filled: true,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: CustomColors.mfinWhite)),
                    ),
                    validator: (registeredID) {
                      if (registeredID.trim().isNotEmpty) {
                        this.registeredID = registeredID.trim();
                      }

                      return null;
                    },
                  ),
                ),
                RowHeaderText(
                    textName: AppLocalizations.of(context)
                        .translate("registered_date")),
                ListTile(
                  title: GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _date,
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextStyle(
                            color: CustomColors.mfinBlue,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 10.0),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: CustomColors.mfinWhite)),
                          fillColor: CustomColors.mfinWhite,
                          filled: true,
                          suffixIcon: Icon(
                            Icons.date_range,
                            size: 35,
                            color: CustomColors.mfinBlue,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                RowHeaderText(
                    textName: AppLocalizations.of(context)
                        .translate("finance_contact_number")),
                ListTile(
                  title: TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)
                          .translate("finance_contact_number"),
                      fillColor: CustomColors.mfinWhite,
                      filled: true,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: CustomColors.mfinWhite)),
                    ),
                    validator: (number) {
                      if (number.trim().isNotEmpty) {
                        return FieldValidator.mobileValidator(
                            number.trim(), setContactNumber);
                      }
                      return null;
                    },
                  ),
                ),
                RowHeaderText(
                    textName: AppLocalizations.of(context)
                        .translate("finance_email_id")),
                ListTile(
                  title: TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)
                          .translate("finance_email_id"),
                      fillColor: CustomColors.mfinWhite,
                      filled: true,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: CustomColors.mfinWhite)),
                    ),
                    validator: (email) {
                      if (email.trim().isNotEmpty) {
                        return FieldValidator.emailValidator(
                            email.trim(), setEmailID);
                      }
                      return null;
                    },
                  ),
                ),
                AddressWidget("Office Address", Address(), address),
                Padding(padding: EdgeInsets.only(top: 35.0, bottom: 35.0))
              ],
            ),
          ),
        ),
      ),
    );
  }

  setEmailID(String emailID) {
    this.emailID = emailID;
  }

  setContactNumber(String contactNumber) {
    this.contactNumber = contactNumber;
  }

  TextEditingController _date = new TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900, 1),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        this.registeredDate = DateUtils.getUTCDateEpoch(picked);
        _date.text = DateUtils.formatDate(picked);
      });
  }

  _submit() async {
    final FormState form = _formKey.currentState;

    if (form.validate()) {
      CustomDialogs.actionWaiting(context, "Creating Finance!");
      FinanceController _financeController = FinanceController();
      var result = await _financeController.createFinance(financeName,
          registeredID, contactNumber, emailID, address, registeredDate);

      if (!result['is_success']) {
        Navigator.pop(context);
        _scaffoldKey.currentState
            .showSnackBar(CustomSnackBar.errorSnackBar(result['message'], 5));
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
      }
    } else {
      _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
          AppLocalizations.of(context).translate("required_fields"), 2));
    }
  }
}
