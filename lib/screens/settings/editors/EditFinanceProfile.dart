import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/db/models/finance.dart';
import 'package:instamfin/screens/utils/AddressWidget.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/EditorBottomButtons.dart';
import 'package:instamfin/screens/utils/RowHeaderText.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/screens/utils/field_validator.dart';
import 'package:instamfin/services/controllers/finance/finance_controller.dart';

class EditFinanceProfile extends StatefulWidget {
  EditFinanceProfile(this.finance);

  final Finance finance;
  @override
  _EditFinanceProfileState createState() => _EditFinanceProfileState();
}

class _EditFinanceProfileState extends State<EditFinanceProfile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();
  final Map<String, dynamic> updatedFinance = new Map();
  final Address updatedAddress = new Address();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: CustomColors.mfinGrey,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Edit Finance Profile'),
        backgroundColor: CustomColors.mfinBlue,
      ),
      body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: new Container(
              color: CustomColors.mfinLightGrey,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RowHeaderText(textName: 'Name'),
                  ListTile(
                    title: TextFormField(
                      keyboardType: TextInputType.text,
                      initialValue: widget.finance.financeName,
                      decoration: InputDecoration(
                        hintText: 'Finance Name',
                        fillColor: CustomColors.mfinWhite,
                        filled: true,
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 3.0, horizontal: 3.0),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: CustomColors.mfinWhite)),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter Finance Name';
                        }
                        updatedFinance['finance_name'] = value;
                        return null;
                      },
                    ),
                  ),
                  RowHeaderText(textName: 'Registered ID'),
                  ListTile(
                    title: new TextFormField(
                      keyboardType: TextInputType.text,
                      initialValue: widget.finance.registrationID,
                      decoration: InputDecoration(
                        hintText: 'Registered ID',
                        fillColor: CustomColors.mfinWhite,
                        filled: true,
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 3.0, horizontal: 3.0),
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
                  RowHeaderText(textName: 'Email'),
                  ListTile(
                    title: new TextFormField(
                      keyboardType: TextInputType.text,
                      initialValue: widget.finance.emailID,
                      decoration: InputDecoration(
                        hintText: 'Finance EmailID',
                        fillColor: CustomColors.mfinWhite,
                        filled: true,
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 3.0, horizontal: 3.0),
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
                  RowHeaderText(textName: 'Contact Number'),
                  ListTile(
                    title: new TextFormField(
                      keyboardType: TextInputType.phone,
                      initialValue: widget.finance.contactNumber,
                      decoration: InputDecoration(
                        hintText: 'Contact Number',
                        fillColor: CustomColors.mfinWhite,
                        filled: true,
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 3.0, horizontal: 3.0),
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
                  RowHeaderText(textName: 'Registered Date'),
                  ListTile(
                    title: new TextFormField(
                      decoration: InputDecoration(
                        hintText: DateUtils.formatDate(selectedDate),
                        fillColor: CustomColors.mfinWhite,
                        filled: true,
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 3.0, horizontal: 3.0),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: CustomColors.mfinWhite)),
                        suffixIcon: Icon(
                          Icons.perm_contact_calendar,
                          color: CustomColors.mfinBlue,
                          size: 35.0,
                        ),
                      ),
                      onTap: () => _selectDate(context),
                    ),
                  ),
                  AddressWidget(
                      "Office Address", widget.finance.address, updatedAddress),
                ],
              ),
            ),
          )),
      bottomSheet: EditorsActionButtons(_submit, _close),
    );
  }

  setEmailID(String emailID) {
    updatedFinance['email'] = emailID;
  }

  setContactNumber(String contactNumber) {
    updatedFinance['contact_number'] = contactNumber;
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        updatedFinance['date_of_registration'] = DateUtils.formatDate(picked);
      });
  }

  _submit() async {
    final FormState form = _formKey.currentState;

    if (form.validate()) {
      CustomDialogs.actionWaiting(context, "Updating your Finance!");
      FinanceController _financeController = FinanceController();
      updatedFinance['address'] = updatedAddress.toJson();
      var result = await _financeController.updateFinance(
          updatedFinance, widget.finance.getID());

      if (!result['is_success']) {
        Navigator.pop(context);
        _scaffoldKey.currentState
            .showSnackBar(CustomSnackBar.errorSnackBar(result['message'], 5));
        print("Unable to update Finance: " + result['message']);
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
        print("Finance updated successfully");
        Navigator.pop(context);
      }
    } else {
      print("Invalid form submitted");
      _scaffoldKey.currentState.showSnackBar(
          CustomSnackBar.errorSnackBar("Please fill required fields!", 2));
    }
  }

  _close() {
    Navigator.pop(context);
  }
}
