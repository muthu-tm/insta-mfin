import 'package:flutter/material.dart';
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

class AddBranch extends StatefulWidget {
  AddBranch(this.financeID);

  final String financeID;

  @override
  _AddBranchState createState() => _AddBranchState();
}

class _AddBranchState extends State<AddBranch> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Branch branch = new Branch();
  DateTime selectedDate = DateTime.now();
  var dateFormatter = DateUtils.dateFormatter;
  String branchName;
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
        title: Text('Add Branch'),
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
            color: CustomColors.mfinLightGrey,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RowHeaderText(textName: "Branch Name"),
                ListTile(
                  title: TextFormField(
                    keyboardType: TextInputType.text,
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
                    validator: (name) {
                      if (name.trim().isEmpty) {
                        return 'Enter the Branch Name';
                      }

                      this.branchName = name.trim();
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
                        if (number.trim().isNotEmpty) {
                          return FieldValidator.mobileValidator(
                              number.trim(), setContactNumber);
                        } else {
                          this.contactNumber = "";
                          return null;
                        }
                      }),
                ),
                RowHeaderText(textName: "Branch EmailID"),
                ListTile(
                  title: new TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Branch EmailID',
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
                        } else {
                          this.emailID = "";
                          return null;
                        }
                      }),
                ),
                AddressWidget("Office Address", new Address(), address),
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
        this.registeredDate = DateUtils.formatDate(picked);
        _date.value = TextEditingValue(text: DateUtils.formatDate(picked));
      });
  }

  _submit() async {
    final FormState form = _formKey.currentState;

    if (form.validate()) {
      CustomDialogs.actionWaiting(context, "Creating Branch for YOU!");
      BranchController _branchController = BranchController();
      var result = await _branchController.addBranch(widget.financeID,
          branchName, contactNumber, emailID, address, registeredDate);

      if (!result['is_success']) {
        Navigator.pop(context);
        _scaffoldKey.currentState
            .showSnackBar(CustomSnackBar.errorSnackBar(result['message'], 5));
        print("Unable to Create Branch: " + result['message']);
      } else {
        Navigator.pop(context);
        print("New Branch added successfully");
        Navigator.pop(context);
      }
    } else {
      print("Invalid form submitted");
      _scaffoldKey.currentState.showSnackBar(
          CustomSnackBar.errorSnackBar("Please fill required fields!", 2));
    }
  }
}
