import 'package:flutter/material.dart';
import 'package:instamfin/db/enums/gender.dart';
import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/AddressWidget.dart';
import 'package:instamfin/screens/utils/EditorBottomButtons.dart';
import 'package:instamfin/screens/utils/RowHeaderText.dart';
import 'package:instamfin/screens/utils/field_validator.dart';
import 'package:instamfin/services/controllers/customer/cust_controller.dart';

class EditCustomerProfile extends StatefulWidget {
  EditCustomerProfile(this.customer);

  final Map<String, dynamic> customer;

  @override
  _EditCustomerProfileState createState() => _EditCustomerProfileState();
}

class _EditCustomerProfileState extends State<EditCustomerProfile> {
  final Map<String, dynamic> updatedCustomer = new Map();
  final Address updatedAddress = new Address();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var groupValue = 0;

  @override
  Widget build(BuildContext context) {
    updatedCustomer['mobile_number'] = widget.customer['mobile_number'];

    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: CustomColors.mfinGrey,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Edit - ${widget.customer['customer_name']}'),
        backgroundColor: CustomColors.mfinBlue,
      ),
      body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: new Container(
              height: MediaQuery.of(context).size.height * 1.25,
              color: CustomColors.mfinLightGrey,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RowHeaderText(textName: 'Name'),
                  ListTile(
                    title: TextFormField(
                      keyboardType: TextInputType.text,
                      initialValue: widget.customer['customer_name'],
                      decoration: InputDecoration(
                        hintText: 'Customer Name',
                        fillColor: CustomColors.mfinWhite,
                        filled: true,
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 3.0, horizontal: 3.0),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: CustomColors.mfinWhite)),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter Customer Name';
                        }
                        updatedCustomer['customer_name'] = value;
                      },
                    ),
                  ),
                  RowHeaderText(textName: 'Customer ID'),
                  ListTile(
                    title: new TextFormField(
                        keyboardType: TextInputType.text,
                        initialValue: widget.customer['customer_id'],
                        decoration: InputDecoration(
                          hintText: 'Enter Customer ID',
                          fillColor: CustomColors.mfinWhite,
                          filled: true,
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 3.0),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: CustomColors.mfinWhite)),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter Customer ID';
                          }
                          updatedCustomer['customer_id'] = value;
                        }),
                  ),
                  RowHeaderText(textName: 'Age'),
                  ListTile(
                    title: new TextFormField(
                      keyboardType: TextInputType.text,
                      initialValue: widget.customer['age'].toString(),
                      decoration: InputDecoration(
                        hintText: 'Enter Customer Age',
                        fillColor: CustomColors.mfinWhite,
                        filled: true,
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 3.0, horizontal: 3.0),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: CustomColors.mfinWhite)),
                      ),
                      validator: (val) {
                        if (val.trim().isEmpty) {
                          updatedCustomer['age'] = 0;
                          return null;
                        } else {
                          updatedCustomer['age'] = val.trim();
                        }
                      },
                    ),
                  ),
                  RowHeaderText(textName: 'Profession'),
                  ListTile(
                    title: new TextFormField(
                      initialValue: widget.customer['customer_profession'],
                      decoration: InputDecoration(
                        hintText: "Customer Profession",
                        fillColor: CustomColors.mfinWhite,
                        filled: true,
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 3.0, horizontal: 3.0),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: CustomColors.mfinWhite),
                        ),
                      ),
                      validator: (val) {
                        if (val.trim().isEmpty) {
                          updatedCustomer['customer_profession'] = '';
                          return null;
                        } else {
                          updatedCustomer['customer_profession'] = val.trim();
                        }
                      },
                    ),
                  ),
                  RowHeaderText(textName: 'Gender'),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      ButtonBar(
                        alignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Radio(
                            value: 0,
                            groupValue: groupValue,
                            activeColor: CustomColors.mfinBlue,
                            onChanged: (val) {
                              setSelectedRadio(val);
                            },
                          ),
                          Text(
                            "Male",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black38,
                            ),
                          ),
                          Radio(
                            value: 1,
                            groupValue: groupValue,
                            activeColor: CustomColors.mfinBlue,
                            onChanged: (val) {
                              setSelectedRadio(val);
                            },
                          ),
                          Text(
                            "Female",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black38,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  RowHeaderText(textName: 'Guarantied by'),
                  ListTile(
                    title: new TextFormField(
                      initialValue: widget.customer['guarantied_by'].toString(),
                      decoration: InputDecoration(
                        hintText: "Referred/Gurantied by",
                        fillColor: CustomColors.mfinWhite,
                        filled: true,
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 3.0, horizontal: 3.0),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: CustomColors.mfinWhite)),
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
                  AddressWidget(
                      "Address",
                      Address.fromJson(widget.customer['address']),
                      updatedAddress),
                ],
              ),
            ),
          )),
      bottomSheet: EditorsActionButtons(() {
        _submit();
      }, () {
        Navigator.pop(context);
      }),
      // bottomNavigationBar: bottomBar(context),
    );
  }

  setGuarantiedBy(String guranteeNumber) {
    updatedCustomer['guarantied_by'] = guranteeNumber;
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
