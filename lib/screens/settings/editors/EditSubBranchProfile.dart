import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/db/models/sub_branch.dart';
import 'package:instamfin/screens/utils/AddressWidget.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
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

  @override
  void initState() {
    super.initState();
    if (widget.subBranch.dateOfRegistration != null)
      this._date.text = DateUtils.formatDate(
          DateTime.fromMillisecondsSinceEpoch(
              widget.subBranch.dateOfRegistration));
    else
      this._date.text = DateUtils.formatDate(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: CustomColors.mfinWhite,
      appBar: AppBar(
        title: Text('Edit Sub Branch'),
        backgroundColor: CustomColors.mfinBlue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: CustomColors.mfinBlue,
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
                    readOnly: true,
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
                AddressWidget("SubBranch Address", widget.subBranch.address,
                    updatedAddress),
              ],
            ),
          ),
        ),
      ),
    );
  }

  setEmailID(String emailID) {
    updatedSubBranch['email'] = emailID;
  }

  setContactNumber(String contactNumber) {
    updatedSubBranch['contact_number'] = contactNumber;
  }

  TextEditingController _date = TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.fromMillisecondsSinceEpoch(
          widget.subBranch.dateOfRegistration),
      firstDate: DateTime(1900, 1),
      lastDate: DateTime.now(),
    );
    if (picked != null)
      setState(() {
        _date.text = DateUtils.formatDate(picked);
        updatedSubBranch['date_of_registration'] =
            DateUtils.getUTCDateEpoch(picked);
      });
  }

  _submit() async {
    final FormState form = _formKey.currentState;

    if (form.validate()) {
      CustomDialogs.actionWaiting(context, "Updating SubBranch!");
      SubBranchController _subBranchController = SubBranchController();
      updatedSubBranch['address'] = updatedAddress.toJson();
      var result = await _subBranchController.updateSubBranch(widget.financeID,
          widget.branchName, widget.subBranch.subBranchName, updatedSubBranch);

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
      _scaffoldKey.currentState.showSnackBar(
          CustomSnackBar.errorSnackBar("Please fill required fields!", 5));
    }
  }

  _close() {
    Navigator.pop(context);
  }
}
