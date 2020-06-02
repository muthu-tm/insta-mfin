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
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: CustomColors.mfinGrey,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Add Template'),
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
                          }
                          this.templateName = name.trim();
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
                            if (amount.trim().isNotEmpty) {
                              this.totalAmount = int.parse(amount);
                            } else {
                              this.totalAmount = 0;
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
                            if (amount.trim().isNotEmpty) {
                              this.givenAmount = int.parse(amount);
                            } else {
                              this.givenAmount = 0;
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
                          }
                          this.documentCharge = int.parse(charge);
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
                          }
                          this.surChargeAmount = int.parse(surcharge);
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
                          }
                          this.noOfPayments = int.parse(noOfPayment);
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
                          }
                          this.interestRate = double.parse(intrest);
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
                          }
                          this.collectionAmount = int.parse(collectionAmount);
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
    });
  }

  void _setSelectedCollectionDay(String newVal) {}

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
