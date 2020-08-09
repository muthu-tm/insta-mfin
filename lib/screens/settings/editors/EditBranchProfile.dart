import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/db/models/branch.dart';
import 'package:instamfin/screens/utils/AddressWidget.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/RowHeaderText.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/screens/utils/field_validator.dart';
import 'package:instamfin/services/controllers/finance/branch_controller.dart';
import 'package:instamfin/app_localizations.dart';

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

  @override
  void initState() {
    super.initState();
    if (widget.branch.dateOfRegistration != null)
      this._date.text = DateUtils.formatDate(
          DateTime.fromMillisecondsSinceEpoch(
              widget.branch.dateOfRegistration));
    else
      this._date.text = DateUtils.formatDate(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: CustomColors.mfinWhite,
      appBar: AppBar(
        title:
            Text(AppLocalizations.of(context).translate('edit_branch_profile')),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                RowHeaderText(
                    textName:
                        AppLocalizations.of(context).translate('branch_name')),
                ListTile(
                  title: TextFormField(
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    initialValue: widget.branch.branchName,
                    decoration: InputDecoration(
                      hintText:
                          AppLocalizations.of(context).translate('branch_name'),
                      fillColor: CustomColors.mfinWhite,
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 3.0, horizontal: 3.0),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: CustomColors.mfinWhite)),
                    ),
                    enabled: false,
                    autofocus: false,
                  ),
                ),
                RowHeaderText(
                    textName: AppLocalizations.of(context)
                        .translate('contact_number')),
                ListTile(
                  title: TextFormField(
                    keyboardType: TextInputType.phone,
                    initialValue: widget.branch.contactNumber,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)
                          .translate('contact_number'),
                      fillColor: CustomColors.mfinWhite,
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(
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
                RowHeaderText(
                    textName: AppLocalizations.of(context)
                        .translate('branch_emailid')),
                ListTile(
                  title: TextFormField(
                    keyboardType: TextInputType.text,
                    initialValue: widget.branch.emailID,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)
                          .translate('enter_email_id'),
                      fillColor: CustomColors.mfinWhite,
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(
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
                AddressWidget(
                    "Branch Address", widget.branch.address, updatedAddress),
              ],
            ),
          ),
        ),
      ),
    );
  }

  setEmailID(String emailID) {
    updatedBranch['email'] = emailID;
  }

  setContactNumber(String contactNumber) {
    updatedBranch['contact_number'] = contactNumber;
  }

  TextEditingController _date = TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate:
          DateTime.fromMillisecondsSinceEpoch(widget.branch.dateOfRegistration),
      firstDate: DateTime(1900, 1),
      lastDate: DateTime.now(),
    );
    if (picked != null)
      setState(() {
        _date.text = DateUtils.formatDate(picked);
        updatedBranch['date_of_registration'] =
            DateUtils.getUTCDateEpoch(picked);
      });
  }

  _submit() async {
    final FormState form = _formKey.currentState;

    if (form.validate()) {
      CustomDialogs.actionWaiting(context, "Updating Branch!");
      BranchController _branchController = BranchController();
      updatedBranch['address'] = updatedAddress.toJson();
      var result = await _branchController.updateBranch(
          widget.financeID, widget.branch.branchName, updatedBranch);

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
          AppLocalizations.of(context).translate('required_fields'), 5));
    }
  }
}
