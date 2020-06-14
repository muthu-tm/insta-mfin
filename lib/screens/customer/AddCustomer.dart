import 'package:flutter/material.dart';
import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/screens/customer/CustomersHome.dart';
import 'package:instamfin/screens/utils/AddressWidget.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/field_validator.dart';
import 'package:instamfin/services/controllers/customer/cust_controller.dart';

class AddCustomer extends StatefulWidget {
  @override
  _AddCustomerState createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String name = "";
  String id = "";
  int number;
  int guarantiedBy;
  int age = 0;
  String profession = "";

  Address address = Address();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: CustomColors.mfinGrey,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('New Customer'),
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
                                initialValue: name,
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
                                validator: (name) =>
                                    FieldValidator.customerNameValidator(
                                        name, setCustomerNameState),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                            ),
                            Flexible(
                              child: TextFormField(
                                initialValue: id,
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
                                validator: (id) {
                                  if (id.isEmpty) {
                                    return 'Enter Customer ID';
                                  }
                                  this.id = id.trim();
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
                                //initialValue: number.toString(),
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
                                validator: (number) {
                                  return FieldValidator.mobileValidator(
                                      number.trim(), setContactNumber);
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                            ),
                            Flexible(
                              child: TextFormField(
                                initialValue: profession,
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
                                  if (val.trim().isNotEmpty) {
                                    this.profession = val;
                                  } else {
                                    this.profession = "";
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
                                initialValue: age.toString(),
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
                                  if (val.trim().isNotEmpty) {
                                    this.age = int.parse(val);
                                  } else {
                                    this.age = 0;
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
                                //initialValue: guarantiedBy.toString(),
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
                                  if (val.trim().isNotEmpty) {
                                    this.guarantiedBy = int.parse(val);
                                  } else {
                                    this.guarantiedBy = 0;
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
                AddressWidget("Address Details", Address(), address),
                Padding(padding: EdgeInsets.all(40))
              ],
            ),
          ),
        ),
      ),
    );
  }

  setContactNumber(String number) {
    this.number = int.parse(number);
  }

  _submit() async {
    final FormState form = _formKey.currentState;

    if (form.validate()) {
      CustomDialogs.actionWaiting(context, "Creating $name!");
      CustController _cc = CustController();
      var result = await _cc.createCustomer(
          name, id, profession, number, address, age, guarantiedBy);

      if (!result['is_success']) {
        Navigator.pop(context);
        _scaffoldKey.currentState
            .showSnackBar(CustomSnackBar.errorSnackBar(result['message'], 5));
        print("Unable to Create Customer: " + result['message']);
      } else {
        print("New Customer $name added successfully");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => CustomersHome(),
            settings: RouteSettings(name: '/customers'),
          ),
          (Route<dynamic> route) => false,
        );
      }
    } else {
      print("Invalid form submitted");
      _scaffoldKey.currentState.showSnackBar(
          CustomSnackBar.errorSnackBar("Please fill required fields!", 2));
    }
  }

  setCustomerNameState(name) {
    setState(() {
      this.name = name.trim();
    });
  }
}
