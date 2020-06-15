import 'package:flutter/material.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/services/controllers/transaction/paymentTemp_controller.dart';

class AddPaymentTemplate extends StatefulWidget {
  @override
  _AddPaymentTemplateState createState() => _AddPaymentTemplateState();
}

class _AddPaymentTemplateState extends State<AddPaymentTemplate> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String templateName = '';
  int totalAmount = 0;
  int givenAmount = 0;
  int documentCharge = 0;
  int surChargeAmount = 0;
  int noOfPayments = 0;
  double interestRate = 0.00;
  int collectionAmount = 0;
  String selectedCollectionModeID = "0";
  String selectedCollectionDayID = "0";

  Map<String, String> _tempCollectionMode = {
    "0": "Daily",
    "1": "Weekly",
    "2": "Monthly"
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: CustomColors.mfinGrey,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Add Template'),
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
        child: Container(
          height: double.infinity,
          color: CustomColors.mfinWhite,
          child: SingleChildScrollView(
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
                          "Payment Template",
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
                                initialValue: templateName,
                                textAlign: TextAlign.start,
                                decoration: InputDecoration(
                                  labelText: 'Template name',
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
                                  fillColor: CustomColors.mfinLightGrey,
                                  filled: true,
                                ),
                                validator: (name) {
                                  if (name.trim().isEmpty) {
                                    return 'Enter the Template Name';
                                  }
                                  this.templateName = name.trim();
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
                                initialValue: totalAmount.toString(),
                                textAlign: TextAlign.start,
                                decoration: InputDecoration(
                                  labelText: 'Total amount',
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
                                  fillColor: CustomColors.mfinLightGrey,
                                  filled: true,
                                ),
                                validator: (amount) {
                                  if (amount.trim().isNotEmpty) {
                                    this.totalAmount = int.parse(amount);
                                  } else {
                                    this.totalAmount = 0;
                                    return null;
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(10)),
                            Flexible(
                              child: TextFormField(
                                initialValue: givenAmount.toString(),
                                textAlign: TextAlign.start,
                                decoration: InputDecoration(
                                  labelText: 'Amount given',
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
                                  fillColor: CustomColors.mfinLightGrey,
                                  filled: true,
                                ),
                                validator: (amount) {
                                  if (amount.trim().isNotEmpty) {
                                    this.givenAmount = int.parse(amount);
                                  } else {
                                    this.givenAmount = 0;
                                    return null;
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
                                initialValue: documentCharge.toString(),
                                textAlign: TextAlign.start,
                                decoration: InputDecoration(
                                  labelText: 'Document charge',
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
                                  fillColor: CustomColors.mfinLightGrey,
                                  filled: true,
                                ),
                                validator: (charge) {
                                  if (charge.trim().isEmpty) {
                                    return 'Enter Document charge';
                                  }
                                  this.documentCharge = int.parse(charge);
                                  return null;
                                },
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(10)),
                            Flexible(
                              child: TextFormField(
                                initialValue: surChargeAmount.toString(),
                                textAlign: TextAlign.start,
                                decoration: InputDecoration(
                                  labelText: 'Amount given',
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
                                  fillColor: CustomColors.mfinLightGrey,
                                  filled: true,
                                ),
                                validator: (surcharge) {
                                  if (surcharge.trim().isEmpty) {
                                    return 'Enter the Surcharge';
                                  }
                                  this.surChargeAmount = int.parse(surcharge);
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
                                initialValue: noOfPayments.toString(),
                                textAlign: TextAlign.start,
                                decoration: InputDecoration(
                                  labelText: 'No. of Collections',
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
                                  fillColor: CustomColors.mfinLightGrey,
                                  filled: true,
                                ),
                                validator: (noOfPayment) {
                                  if (noOfPayment.trim().isEmpty) {
                                    return 'Enter the Number of Payments';
                                  }
                                  this.noOfPayments = int.parse(noOfPayment);
                                  return null;
                                },
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(10)),
                            Flexible(
                              child: TextFormField(
                                initialValue: interestRate.toString(),
                                textAlign: TextAlign.start,
                                decoration: InputDecoration(
                                  labelText: 'Rate of interest',
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
                                  fillColor: CustomColors.mfinLightGrey,
                                  filled: true,
                                ),
                                validator: (interest) {
                                  if (interest.trim().isEmpty) {
                                    return 'Enter the Interest Rate';
                                  }
                                  this.interestRate = double.parse(interest);
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
                                initialValue: collectionAmount.toString(),
                                textAlign: TextAlign.start,
                                decoration: InputDecoration(
                                  labelText: 'Collection amount',
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
                                  fillColor: CustomColors.mfinLightGrey,
                                  filled: true,
                                ),
                                validator: (collectionAmount) {
                                  if (collectionAmount.trim().isEmpty) {
                                    return 'Enter the Collection Amount';
                                  }
                                  this.collectionAmount =
                                      int.parse(collectionAmount);
                                  return null;
                                },
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(10)),
                            Flexible(
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: 'Collection amount',
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
                                  fillColor: CustomColors.mfinLightGrey,
                                  filled: true,
                                ),
                                isExpanded: true,
                                items: _tempCollectionMode.entries.map(
                                  (f) {
                                    return DropdownMenuItem<String>(
                                      value: f.key,
                                      child: Text(f.value),
                                    );
                                  },
                                ).toList(),
                                onChanged: (newVal) {
                                  _setSelectedCollectionMode(newVal);
                                },
                                value: selectedCollectionModeID,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _setSelectedCollectionMode(String newVal) {
    setState(() {
      selectedCollectionModeID = newVal;
    });
  }

  _submit() async {
    final FormState form = _formKey.currentState;

    if (form.validate()) {
      CustomDialogs.actionWaiting(context, "Creating Template for YOU!");
      PaymentTemplateController _collectionController =
          PaymentTemplateController();
      var result = await _collectionController.createTemplate(
          templateName,
          totalAmount,
          givenAmount,
          noOfPayments,
          collectionAmount,
          int.parse(selectedCollectionModeID),
          int.parse(selectedCollectionDayID),
          documentCharge,
          surChargeAmount,
          interestRate);

      if (!result['is_success']) {
        Navigator.pop(context);
        _scaffoldKey.currentState
            .showSnackBar(CustomSnackBar.errorSnackBar(result['message'], 5));
        print("Unable to Create Template: " + result['message']);
      } else {
        Navigator.pop(context);
        print("New Template added successfully");
        Navigator.pop(context);
      }
    } else {
      print("Invalid form submitted");
      _scaffoldKey.currentState.showSnackBar(
          CustomSnackBar.errorSnackBar("Please fill required fields!", 2));
    }
  }
}
