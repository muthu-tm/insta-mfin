import 'package:flutter/material.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/services/controllers/transaction/paymentTemp_controller.dart';
import 'package:instamfin/app_localizations.dart';
import 'package:instamfin/services/controllers/user/user_service.dart';

class AddPaymentTemplate extends StatefulWidget {
  @override
  _AddPaymentTemplateState createState() => _AddPaymentTemplateState();
}

class _AddPaymentTemplateState extends State<AddPaymentTemplate> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String templateName = '';
  int totalAmount = 0;
  int pAmount = 0;
  int documentCharge = 0;
  int surChargeAmount = 0;
  int noOfInstallments = 0;
  int interestAmount = 0;
  int collectionAmount = 0;
  String selectedCollectionModeID = "0";

  Map<String, String> _tempCollectionMode = {
    "0": "Daily",
    "1": "Weekly",
    "2": "Monthly"
  };

  Map<String, String> tempCollectionDays = {
    "0": "Sun",
    "1": "Mon",
    "2": "Tue",
    "3": "Wed",
    "4": "Thu",
    "5": "Fri",
    "6": "Sat",
  };

  List<int> collectionDays;

  TextEditingController totalAmountController = TextEditingController();
  TextEditingController principalAmountController = TextEditingController();
  TextEditingController interestAmountController = TextEditingController();
  TextEditingController tenureController = TextEditingController();
  TextEditingController collectionAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();

    selectedCollectionModeID =
        cachedLocalUser.accPreferences.collectionMode.toString() ?? '0';
    collectionDays =
        cachedLocalUser.accPreferences.collectionDays ?? [1, 2, 3, 4, 5];
    interestAmount = 0;

    totalAmountController.text = "0";
    principalAmountController.text = "0";
    tenureController.text = '0';
    interestAmountController.text = '0';
    collectionAmountController.text = '0';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("add_template")),
        backgroundColor: CustomColors.mfinBlue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: CustomColors.mfinBlue,
        onPressed: () {
          _submit();
        },
        label: Text(
          AppLocalizations.of(context).translate("save"),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 40,
                      alignment: Alignment.center,
                      child: Text(
                        AppLocalizations.of(context)
                            .translate("payment_template"),
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
                      padding: EdgeInsets.all(5.0),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              initialValue: templateName,
                              keyboardType: TextInputType.text,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)
                                    .translate("template_name"),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelStyle: TextStyle(
                                  fontSize: 10,
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
                      padding: EdgeInsets.all(5.0),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              controller: totalAmountController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)
                                    .translate("total_amount"),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelStyle: TextStyle(
                                  fontSize: 10,
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
                              onChanged: (val) {
                                double iAmount = cachedLocalUser
                                            .accPreferences.interestRate >
                                        0
                                    ? (int.parse(val) ~/ 100) *
                                        cachedLocalUser
                                            .accPreferences.interestRate
                                    : 0;
                                int pAmount = int.parse(val) - iAmount.round();
                                setState(() {
                                  interestAmountController.text =
                                      iAmount.round().toString();
                                  principalAmountController.text =
                                      pAmount.toString();
                                });
                              },
                              validator: (amount) {
                                if (amount.trim().isNotEmpty) {
                                  this.totalAmount = int.parse(amount);
                                  return null;
                                } else {
                                  return "Fill the Total Amount (Principal + Total interest)";
                                }
                              },
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(5)),
                          Flexible(
                            child: TextFormField(
                              controller: interestAmountController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)
                                    .translate("interest_amount"),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelStyle: TextStyle(
                                  fontSize: 10,
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
                              onChanged: (val) {
                                int pAmount =
                                    int.parse(totalAmountController.text) > 0
                                        ? int.parse(
                                                totalAmountController.text) -
                                            int.parse(val)
                                        : 0;
                                setState(() {
                                  principalAmountController.text =
                                      pAmount.toString();
                                });
                              },
                              validator: (interest) {
                                if (interest.trim().isEmpty) {
                                  return 'Enter the Interest Amount';
                                }
                                this.interestAmount = int.parse(interest);
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              controller: principalAmountController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)
                                    .translate("principal_amount"),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelStyle: TextStyle(
                                  fontSize: 10,
                                  color: CustomColors.mfinBlue,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 10.0),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: CustomColors.mfinFadedButtonGreen,
                                  ),
                                ),
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                              ),
                              validator: (amount) {
                                if (amount.trim().isNotEmpty) {
                                  this.pAmount = int.parse(amount);
                                  return null;
                                } else {
                                  return 'Enter the Principal Amount to be given to Customer';
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              controller: tenureController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)
                                    .translate("no_of_collections"),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelStyle: TextStyle(
                                  fontSize: 10,
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
                              onChanged: (val) {
                                int cAmount =
                                    int.parse(totalAmountController.text) > 0
                                        ? (int.parse(
                                                totalAmountController.text)) ~/
                                            int.parse(val)
                                        : 0;
                                setState(() {
                                  collectionAmountController.text =
                                      cAmount.toString();
                                });
                              },
                              validator: (noOfPayment) {
                                if (noOfPayment.trim().isEmpty) {
                                  return 'Enter the Number of Installments';
                                }
                                this.noOfInstallments = int.parse(noOfPayment);
                                return null;
                              },
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(5)),
                          Flexible(
                            child: TextFormField(
                              controller: collectionAmountController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)
                                    .translate("collection_amount"),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelStyle: TextStyle(
                                  fontSize: 10,
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
                                }
                                this.collectionAmount =
                                    int.parse(collectionAmount);
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              initialValue: documentCharge.toString(),
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)
                                    .translate("document_charge"),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelStyle: TextStyle(
                                  fontSize: 10,
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
                                  return 'Enter Document charge';
                                }
                                this.documentCharge = int.parse(charge);
                                return null;
                              },
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(5)),
                          Flexible(
                            child: TextFormField(
                              initialValue: surChargeAmount.toString(),
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)
                                    .translate("surcharge"),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelStyle: TextStyle(
                                  fontSize: 10,
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
                      padding: EdgeInsets.all(5.0),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)
                                    .translate("collection_mode"),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelStyle: TextStyle(
                                  fontSize: 10,
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
                    Padding(padding: EdgeInsets.all(5)),
                    selectedCollectionModeID == '0'
                        ? Container(
                            padding: EdgeInsets.only(top: 5),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              border: Border.all(
                                  color: CustomColors.mfinGrey, width: 1.0),
                            ),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  AppLocalizations.of(context)
                                      .translate("collection_days"),
                                  style: TextStyle(
                                      color: CustomColors.mfinBlue,
                                      fontSize: 16.0),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: selectedDays.toList(),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.all(35))
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

  Iterable<Widget> get selectedDays sync* {
    for (MapEntry days in tempCollectionDays.entries) {
      yield Transform(
        transform: Matrix4.identity()..scale(0.9),
        child: ChoiceChip(
            label: Text(days.value),
            selected: collectionDays.contains(int.parse(days.key)),
            elevation: 5.0,
            selectedColor: CustomColors.mfinBlue,
            backgroundColor: CustomColors.mfinWhite,
            labelStyle: TextStyle(color: CustomColors.mfinButtonGreen),
            onSelected: (selected) {
              setState(() {
                if (selected) {
                  collectionDays.add(int.parse(days.key));
                } else {
                  collectionDays.remove(int.parse(days.key));
                }
              });
            }),
      );
    }
  }

  _submit() async {
    final FormState form = _formKey.currentState;

    if (form.validate()) {
      if (totalAmount != noOfInstallments * collectionAmount) {
        _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
            'Total amount should be equal to Collection amount * No. of collections',
            3));
        return;
      }

      CustomDialogs.actionWaiting(context, "Creating Template!");
      PaymentTemplateController _tempController = PaymentTemplateController();
      var result = await _tempController.createTemplate(
          templateName,
          totalAmount,
          pAmount,
          noOfInstallments,
          collectionAmount,
          int.parse(selectedCollectionModeID),
          collectionDays,
          documentCharge,
          surChargeAmount,
          interestAmount);

      if (!result['is_success']) {
        Navigator.pop(context);
        _scaffoldKey.currentState
            .showSnackBar(CustomSnackBar.errorSnackBar(result['message'], 5));
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
      }
    } else {
      _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
          AppLocalizations.of(context).translate("required_fields"), 2));
    }
  }
}
