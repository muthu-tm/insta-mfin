import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/db/models/finance.dart';
import 'package:instamfin/screens/utils/AddressWidget.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/RowHeaderText.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/screens/utils/field_validator.dart';
import 'package:instamfin/services/controllers/finance/finance_controller.dart';
import 'package:instamfin/app_localizations.dart';

class EditFinanceProfile extends StatefulWidget {
  EditFinanceProfile(this.finance);

  final Finance finance;
  @override
  _EditFinanceProfileState createState() => _EditFinanceProfileState();
}

class _EditFinanceProfileState extends State<EditFinanceProfile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> updatedFinance = new Map();
  final Address updatedAddress = new Address();

  @override
  void initState() {
    super.initState();
    if (widget.finance.dateOfRegistration != null)
      this._date.text = DateUtils.formatDate(
          DateTime.fromMillisecondsSinceEpoch(
              widget.finance.dateOfRegistration));
    else
      this._date.text = DateUtils.formatDate(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.finance.financeName),
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
                    textName: AppLocalizations.of(context).translate('name')),
                ListTile(
                  title: TextFormField(
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    initialValue: widget.finance.financeName,
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
                    validator: (value) {
                      if (value.isEmpty) {
                        return AppLocalizations.of(context)
                            .translate('enter_finance_name');
                      }
                      updatedFinance['finance_name'] = value;
                      return null;
                    },
                  ),
                ),
                RowHeaderText(textName: 'Registered ID'),
                ListTile(
                  title: TextFormField(
                    keyboardType: TextInputType.text,
                    initialValue: widget.finance.registrationID,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)
                          .translate('registration_id'),
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
                        updatedFinance['registration_id'] = registeredID;
                      } else {
                        updatedFinance['registration_id'] = "";
                      }

                      return null;
                    },
                  ),
                ),
                RowHeaderText(
                    textName: AppLocalizations.of(context).translate('email')),
                ListTile(
                  title: TextFormField(
                    keyboardType: TextInputType.text,
                    initialValue: widget.finance.emailID,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)
                          .translate('finance_email_id'),
                      fillColor: CustomColors.mfinWhite,
                      filled: true,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.mfinWhite),
                      ),
                    ),
                    validator: (email) {
                      if (email.trim().isEmpty) {
                        setEmailID("");
                        return null;
                      } else {
                        return FieldValidator.emailValidator(
                            email.trim(), setEmailID);
                      }
                    },
                  ),
                ),
                RowHeaderText(
                    textName: AppLocalizations.of(context)
                        .translate('contact_number')),
                ListTile(
                  title: TextFormField(
                    keyboardType: TextInputType.phone,
                    initialValue: widget.finance.contactNumber,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)
                          .translate('contact_number'),
                      fillColor: CustomColors.mfinWhite,
                      filled: true,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: CustomColors.mfinWhite)),
                    ),
                    validator: (number) {
                      if (number.trim().isEmpty) {
                        setContactNumber("");
                        return null;
                      } else {
                        return FieldValidator.mobileValidator(
                            number.trim(), setContactNumber);
                      }
                    },
                  ),
                ),
                RowHeaderText(
                    textName: AppLocalizations.of(context)
                        .translate('registered_date')),
                ListTile(
                  title: GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _date,
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
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
                AddressWidget(
                    "Office Address", widget.finance.address, updatedAddress),
                Padding(padding: EdgeInsets.all(35)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  setEmailID(String emailID) {
    updatedFinance['email'] = emailID;
  }

  setContactNumber(String contactNumber) {
    updatedFinance['contact_number'] = contactNumber;
  }

  TextEditingController _date = TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: widget.finance.dateOfRegistration != null
          ? DateTime.fromMillisecondsSinceEpoch(
              widget.finance.dateOfRegistration)
          : DateTime.now(),
      firstDate: DateTime(1900, 1),
      lastDate: DateTime.now(),
    );
    if (picked != null)
      setState(() {
        _date.text = DateUtils.formatDate(picked);
        updatedFinance['date_of_registration'] =
            DateUtils.getUTCDateEpoch(picked);
      });
  }

  _submit() async {
    final FormState form = _formKey.currentState;

    if (form.validate()) {
      CustomDialogs.actionWaiting(context, "Updating Finance!");
      FinanceController _financeController = FinanceController();
      updatedFinance['address'] = updatedAddress.toJson();
      var result = await _financeController.updateFinance(
          updatedFinance, widget.finance.getID());

      if (!result['is_success']) {
        Navigator.pop(context);
        _scaffoldKey.currentState
            .showSnackBar(CustomSnackBar.errorSnackBar(result['message'], 5));
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
      }
    } else {
      _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
          AppLocalizations.of(context).translate('required_fields'), 2));
    }
  }
}
