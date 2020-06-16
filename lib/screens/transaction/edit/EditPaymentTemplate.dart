import 'package:flutter/material.dart';
import 'package:instamfin/db/models/payment_template.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/services/controllers/transaction/paymentTemp_controller.dart';

class EditPaymentTemplate extends StatefulWidget {
  EditPaymentTemplate(this.template);
  final PaymentTemplate template;

  @override
  _EditPaymentTemplateState createState() => _EditPaymentTemplateState();
}

class _EditPaymentTemplateState extends State<EditPaymentTemplate> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> updatedTemplate = new Map();

  String templateName;
  int totalAmount;
  int givenAmount;
  int documentCharge;
  int surChargeAmount;
  int noOfPayments;
  double interestRate;
  int collectionAmount;
  String selectedCollectionModeID = "0";
  String selectedCollectionDayID = "0";

  Map<String, String> _tempCollectionMode = {
    "0": "Daily",
    "1": "Weekly",
    "2": "Monthly"
  };
  Map<String, String> _tempCollectionDays = {
    "0": "Sunday",
    "1": "Monday",
    "2": "Tuesday",
    "3": "Wednesday",
    "4": "Thursday",
    "5": "Friday",
    "6": "Saturday",
  };

  @override
  void initState() {
    super.initState();
    selectedCollectionModeID = widget.template.collectionMode.toString();
    selectedCollectionDayID = widget.template.collectionDay.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      //backgroundColor: CustomColors.mfinGrey,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Edit Template'),
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
                              initialValue: widget.template.name,
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
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                              ),
                              validator: (name) {
                                if (name.trim().isEmpty) {
                                  return 'Enter the Template Name';
                                } else if (name.trim() !=
                                    widget.template.name) {
                                  updatedTemplate['template_name'] =
                                      name.trim();
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
                              initialValue:
                                  widget.template.totalAmount.toString(),
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
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                              ),
                              validator: (amount) {
                                if (amount.trim().isNotEmpty ||
                                    amount.trim() !=
                                        widget.template.totalAmount
                                            .toString()) {
                                  updatedTemplate['total_amount'] =
                                      int.parse(amount);
                                } else {
                                  updatedTemplate['total_amount'] = 0;
                                  return null;
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(10)),
                          Flexible(
                            child: TextFormField(
                              initialValue:
                                  widget.template.principalAmount.toString(),
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
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                              ),
                              validator: (amount) {
                                if (amount.trim().isNotEmpty ||
                                    amount.trim() !=
                                        widget.template.principalAmount
                                            .toString()) {
                                  updatedTemplate['principal_amount'] =
                                      int.parse(amount);
                                } else {
                                  updatedTemplate['principal_amount'] = 0;
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
                              initialValue:
                                  widget.template.docCharge.toString(),
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
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                              ),
                              validator: (charge) {
                                if (charge.trim().isEmpty) {
                                  return 'Enter the Document Charge';
                                } else if (charge.trim() !=
                                    widget.template.docCharge.toString()) {
                                  updatedTemplate['doc_charge'] =
                                      int.parse(charge);
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(10)),
                          Flexible(
                            child: TextFormField(
                              initialValue:
                                  widget.template.surcharge.toString(),
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
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                              ),
                              validator: (surcharge) {
                                if (surcharge.trim().isEmpty) {
                                  return 'Enter the Surcharge';
                                } else if (surcharge.trim() !=
                                    widget.template.surcharge.toString()) {
                                  updatedTemplate['surcharge'] =
                                      int.parse(surcharge);
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
                              initialValue: widget.template.tenure.toString(),
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
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                              ),
                              validator: (noOfPayment) {
                                if (noOfPayment.trim().isEmpty) {
                                  return 'Enter the Number of Payments';
                                } else if (noOfPayment.trim() !=
                                    widget.template.tenure.toString()) {
                                  updatedTemplate['tenure'] =
                                      int.parse(noOfPayment);
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(10)),
                          Flexible(
                            child: TextFormField(
                              initialValue:
                                  widget.template.interestRate.toString(),
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
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                              ),
                              validator: (interest) {
                                if (interest.trim().isEmpty) {
                                  return 'Enter the Interest Rate';
                                } else if (interest.trim() !=
                                    widget.template.interestRate.toString()) {
                                  updatedTemplate['interest_rate'] =
                                      double.parse(interest);
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
                              initialValue:
                                  widget.template.collectionAmount.toString(),
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
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                              ),
                              validator: (collectionAmount) {
                                if (collectionAmount.trim().isEmpty) {
                                  return 'Enter the Collection Amount';
                                } else if (collectionAmount.trim() !=
                                    widget.template.collectionAmount
                                        .toString()) {
                                  updatedTemplate['collection_amount'] =
                                      int.parse(collectionAmount);
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(10)),
                          Flexible(
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'Collection mode',
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
    );
  }

  void _setSelectedCollectionMode(String newVal) {
    setState(() {
      selectedCollectionModeID = newVal;
      updatedTemplate['collection_mode'] = int.parse(newVal);
    });
  }

  void _setSelectedCollectionDay(String newVal) {
    setState(() {
      selectedCollectionDayID = newVal;
      updatedTemplate['collection_day'] = int.parse(newVal);
    });
  }

  void _submit() async {
    final FormState form = _formKey.currentState;

    if (form.validate()) {
      if (updatedTemplate.length == 0) {
        _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
            "No changes detected, Skipping update!", 1));
        Navigator.pop(context);
      } else {
        CustomDialogs.actionWaiting(context, "Updating Template");
        PaymentTemplateController _collectionController =
            PaymentTemplateController();
        var result = await _collectionController.updateTemp(
            widget.template.getDocumentID(), updatedTemplate);

        if (!result['is_success']) {
          Navigator.pop(context);
          _scaffoldKey.currentState
              .showSnackBar(CustomSnackBar.errorSnackBar(result['message'], 5));
          print("Unable to Edit Template: " + result['message']);
        } else {
          Navigator.pop(context);
          print("Template edited successfully");
          Navigator.pop(context);
        }
      }
    } else {
      print("Invalid form submitted");
      _scaffoldKey.currentState.showSnackBar(
          CustomSnackBar.errorSnackBar("Please fill required fields!", 2));
    }
  }
}
