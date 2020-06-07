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
    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: CustomColors.mfinGrey,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Edit Template'),
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
          child: new Column(
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
                    ListTile(
                      leading: SizedBox(
                        width: 100,
                        child: Text(
                          "TEMPLATE NAME:",
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Georgia",
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinBlue,
                          ),
                        ),
                      ),
                      title: TextFormField(
                        keyboardType: TextInputType.text,
                        initialValue: widget.template.name,
                        decoration: InputDecoration(
                          hintText: 'Template Name',
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
                            return 'Enter the Template Name';
                          } else if (name.trim() != widget.template.name) {
                            updatedTemplate['template_name'] = name.trim();
                          }
                          return null;
                        },
                      ),
                    ),
                    ListTile(
                      leading: SizedBox(
                        width: 100,
                        child: Text(
                          "TOTAL AMOUNT:",
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Georgia",
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinBlue,
                          ),
                        ),
                      ),
                      title: new TextFormField(
                          keyboardType: TextInputType.number,
                          initialValue: widget.template.totalAmount.toString(),
                          decoration: InputDecoration(
                            hintText: 'Total Amount',
                            fillColor: CustomColors.mfinWhite,
                            filled: true,
                            contentPadding: new EdgeInsets.symmetric(
                                vertical: 3.0, horizontal: 3.0),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: CustomColors.mfinWhite)),
                          ),
                          validator: (amount) {
                            if (amount.trim().isNotEmpty ||
                                amount.trim() !=
                                    widget.template.totalAmount.toString()) {
                              updatedTemplate['total_amount'] =
                                  int.parse(amount);
                            } else {
                              updatedTemplate['total_amount'] = 0;
                              return null;
                            }
                            return null;
                          }),
                    ),
                    ListTile(
                      leading: SizedBox(
                        width: 100,
                        child: Text(
                          "AMOUNT GIVEN:",
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Georgia",
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinBlue,
                          ),
                        ),
                      ),
                      title: new TextFormField(
                          keyboardType: TextInputType.number,
                          initialValue:
                              widget.template.principalAmount.toString(),
                          decoration: InputDecoration(
                            hintText: 'Amount given',
                            fillColor: CustomColors.mfinWhite,
                            filled: true,
                            contentPadding: new EdgeInsets.symmetric(
                                vertical: 3.0, horizontal: 3.0),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: CustomColors.mfinWhite)),
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
                          }),
                    ),
                    ListTile(
                      leading: SizedBox(
                        width: 100,
                        child: Text(
                          "DOCUMENT CHARGE:",
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Georgia",
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinBlue,
                          ),
                        ),
                      ),
                      title: TextFormField(
                        keyboardType: TextInputType.number,
                        initialValue: widget.template.docCharge.toString(),
                        decoration: InputDecoration(
                          hintText: 'Document Charge',
                          fillColor: CustomColors.mfinWhite,
                          filled: true,
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 3.0),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: CustomColors.mfinWhite)),
                        ),
                        validator: (charge) {
                          if (charge.trim().isEmpty) {
                            return 'Enter the Document Charge';
                          } else if (charge.trim() !=
                              widget.template.docCharge.toString()) {
                            updatedTemplate['doc_charge'] = int.parse(charge);
                          }
                          return null;
                        },
                      ),
                    ),
                    ListTile(
                      leading: SizedBox(
                        width: 100,
                        child: Text(
                          "SERVICE CHARGE:",
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Georgia",
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinBlue,
                          ),
                        ),
                      ),
                      title: TextFormField(
                        keyboardType: TextInputType.number,
                        initialValue: widget.template.surcharge.toString(),
                        decoration: InputDecoration(
                          hintText: 'Service charge of any',
                          fillColor: CustomColors.mfinWhite,
                          filled: true,
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 3.0),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: CustomColors.mfinWhite)),
                        ),
                        validator: (surcharge) {
                          if (surcharge.trim().isEmpty) {
                            return 'Enter the Surcharge';
                          } else if (surcharge.trim() !=
                              widget.template.surcharge.toString()) {
                            updatedTemplate['surcharge'] = int.parse(surcharge);
                          }
                          return null;
                        },
                      ),
                    ),
                    ListTile(
                      leading: SizedBox(
                        width: 100,
                        child: Text(
                          "NUMBER OF PAYMENTS:",
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Georgia",
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinBlue,
                          ),
                        ),
                      ),
                      title: TextFormField(
                        keyboardType: TextInputType.number,
                        initialValue: widget.template.tenure.toString(),
                        decoration: InputDecoration(
                          hintText: 'Number of Payments',
                          fillColor: CustomColors.mfinWhite,
                          filled: true,
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 3.0),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: CustomColors.mfinWhite)),
                        ),
                        validator: (noOfPayment) {
                          if (noOfPayment.trim().isEmpty) {
                            return 'Enter the Number of Payments';
                          } else if (noOfPayment.trim() !=
                              widget.template.tenure.toString()) {
                            updatedTemplate['tenure'] = int.parse(noOfPayment);
                          }
                          return null;
                        },
                      ),
                    ),
                    ListTile(
                      leading: SizedBox(
                        width: 100,
                        child: Text(
                          "INTEREST PERCENTAGE:",
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Georgia",
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinBlue,
                          ),
                        ),
                      ),
                      title: TextFormField(
                        keyboardType: TextInputType.number,
                        initialValue: widget.template.interestRate.toString(),
                        decoration: InputDecoration(
                          hintText: 'Rate in 0.00%',
                          fillColor: CustomColors.mfinWhite,
                          filled: true,
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 3.0),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: CustomColors.mfinWhite)),
                        ),
                        validator: (intrest) {
                          if (intrest.trim().isEmpty) {
                            return 'Enter the Interest Rate';
                          } else if (intrest.trim() !=
                              widget.template.interestRate.toString()) {
                            updatedTemplate['interest_rate'] =
                                double.parse(intrest);
                          }
                          return null;
                        },
                      ),
                    ),
                    ListTile(
                      leading: SizedBox(
                        width: 100,
                        child: Text(
                          "COLLECTION AMOUNT:",
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Georgia",
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinBlue,
                          ),
                        ),
                      ),
                      title: TextFormField(
                        keyboardType: TextInputType.number,
                        initialValue:
                            widget.template.collectionAmount.toString(),
                        decoration: InputDecoration(
                          hintText: 'Collection Amount',
                          fillColor: CustomColors.mfinWhite,
                          filled: true,
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 3.0),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: CustomColors.mfinWhite)),
                        ),
                        validator: (collectionAmount) {
                          if (collectionAmount.trim().isEmpty) {
                            return 'Enter the Collection Amount';
                          } else if (collectionAmount.trim() !=
                              widget.template.collectionAmount.toString()) {
                            updatedTemplate['collection_amount'] =
                                int.parse(collectionAmount);
                          }
                          return null;
                        },
                      ),
                    ),
                    ListTile(
                      leading: SizedBox(
                        width: 100,
                        child: Text(
                          "COLLECTION MODE:",
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Georgia",
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinBlue,
                          ),
                        ),
                      ),
                      title: DropdownButton<String>(
                        dropdownColor: CustomColors.mfinWhite,
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
                    int.parse(selectedCollectionModeID) == 1
                        ? Column(children: <Widget>[
                            ListTile(
                              leading: SizedBox(
                                width: 100,
                                child: Text(
                                  "COLLECTION DAY:",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: "Georgia",
                                    fontWeight: FontWeight.bold,
                                    color: CustomColors.mfinBlue,
                                  ),
                                ),
                              ),
                              title: DropdownButton<String>(
                                dropdownColor: CustomColors.mfinWhite,
                                isExpanded: true,
                                items: _tempCollectionDays.entries.map(
                                  (f) {
                                    return DropdownMenuItem<String>(
                                      value: f.key,
                                      child: Text(f.value),
                                    );
                                  },
                                ).toList(),
                                onChanged: (newVal) {
                                  _setSelectedCollectionDay(newVal);
                                },
                                value: selectedCollectionDayID,
                              ),
                            ),
                          ])
                        : Container()
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
