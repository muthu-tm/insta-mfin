import 'package:flutter/material.dart';
import 'package:instamfin/db/enums/gender.dart';
import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/AddressWidget.dart';
import 'package:instamfin/screens/utils/field_validator.dart';
import 'package:instamfin/services/controllers/customer/cust_controller.dart';

class EditCustomerProfile extends StatefulWidget {
  EditCustomerProfile(this.customer);

  final Map<String, dynamic> customer;

  @override
  _EditCustomerProfileState createState() => _EditCustomerProfileState();
}

class _EditCustomerProfileState extends State<EditCustomerProfile> {
  final Map<String, dynamic> updatedCustomer = Map();
  final Address updatedAddress = Address();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var groupValue = 0;

  @override
  Widget build(BuildContext context) {
    print(widget.customer);
    updatedCustomer['mobile_number'] = widget.customer['mobile_number'];

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: CustomColors.mfinGrey,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Edit - ${widget.customer['customer_name']}'),
        backgroundColor: CustomColors.mfinBlue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
          child: Container(
            color: CustomColors.mfinLightGrey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Card(
                  color: CustomColors.mfinLightGrey,
                  elevation: 5.0,
                  margin: EdgeInsets.only(top: 5.0),
                  shadowColor: CustomColors.mfinLightBlue,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 40,
                        alignment: Alignment.center,
                        child: Text(
                          "Personal Details",
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
                                initialValue: widget.customer['customer_name'],
                                textAlign: TextAlign.start,
                                decoration: InputDecoration(
                                  labelText: 'Customer name',
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
                                  fillColor: CustomColors.mfinLightGrey,
                                  filled: true,
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Enter Customer Name';
                                  }
                                  updatedCustomer['customer_name'] = value;
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                            ),
                            Flexible(
                              child: TextFormField(
                                initialValue: widget.customer['customer_id'],
                                textAlign: TextAlign.start,
                                decoration: InputDecoration(
                                  labelText: 'Customer ID',
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
                                  fillColor: CustomColors.mfinLightGrey,
                                  filled: true,
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Enter Customer ID';
                                  }
                                  updatedCustomer['customer_id'] = value;
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
                                initialValue: widget.customer['mobile_number'].toString(),
                                textAlign: TextAlign.start,
                                decoration: InputDecoration(
                                  labelText: 'Phone number',
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
                                  fillColor: CustomColors.mfinLightGrey,
                                  filled: true,
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Enter Phone number';
                                  }
                                  updatedCustomer['mobile_number'] = value;
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                            ),
                            Flexible(
                              child: TextFormField(
                                initialValue:
                                    widget.customer['customer_profession'],
                                textAlign: TextAlign.start,
                                decoration: InputDecoration(
                                  labelText: 'Profession',
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
                                  fillColor: CustomColors.mfinLightGrey,
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
                                initialValue: widget.customer['age'].toString(),
                                textAlign: TextAlign.start,
                                decoration: InputDecoration(
                                  labelText: 'Age',
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
                                  fillColor: CustomColors.mfinLightGrey,
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
                            Padding(
                              padding: EdgeInsets.all(10),
                            ),
                            Flexible(
                              child: TextFormField(
                                initialValue:
                                    widget.customer['guarantied_by'].toString(),
                                textAlign: TextAlign.start,
                                decoration: InputDecoration(
                                  labelText: 'Guarantee by',
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
                                  fillColor: CustomColors.mfinLightGrey,
                                  filled: true,
                                ),
                                validator: (val) {
                                  if (val.trim().isEmpty) {
                                    updatedCustomer['guarantied_by'] = '';
                                    return null;
                                  } else {
                                    return FieldValidator.mobileValidator(
                                        val.trim(), setGuarantiedBy);
                                  }
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
                    "Address Details",
                    Address.fromJson(widget.customer['address']),
                    updatedAddress),
                Padding(padding: EdgeInsets.all(40))
              ],
            ),
          ),
        ),
      ),
    );
  }

  setGuarantiedBy(String guranteeNumber) {
    updatedCustomer['guarantied_by'] = int.parse(guranteeNumber);
  }

  setSelectedRadio(int val) {
    this.groupValue = val;
    if (val == 0) {
      updatedCustomer['gender'] = Gender.Male.name;
    } else {
      updatedCustomer['gender'] = Gender.Female.name;
    }
  }

  Future<void> _submit() async {
    final FormState form = _formKey.currentState;

    if (form.validate()) {
      CustomDialogs.actionWaiting(context, "Updating Profile");
      CustController _cc = CustController();
      updatedCustomer['address'] = updatedAddress.toJson();
      var result = await _cc.updateCustomer(
          updatedCustomer, widget.customer['mobile_number']);

      if (!result['is_success']) {
        Navigator.pop(context);
        _scaffoldKey.currentState
            .showSnackBar(CustomSnackBar.errorSnackBar(result['message'], 2));
        print("Customer profile update failed: " + result['message']);
      } else {
        Navigator.pop(context);
        print("Updated Customer profile data");
        Navigator.pop(context);
      }
    } else {
      print('Form not valid');
      _scaffoldKey.currentState.showSnackBar(
          CustomSnackBar.errorSnackBar("Please fill valid data!", 2));
    }
  }
}
