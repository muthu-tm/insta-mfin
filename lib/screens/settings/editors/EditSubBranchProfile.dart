import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/db/models/sub_branch.dart';
import 'package:instamfin/screens/utils/AddressWidget.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/EditorBottomButtons.dart';
import 'package:instamfin/screens/utils/RowHeaderText.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/screens/utils/field_validator.dart';
import 'package:instamfin/services/controllers/finance/sub_branch_controller.dart';

class EditSubBranchProfile extends StatefulWidget {
  EditSubBranchProfile(this.financeID, this.branchName, this.subBranch);

  final String financeID;
  final String branchName;
  final SubBranch subBranch;

  @override
  _EditSubBranchProfileState createState() => _EditSubBranchProfileState();
}

class _EditSubBranchProfileState extends State<EditSubBranchProfile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Address updatedAddress = new Address();
  final Map<String, dynamic> updatedSubBranch = new Map();

  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: CustomColors.mfinWhite,
      appBar: AppBar(
        title: Text('Edit Sub Branch'),
        backgroundColor: CustomColors.mfinBlue,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _submit();
        },
        label: Text(
          "Save",
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
          child: new Container(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                RowHeaderText(textName: 'SubBranch Name'),
                ListTile(
                  title: TextFormField(
                    keyboardType: TextInputType.text,
                    initialValue: widget.subBranch.subBranchName,
                    decoration: InputDecoration(
                      hintText: 'SubBranch Name',
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
                    initialValue: widget.subBranch.contactNumber,
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
                RowHeaderText(textName: 'SubBranch EmailID'),
                ListTile(
                  title: new TextFormField(
                    keyboardType: TextInputType.text,
                    initialValue: widget.subBranch.emailID,
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
                AddressWidget(
                    "Address", widget.subBranch.address, updatedAddress),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: EditorsActionButtons(_submit, _close),
    );
  }

  setEmailID(String emailID) {
    updatedSubBranch['email'] = emailID;
  }

  setContactNumber(String contactNumber) {
    updatedSubBranch['contact_number'] = contactNumber;
  }

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
        updatedSubBranch['date_of_registration'] = DateUtils.formatDate(picked);
      });
  }

  _submit() async {
    final FormState form = _formKey.currentState;

    if (form.validate()) {
      CustomDialogs.actionWaiting(
          context, "Updating ${widget.subBranch.subBranchName}!");
      SubBranchController _subBranchController = SubBranchController();
      updatedSubBranch['address'] = updatedAddress.toJson();
      var result = await _subBranchController.updateSubBranch(widget.financeID,
          widget.branchName, widget.subBranch.subBranchName, updatedSubBranch);

      if (!result['is_success']) {
        Navigator.pop(context);
        _scaffoldKey.currentState
            .showSnackBar(CustomSnackBar.errorSnackBar(result['message'], 5));
        print("Unable to update SubBranch ${widget.subBranch.subBranchName}: " +
            result['message']);
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
        print(
            "${widget.subBranch.subBranchName} SubBranch updated successfully");
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
