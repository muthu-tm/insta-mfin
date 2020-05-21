import 'package:flutter/material.dart';
import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/screens/customer/CustomersFilteredView.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                ListTile(
                  leading: SizedBox(
                    width: 85,
                    child: Text(
                      "NAME",
                      style: TextStyle(
                          fontSize: 13,
                          fontFamily: "Georgia",
                          fontWeight: FontWeight.bold,
                          color: CustomColors.mfinGrey),
                    ),
                  ),
                  title: TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        color: CustomColors.mfinBlue,
                      ),
                      fillColor: CustomColors.mfinWhite,
                      filled: true,
                    ),
                    validator: (name) => FieldValidator.customerNameValidator(
                        name, setCustomerNameState),
                  ),
                ),
                ListTile(
                  leading: SizedBox(
                    width: 85,
                    child: Text(
                      "ID",
                      style: TextStyle(
                          fontSize: 13,
                          fontFamily: "Georgia",
                          fontWeight: FontWeight.bold,
                          color: CustomColors.mfinGrey),
                    ),
                  ),
                  title: new TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        color: CustomColors.mfinBlue,
                      ),
                      fillColor: CustomColors.mfinWhite,
                      filled: true,
                    ),
                    validator: (id) {
                      this.id = id.trim();
                      return null;
                    },
                  ),
                ),
                ListTile(
                  leading: SizedBox(
                    width: 85,
                    child: Text(
                      "CONTACT",
                      style: TextStyle(
                          fontSize: 13,
                          fontFamily: "Georgia",
                          fontWeight: FontWeight.bold,
                          color: CustomColors.mfinGrey),
                    ),
                  ),
                  title: new TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        color: CustomColors.mfinBlue,
                      ),
                      fillColor: CustomColors.mfinWhite,
                      filled: true,
                    ),
                    validator: (number) {
                      return FieldValidator.mobileValidator(
                          number.trim(), setContactNumber);
                    },
                  ),
                ),
                ListTile(
                  leading: SizedBox(
                    width: 85,
                    child: Text(
                      "PROFESSION",
                      style: TextStyle(
                          fontSize: 13,
                          fontFamily: "Georgia",
                          fontWeight: FontWeight.bold,
                          color: CustomColors.mfinGrey),
                    ),
                  ),
                  title: new TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
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
                    },
                  ),
                ),
                ListTile(
                  leading: SizedBox(
                    width: 85,
                    child: Text(
                      "AGE",
                      style: TextStyle(
                          fontSize: 13,
                          fontFamily: "Georgia",
                          fontWeight: FontWeight.bold,
                          color: CustomColors.mfinGrey),
                    ),
                  ),
                  title: new TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
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
                    },
                  ),
                ),
                ListTile(
                  leading: SizedBox(
                    width: 85,
                    child: Text(
                      "GUARANTY BY",
                      style: TextStyle(
                          fontSize: 13,
                          fontFamily: "Georgia",
                          fontWeight: FontWeight.bold,
                          color: CustomColors.mfinGrey),
                    ),
                  ),
                  title: new TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
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
                    },
                  ),
                ),
                AddressWidget("Customer Address", new Address(), address),
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
            builder: (context) => CustomersFilteredView(),
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
