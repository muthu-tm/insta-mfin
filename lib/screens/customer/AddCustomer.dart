import 'package:flutter/material.dart';
import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/screens/customer/CustomersHome.dart';
import 'package:instamfin/screens/utils/AddressWidget.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/screens/utils/field_validator.dart';
import 'package:instamfin/services/controllers/customer/cust_controller.dart';

class AddCustomer extends StatefulWidget {
  @override
  _AddCustomerState createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _date = TextEditingController();
  int selectedDate = DateUtils.getUTCDateEpoch(DateTime.now());

  String firstname = "";
  String lastname = "";
  String id = "";
  int number;
  String guarantiedBy;
  int age = 0;
  String profession = "";
  String gender;

  Address address = Address();
  @override
  void initState() {
    super.initState();
    _date.text = DateUtils.formatDate(DateTime.now());
    gender = 'Male';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('New Customer'),
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
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                prefixText: " +91 ",
                                prefixStyle: TextStyle(
                                  fontSize: 16.0,
                                  color: CustomColors.mfinBlue,
                                ),
                                labelText: 'Mobile',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelStyle: TextStyle(
                                  color: CustomColors.mfinBlue,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 10.0),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            CustomColors.mfinFadedButtonGreen)),
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                              ),
                              validator: (number) {
                                if (number.isEmpty) {
                                  this.number = null;
                                } else {
                                  this.number = int.parse(number.trim());
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 10)),
                          Flexible(
                            child: TextFormField(
                              initialValue: id,
                              keyboardType: TextInputType.text,
                              textAlign: TextAlign.center,
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
                                        color:
                                            CustomColors.mfinFadedButtonGreen)),
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                              ),
                              validator: (id) {
                                if (id.isEmpty) {
                                  this.id = null;
                                } else {
                                  this.id = id.trim();
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
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.sentences,
                              initialValue: firstname,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                labelText: 'First name',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelStyle: TextStyle(
                                  color: CustomColors.mfinBlue,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 10.0),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            CustomColors.mfinFadedButtonGreen)),
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                              ),
                              validator: (name) =>
                                  FieldValidator.customerNameValidator(
                                      name, setCustomerNameState),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 10)),
                          Flexible(
                            child: TextFormField(
                              initialValue: lastname,
                              keyboardType: TextInputType.text,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                labelText: 'Last name',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelStyle: TextStyle(
                                  color: CustomColors.mfinBlue,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 10.0),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            CustomColors.mfinFadedButtonGreen)),
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                              ),
                              validator: (lName) {
                                if (lName.isEmpty) {
                                  this.lastname = "";
                                } else {
                                  this.lastname = lName.trim();
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
                              'Gender',
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
                                    selected: true,
                                    groupValue: gender,
                                    onChanged: (val) {
                                      setState(() {
                                        gender = val;
                                      });
                                    },
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Text(
                                    'Male',
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
                                    groupValue: gender,
                                    onChanged: (val) {
                                      setState(() {
                                        gender = val;
                                      });
                                    },
                                  ),
                                ),
                                Flexible(
                                  flex: 2,
                                  child: Text(
                                    'Female',
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
                                    labelText: 'Joined On',
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
                              keyboardType: TextInputType.text,
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
                                        color:
                                            CustomColors.mfinFadedButtonGreen)),
                                fillColor: CustomColors.mfinWhite,
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
                              keyboardType: TextInputType.number,
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
                                        color:
                                            CustomColors.mfinFadedButtonGreen)),
                                fillColor: CustomColors.mfinWhite,
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
                          Padding(padding: EdgeInsets.only(left: 10)),
                          Flexible(
                            child: TextFormField(
                              keyboardType: TextInputType.text,
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
                                        color:
                                            CustomColors.mfinFadedButtonGreen)),
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                              ),
                              validator: (val) {
                                if (val.trim().isNotEmpty) {
                                  this.guarantiedBy = val;
                                } else {
                                  this.guarantiedBy = '';
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
              Padding(padding: EdgeInsets.all(35))
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> _selectedDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (picked != null)
      setState(
        () {
          selectedDate = DateUtils.getUTCDateEpoch(picked);
          _date.text = DateUtils.formatDate(picked);
        },
      );
  }

  _submit() async {
    final FormState form = _formKey.currentState;

    if (form.validate()) {
      CustomDialogs.actionWaiting(context, "Creating Customer!");
      CustController _cc = CustController();
      var result = await _cc.createCustomer(firstname, lastname, id, gender,
          profession, number, selectedDate, address, age, guarantiedBy);

      if (!result['is_success']) {
        Navigator.pop(context);
        _scaffoldKey.currentState
            .showSnackBar(CustomSnackBar.errorSnackBar(result['message'], 5));
      } else {
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
      _scaffoldKey.currentState.showSnackBar(
          CustomSnackBar.errorSnackBar("Please fill required fields!", 2));
    }
  }

  setCustomerNameState(name) {
    setState(() {
      this.firstname = name.trim();
    });
  }
}
