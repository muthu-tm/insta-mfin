import 'package:flutter/material.dart';
import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/db/models/customer.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/AddressWidget.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/screens/utils/field_validator.dart';
import 'package:instamfin/services/controllers/customer/cust_controller.dart';

import '../../app_localizations.dart';

class EditCustomerProfile extends StatefulWidget {
  EditCustomerProfile(this.cust);

  final Customer cust;

  @override
  _EditCustomerProfileState createState() => _EditCustomerProfileState();
}

class _EditCustomerProfileState extends State<EditCustomerProfile> {
  final Map<String, dynamic> updatedCustomer = Map();
  final Address updatedAddress = Address();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _date = new TextEditingController();
  var groupValue = 0;
  String gender;

  @override
  void initState() {
    super.initState();

    gender = widget.cust.gender;

    _date.value = TextEditingValue(
      text: DateUtils.getFormattedDateFromEpoch(widget.cust.joinedAt),
    );
  }

  @override
  Widget build(BuildContext context) {
    updatedCustomer['id'] = widget.cust.id;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Edit - ${widget.cust.firstName}'),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Card(
                  color: CustomColors.mfinLightGrey,
                  elevation: 5.0,
                  margin: EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 40,
                        alignment: Alignment.center,
                        child: Text(
                          AppLocalizations.of(context)
                              .translate('personal_details'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Georgia",
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinBlue,
                          ),
                        ),
                      ),
                      Divider(
                        color: CustomColors.mfinBlue,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              child: TextFormField(
                                initialValue: widget.cust.mobileNumber != null
                                    ? widget.cust.mobileNumber.toString()
                                    : '',
                                textAlign: TextAlign.start,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  prefixText: " +91 ",
                                  prefixStyle: TextStyle(
                                    fontSize: 16.0,
                                    color: CustomColors.mfinBlue,
                                  ),
                                  labelText: AppLocalizations.of(context)
                                      .translate('mobile'),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  labelStyle: TextStyle(
                                    color: CustomColors.mfinBlue,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 3.0, horizontal: 10.0),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: CustomColors
                                              .mfinFadedButtonGreen)),
                                  fillColor: CustomColors.mfinWhite,
                                  filled: true,
                                ),
                                validator: (value) {
                                  if (value.trim().isNotEmpty &&
                                      (widget.cust.mobileNumber !=
                                          int.parse(value.trim()))) {
                                    updatedCustomer['mobile_number'] =
                                        int.parse(value.trim());
                                  } else {
                                    updatedCustomer['mobile_number'] = null;
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(left: 10)),
                            Flexible(
                              child: TextFormField(
                                initialValue: widget.cust.customerID,
                                textAlign: TextAlign.start,
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)
                                      .translate('customer_id'),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  labelStyle: TextStyle(
                                    color: CustomColors.mfinBlue,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 3.0, horizontal: 10.0),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: CustomColors
                                              .mfinFadedButtonGreen)),
                                  fillColor: CustomColors.mfinWhite,
                                  filled: true,
                                ),
                                validator: (value) {
                                  if (value.isNotEmpty) {
                                    updatedCustomer['customer_id'] = value;
                                  } else {
                                    updatedCustomer['customer_id'] = null;
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              child: TextFormField(
                                initialValue: widget.cust.firstName,
                                textAlign: TextAlign.start,
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)
                                      .translate('first_name'),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  labelStyle: TextStyle(
                                    color: CustomColors.mfinBlue,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 3.0, horizontal: 10.0),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: CustomColors
                                              .mfinFadedButtonGreen)),
                                  fillColor: CustomColors.mfinWhite,
                                  filled: true,
                                ),
                                validator: (value) =>
                                    FieldValidator.customerNameValidator(
                                        value, setCustomerNameState),
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(left: 10)),
                            Flexible(
                              child: TextFormField(
                                initialValue: widget.cust.lastName,
                                textAlign: TextAlign.start,
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)
                                      .translate('last_name'),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  labelStyle: TextStyle(
                                    color: CustomColors.mfinBlue,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 3.0, horizontal: 10.0),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: CustomColors
                                              .mfinFadedButtonGreen)),
                                  fillColor: CustomColors.mfinWhite,
                                  filled: true,
                                ),
                                validator: (value) {
                                  if (value.isNotEmpty) {
                                    updatedCustomer['last_name'] = value;
                                  } else {
                                    updatedCustomer['last_name'] = "";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: EdgeInsets.only(top: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            border: Border.all(
                                color: CustomColors.mfinGrey, width: 1.0),
                          ),
                          child: Column(
                            children: <Widget>[
                              Text(
                                AppLocalizations.of(context)
                                    .translate('gender'),
                                style: TextStyle(
                                  color: CustomColors.mfinBlue,
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Flexible(
                                    flex: 2,
                                    child: RadioListTile(
                                      title: Text(
                                        "\u{1F466}",
                                        style: TextStyle(
                                            color: CustomColors.mfinBlue),
                                      ),
                                      value: "Male",
                                      selected: gender.contains("Male"),
                                      groupValue: gender,
                                      onChanged: (val) {
                                        setState(() {
                                          gender = val;
                                          updatedCustomer['gender'] = val;
                                        });
                                      },
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .translate('male'),
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: CustomColors.mfinBlue,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 2,
                                    child: RadioListTile(
                                      title: Text(
                                        "\u{1F467}",
                                        style: TextStyle(
                                            color: CustomColors.mfinBlue),
                                      ),
                                      value: "Female",
                                      selected: gender.contains("Female"),
                                      groupValue: gender,
                                      onChanged: (val) {
                                        setState(() {
                                          gender = val;
                                          updatedCustomer['gender'] = val;
                                        });
                                      },
                                    ),
                                  ),
                                  Flexible(
                                    flex: 2,
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .translate('female'),
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: CustomColors.mfinBlue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              child: GestureDetector(
                                onTap: () => _selectedDate(context),
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    controller: _date,
                                    keyboardType: TextInputType.datetime,
                                    decoration: InputDecoration(
                                      labelText: AppLocalizations.of(context)
                                          .translate('joined_on'),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      labelStyle: TextStyle(
                                        color: CustomColors.mfinBlue,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 3.0, horizontal: 10.0),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: CustomColors.mfinWhite)),
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
                            Padding(padding: EdgeInsets.only(left: 10)),
                            Flexible(
                              child: TextFormField(
                                initialValue: widget.cust.profession,
                                textAlign: TextAlign.start,
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)
                                      .translate('profession'),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  labelStyle: TextStyle(
                                    color: CustomColors.mfinBlue,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 3.0, horizontal: 10.0),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: CustomColors
                                              .mfinFadedButtonGreen)),
                                  fillColor: CustomColors.mfinWhite,
                                  filled: true,
                                ),
                                validator: (val) {
                                  if (val.trim().isEmpty) {
                                    updatedCustomer['customer_profession'] = '';
                                  } else {
                                    updatedCustomer['customer_profession'] =
                                        val.trim();
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              child: TextFormField(
                                initialValue: widget.cust.age.toString(),
                                textAlign: TextAlign.start,
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)
                                      .translate('age'),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  labelStyle: TextStyle(
                                    color: CustomColors.mfinBlue,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 3.0, horizontal: 10.0),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: CustomColors
                                              .mfinFadedButtonGreen)),
                                  fillColor: CustomColors.mfinWhite,
                                  filled: true,
                                ),
                                validator: (val) {
                                  if (val.trim().isEmpty) {
                                    updatedCustomer['age'] = 0;
                                  } else {
                                    updatedCustomer['age'] =
                                        int.parse(val.trim());
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(left: 10)),
                            Flexible(
                              child: TextFormField(
                                initialValue:
                                    widget.cust.guarantiedBy.toString(),
                                textAlign: TextAlign.start,
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)
                                      .translate('guarantee_by'),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  labelStyle: TextStyle(
                                    color: CustomColors.mfinBlue,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 3.0, horizontal: 10.0),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: CustomColors
                                              .mfinFadedButtonGreen)),
                                  fillColor: CustomColors.mfinWhite,
                                  filled: true,
                                ),
                                validator: (val) {
                                  if (val.trim().isEmpty) {
                                    updatedCustomer['guarantied_by'] = '';
                                  } else {
                                    updatedCustomer['guarantied_by'] =
                                        val.trim();
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                AddressWidget(
                    "Address Details", widget.cust.address, updatedAddress),
                Padding(padding: EdgeInsets.all(35))
              ],
            ),
          ),
        ),
      ),
    );
  }

  setCustomerNameState(name) {
    updatedCustomer['first_name'] = name.trim();
  }

  Future<Null> _selectedDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.fromMillisecondsSinceEpoch(widget.cust.joinedAt),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (picked != null &&
        picked != DateTime.fromMillisecondsSinceEpoch(widget.cust.joinedAt))
      setState(
        () {
          updatedCustomer['joined_at'] = DateUtils.getUTCDateEpoch(picked);
          _date.value = TextEditingValue(
            text: DateUtils.formatDate(picked),
          );
        },
      );
  }

  setGuarantiedBy(String guranteeNumber) {
    updatedCustomer['guarantied_by'] = int.parse(guranteeNumber);
  }

  Future<void> _submit() async {
    final FormState form = _formKey.currentState;

    if (form.validate()) {
      CustomDialogs.actionWaiting(context, "Updating Profile");
      CustController _cc = CustController();
      updatedCustomer['address'] = updatedAddress.toJson();
      var result = await _cc.updateCustomer(updatedCustomer, widget.cust.id);

      if (!result['is_success']) {
        Navigator.pop(context);
        _scaffoldKey.currentState
            .showSnackBar(CustomSnackBar.errorSnackBar(result['message'], 2));
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
      }
    } else {
      _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
          AppLocalizations.of(context).translate('please_fill'), 2));
    }
  }
}
