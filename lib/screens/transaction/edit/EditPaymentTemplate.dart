import 'package:flutter/material.dart';
import 'package:instamfin/db/models/account_preferences.dart';
import 'package:instamfin/db/models/payment_template.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/services/controllers/transaction/paymentTemp_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class EditPaymentTemplate extends StatefulWidget {
  EditPaymentTemplate(this.template);
  final PaymentTemplate template;

  @override
  _EditPaymentTemplateState createState() => _EditPaymentTemplateState();
}

class _EditPaymentTemplateState extends State<EditPaymentTemplate> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AccountPreferences accPref =
      UserController().getCurrentUser().accPreferences;

  final Map<String, dynamic> updatedTemplate = new Map();

  String templateName;
  String selectedCollectionModeID = "0";

  Map<String, String> _tempCollectionMode = {
    "0": "Daily",
    "1": "Weekly",
    "2": "Monthly"
  };

  List<int> collectionDays;
  Map<String, String> tempCollectionDays = {
    "0": "Sun",
    "1": "Mon",
    "2": "Tue",
    "3": "Wed",
    "4": "Thu",
    "5": "Fri",
    "6": "Sat",
  };

  TextEditingController totalAmountController = TextEditingController();
  TextEditingController principalAmountController = TextEditingController();
  TextEditingController interestAmountController = TextEditingController();
  TextEditingController tenureController = TextEditingController();
  TextEditingController collectionAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedCollectionModeID = widget.template.collectionMode.toString();
    collectionDays = widget.template.collectionDays;

    totalAmountController.text = widget.template.totalAmount.toString();
    principalAmountController.text = widget.template.principalAmount.toString();
    tenureController.text = widget.template.tenure.toString();
    interestAmountController.text = widget.template.interestAmount.toString();
    collectionAmountController.text =
        widget.template.collectionAmount.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Edit Template'),
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
                              keyboardType: TextInputType.text,
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
                              controller: totalAmountController,
                              keyboardType: TextInputType.number,
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
                              onChanged: (val) {
                                double iAmount = accPref.interestRate > 0
                                    ? (int.parse(val) ~/ 100) *
                                        accPref.interestRate
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
                                if (amount.trim().isNotEmpty ||
                                    amount.trim() !=
                                        widget.template.totalAmount
                                            .toString()) {
                                  updatedTemplate['total_amount'] =
                                      int.parse(amount);
                                  return null;
                                } else {
                                  return "Fill the Total Amount (Principal + interest)";
                                }
                              },
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(10)),
                          Flexible(
                            child: TextFormField(
                              controller: interestAmountController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                labelText: 'Interest Amount',
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
                                } else if (interest.trim() !=
                                    widget.template.interestAmount.toString()) {
                                  updatedTemplate['interest_amount'] =
                                      int.parse(interest);
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
                              controller: principalAmountController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                labelText: 'Principal Amount',
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
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              initialValue: widget.template.tenure.toString(),
                              keyboardType: TextInputType.number,
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
                              controller: collectionAmountController,
                              keyboardType: TextInputType.number,
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
                              keyboardType: TextInputType.number,
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
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                labelText: 'SurCharge',
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
                    Padding(padding: EdgeInsets.all(5)),
                    selectedCollectionModeID == '0'
                        ? Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              border: Border.all(
                                  color: CustomColors.mfinGrey, width: 1.0),
                            ),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'Scheduled collection days',
                                  style: TextStyle(
                                    color: CustomColors.mfinBlue,
                                  ),
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
                    Padding(padding: EdgeInsets.all(35))
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
                  updatedTemplate['collection_days'] = collectionDays;
                } else {
                  collectionDays.remove(int.parse(days.key));
                  updatedTemplate['collection_days'] = collectionDays;
                }
              });
            }),
      );
    }
  }

  void _submit() async {
    final FormState form = _formKey.currentState;

    if (form.validate()) {
      if (updatedTemplate.length == 0) {
        _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
            "No changes detected, Skipping update!", 1));
        Navigator.pop(context);
      } else {
        int totalAmount = updatedTemplate.containsKey('total_amount')
            ? updatedTemplate['total_amount']
            : widget.template.totalAmount;

        int tenure = updatedTemplate.containsKey('tenure')
            ? updatedTemplate['tenure']
            : widget.template.tenure;

        int collectionAmount = updatedTemplate.containsKey('collection_amount')
            ? updatedTemplate['collection_amount']
            : widget.template.collectionAmount;

        if (totalAmount != tenure * collectionAmount) {
          _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
              'Total amount should be equal to Collection amount * No. of collections',
              3));
          return;
        }

        CustomDialogs.actionWaiting(context, "Updating Template");
        PaymentTemplateController _collectionController =
            PaymentTemplateController();
        var result = await _collectionController.updateTemp(
            widget.template.getDocumentID(), updatedTemplate);

        if (!result['is_success']) {
          Navigator.pop(context);
          _scaffoldKey.currentState
              .showSnackBar(CustomSnackBar.errorSnackBar(result['message'], 5));
        } else {
          Navigator.pop(context);
          Navigator.pop(context);
        }
      }
    } else {
      _scaffoldKey.currentState.showSnackBar(
          CustomSnackBar.errorSnackBar("Please fill required fields!", 2));
    }
  }
}
