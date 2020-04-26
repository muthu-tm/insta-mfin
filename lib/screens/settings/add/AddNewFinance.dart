import 'package:flutter/material.dart';
import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/screens/settings/SettingsScreen.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/AddressWidget.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/EditorBottomButtons.dart';
import 'package:instamfin/screens/utils/RowHeaderText.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/screens/utils/field_validator.dart';
import 'package:instamfin/services/controllers/finance/finance_controller.dart';

class AddFinancePage extends StatefulWidget {
  @override
  _AddFinancePageState createState() => _AddFinancePageState();
}

class _AddFinancePageState extends State<AddFinancePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode myFocusNode = FocusNode();

  DateTime selectedDate = DateTime.now();
  var dateFormatter = DateUtils.dateFormatter;
  String financeName;
  String registeredID = "";
  String registeredDate = "";
  String contactNumber = "";
  String emailID = "";

  Address address = new Address();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: CustomColors.mfinGrey,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Add Finance'),
        backgroundColor: CustomColors.mfinBlue,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: new Container(
            height: MediaQuery.of(context).size.height * 1.16,
            color: CustomColors.mfinLightGrey,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RowHeaderText(textName: "Finance Name"),
                ListTile(
                  title: TextFormField(
                    keyboardType: TextInputType.text,
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
                    validator: (name) {
                      if (name.trim().isEmpty) {
                        return 'Enter the Finance Name';
                      }

                      this.financeName = name.trim();
                      return null;
                    },
                  ),
                ),
                RowHeaderText(textName: "Registration ID"),
                ListTile(
                  title: TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'Registration ID',
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
                        this.registeredID = registeredID.trim();
                      }

                      return null;
                    },
                  ),
                ),
                RowHeaderText(textName: "Registered Date"),
                ListTile(
                  title: new TextFormField(
                    controller: _date,
                    decoration: InputDecoration(
                      hintText: DateUtils.getCurrentFormattedDate(),
                      fillColor: CustomColors.mfinWhite,
                      filled: true,
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 3.0, horizontal: 3.0),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: CustomColors.mfinWhite)),
                    ),
                    onTap: () => _selectDate(context),
                  ),
                ),
                RowHeaderText(textName: "Contact Number"),
                ListTile(
                  title: new TextFormField(
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: 'Finance Contact Number',
                        fillColor: CustomColors.mfinWhite,
                        filled: true,
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 3.0, horizontal: 3.0),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: CustomColors.mfinWhite)),
                      ),
                      validator: (number) {
                        if (number.trim().isNotEmpty) {
                          return FieldValidator.mobileValidator(
                              number.trim(), setContactNumber);
                        }
                      }),
                ),
                RowHeaderText(textName: "Finance EmailID"),
                ListTile(
                  title: new TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Finance EmailID',
                        fillColor: CustomColors.mfinWhite,
                        filled: true,
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 3.0, horizontal: 3.0),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: CustomColors.mfinWhite)),
                      ),
                      validator: (email) {
                        if (email.trim().isNotEmpty) {
                          return FieldValidator.emailValidator(
                              email.trim(), setEmailID);
                        }
                      }),
                ),
                AddressWidget("Office Address", new Address(), address),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: EditorsActionButtons(_submit, _close),
      // bottomNavigationBar: bottomBar(context),
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
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        this.registeredDate = DateUtils.formatDate(picked);
        _date.value = TextEditingValue(text: DateUtils.formatDate(picked));
      });
  }

  _submit() async {
    final FormState form = _formKey.currentState;

    if (form.validate()) {
      CustomDialogs.actionWaiting(context, "Creating Finance for YOU!");
      FinanceController _financeController = FinanceController();
      var result = await _financeController.createFinance(financeName,
          registeredID, contactNumber, emailID, address, registeredDate);

      if (!result['is_success']) {
        Navigator.pop(context);
        _scaffoldKey.currentState
            .showSnackBar(CustomSnackBar.errorSnackBar(result['message'], 5));
        print("Unable to Create Finance: " + result['message']);
      } else {
        Navigator.pop(context);
        print("New Finance created successfully");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingsScreen()),
        );
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
