import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/db/models/branch.dart';
import 'package:instamfin/screens/settings/FinanceSetting.dart';
import 'package:instamfin/screens/utils/AddressWidget.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/EditorBottomButtons.dart';
import 'package:instamfin/screens/utils/RowHeaderText.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/screens/utils/field_validator.dart';
import 'package:instamfin/services/controllers/finance/branch_controller.dart';

class EditBranchProfile extends StatefulWidget {
  EditBranchProfile(this.financeID, this.branch);

  final String financeID;
  final Branch branch;

  @override
  _EditBranchProfileState createState() => _EditBranchProfileState();
}

class _EditBranchProfileState extends State<EditBranchProfile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Address updatedAddress = new Address();
  final Map<String, dynamic> updatedBranch = new Map();

  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: CustomColors.mfinWhite,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Edit Branch Profile'),
        backgroundColor: CustomColors.mfinBlue,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: new Container(
            height: MediaQuery.of(context).size.height * 1.05,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                RowHeaderText(textName: 'Branch Name'),
                ListTile(
                  title: TextFormField(
                    keyboardType: TextInputType.text,
                    initialValue: widget.branch.branchName,
                    decoration: InputDecoration(
                      hintText: 'Branch Name',
                      fillColor: CustomColors.mfinWhite,
                      filled: true,
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 3.0, horizontal: 3.0),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: CustomColors.mfinWhite)),
                    ),
                    enabled: false,
                    autofocus: false,
                  ),
                ),
                RowHeaderText(textName: 'Contact Number'),
                ListTile(
                  title: new TextFormField(
                    keyboardType: TextInputType.phone,
                    initialValue: widget.branch.contactNumber,
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
                RowHeaderText(textName: 'Branch EmailID'),
                ListTile(
                  title: new TextFormField(
                    keyboardType: TextInputType.text,
                    initialValue: widget.branch.emailID,
                    decoration: InputDecoration(
                      hintText: 'Enter your EmailID',
                      fillColor: CustomColors.mfinWhite,
                      filled: true,
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 3.0, horizontal: 3.0),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: CustomColors.mfinWhite)),
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
                AddressWidget("Address", widget.branch.address, updatedAddress),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: EditorsActionButtons(_submit, _close),
    );
  }

  setEmailID(String emailID) {
    updatedBranch['email'] = emailID;
  }

  setContactNumber(String contactNumber) {
    updatedBranch['contact_number'] = contactNumber;
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
        updatedBranch['date_of_registration'] = DateUtils.formatDate(picked);
      });
  }

  _submit() async {
    final FormState form = _formKey.currentState;

    if (form.validate()) {
      CustomDialogs.actionWaiting(context, "Updating Branch ${widget.branch.branchName}!");
      BranchController _branchController = BranchController();
      updatedBranch['address'] = updatedAddress.toJson();
      var result = await _branchController.updateBranch(
          widget.financeID, widget.branch.branchName, updatedBranch);

      if (!result['is_success']) {
        Navigator.pop(context);
        _scaffoldKey.currentState
            .showSnackBar(CustomSnackBar.errorSnackBar(result['message'], 5));
        print("Unable to update branch ${widget.branch.branchName}: " + result['message']);
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
        print("${widget.branch.branchName} branch updated successfully");
        Navigator.pop(context);
      }
    } else {
      print("Invalid form submitted");
      _scaffoldKey.currentState.showSnackBar(
          CustomSnackBar.errorSnackBar("Please fill required fields!", 5));
    }
  }

  _close() {
    Navigator.pop(context);
  }
}
