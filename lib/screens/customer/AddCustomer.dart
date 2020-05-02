import 'package:flutter/material.dart';
import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/screens/customer/ViewCustomer.dart';
import 'package:instamfin/screens/utils/AddressWidget.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/EditorBottomButtons.dart';
import 'package:instamfin/screens/utils/field_validator.dart';
import 'package:instamfin/services/controllers/customer/cust_controller.dart';

class AddCustomer extends StatefulWidget {
  @override
  _AddCustomerState createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode myFocusNode = FocusNode();

  String name = "";
  String id = "";
  int number;
  int guarantiedBy;
  int age = 0;
  String profession = "";

  Address address = new Address();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: CustomColors.mfinGrey,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('New Customer'),
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
                ListTile(
                  title: TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Customer Name",
                      labelStyle: TextStyle(
                        color: CustomColors.mfinBlue,
                      ),
                      fillColor: CustomColors.mfinWhite,
                      filled: true,
                    ),
                    validator: (name) {
                      if (name.trim().isEmpty) {
                        return 'Enter the Customer Name';
                      }

                      this.name = name.trim();
                      return null;
                    },
                  ),
                ),
                ListTile(
                  title: new TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Customer ID",
                      labelStyle: TextStyle(
                        color: CustomColors.mfinBlue,
                      ),
                      fillColor: CustomColors.mfinWhite,
                      filled: true,
                    ),
                    validator: (id) {
                      if (id.trim().isEmpty) {
                        this.id = id.trim();
                      } else {
                        this.id = id.trim();
                      }

                      return null;
                    },
                  ),
                ),
                ListTile(
                  title: new TextFormField(
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Contact Number',
                        labelStyle: TextStyle(
                          color: CustomColors.mfinBlue,
                        ),
                        fillColor: CustomColors.mfinWhite,
                        filled: true,
                      ),
                      validator: (number) {
                        return FieldValidator.mobileValidator(
                            number.trim(), setContactNumber);
                      }),
                ),
                ListTile(
                  title: new TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Customer Profession',
                        labelStyle: TextStyle(
                          color: CustomColors.mfinBlue,
                        ),
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
                      }),
                ),
                ListTile(
                  title: new TextFormField(
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Customer Age',
                        labelStyle: TextStyle(
                          color: CustomColors.mfinBlue,
                        ),
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
                      }),
                ),
                ListTile(
                  title: new TextFormField(
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Guarantee by',
                        labelStyle: TextStyle(
                          color: CustomColors.mfinBlue,
                        ),
                        fillColor: CustomColors.mfinWhite,
                        filled: true,
                      ),
                      validator: (val) {
                        if (val.trim().isNotEmpty) {
                          this.guarantiedBy = int.parse(val);
                        } else {
                          this.guarantiedBy = 0;
                        }
                        return null;
                      }),
                ),
                AddressWidget("Customer Address", new Address(), address),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: EditorsActionButtons(_submit, _close),
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
          MaterialPageRoute(builder: (context) => ViewCustomer()),
          (Route<dynamic> route) => false,
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
