import 'package:flutter/material.dart';
import 'package:instamfin/db/models/customer.dart';
import 'package:instamfin/db/models/payment_template.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/transaction/paymentTemp_controller.dart';
import 'package:instamfin/services/controllers/transaction/payment_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

import '../../app_localizations.dart';

class AddPayment extends StatefulWidget {
  final Customer customer;

  AddPayment(this.customer);

  @override
  _AddPaymentState createState() => _AddPaymentState();
}

class _AddPaymentState extends State<AddPayment> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final User _user = UserController().getCurrentUser();

  String _selectedTempID = "0";
  String selectedCollectionModeID = "0";
  Map<String, String> _tempMap = {"0": "Choose Type.."};
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

  String transferredMode = "0";
  Map<String, String> _transferMode = {
    "0": "Cash",
    "1": "NetBanking",
    "2": "GPay"
  };
  List<PaymentTemplate> templates = List<PaymentTemplate>();
  List<PaymentTemplate> tempList;
  PaymentTemplate selectedTemp;

  TextEditingController _date = TextEditingController();
  TextEditingController _collectionDate = TextEditingController();

  TextEditingController totalAmountController = TextEditingController();
  TextEditingController principalAmountController = TextEditingController();
  TextEditingController interestRateController = TextEditingController();
  TextEditingController tenureController = TextEditingController();
  TextEditingController collectionAmountController = TextEditingController();
  TextEditingController docChargeController = TextEditingController();
  TextEditingController surChargeController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  DateTime collectionDate = DateTime.now().add(Duration(days: 1));
  int totalAmount = 0;
  int principalAmount = 0;
  int docCharge = 0;
  int surCharge = 0;
  int commission = 0;
  int tenure = 0;
  String paymentID = '';
  int interestAmount = 0;
  int collectionAmount = 0;
  String givenBy = '';
  String notes = '';
  int alreadyReceivedAmount = 0;

  @override
  void initState() {
    super.initState();
    this.getCollectionTemp();
    givenBy = _user.name;
    selectedCollectionModeID =
        _user.accPreferences.collectionMode.toString() ?? '0';
    collectionDays = _user.accPreferences.collectionDays ?? [1, 2, 3, 4, 5];
    totalAmountController.text = "0";
    principalAmountController.text = "0";
    docChargeController.text = '0';
    surChargeController.text = '0';
    tenureController.text = '0';
    interestRateController.text = '0';
    collectionAmountController.text = '0';

    _date.text = DateUtils.formatDate(DateTime.now());
    _collectionDate.text =
        DateUtils.formatDate(DateTime.now().add(Duration(days: 1)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate('add_payment'),
        ),
        backgroundColor: CustomColors.mfinBlue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: CustomColors.mfinBlue,
        onPressed: () {
          _submit();
        },
        label: Text(
          AppLocalizations.of(context).translate('save'),
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
                        AppLocalizations.of(context).translate('general_info'),
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
                      color: CustomColors.mfinAlertRed,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              readOnly: true,
                              initialValue:
                                  '${widget.customer.firstName} ${widget.customer.lastName}',
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)
                                    .translate('customer_name'),
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
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: GestureDetector(
                              onTap: () => _selectPaymentDate(context),
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: _date,
                                  keyboardType: TextInputType.datetime,
                                  decoration: InputDecoration(
                                    labelText: AppLocalizations.of(context)
                                        .translate('date_of_pay'),
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
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.text,
                              initialValue: paymentID,
                              decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                hintText: AppLocalizations.of(context)
                                    .translate('payment_id'),
                                labelText: AppLocalizations.of(context)
                                    .translate('payment_id'),
                                labelStyle: TextStyle(
                                  color: CustomColors.mfinBlue,
                                ),
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 10.0),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            CustomColors.mfinFadedButtonGreen)),
                              ),
                              validator: (paymentID) {
                                if (paymentID.trim().isEmpty) {
                                  this.paymentID = "";
                                } else {
                                  this.paymentID = paymentID.trim();
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.text,
                              initialValue: givenBy,
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)
                                    .translate('amount_given_by'),
                                labelText: AppLocalizations.of(context)
                                    .translate('amount_given_by'),
                                labelStyle: TextStyle(
                                  color: CustomColors.mfinBlue,
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 10.0),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: CustomColors.mfinWhite)),
                              ),
                              validator: (givenby) {
                                if (givenby.trim().isEmpty) {
                                  return "Please fill the person name who gave the amount";
                                }
                                this.givenBy = givenby.trim();
                                return null;
                              },
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 10)),
                          Flexible(
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)
                                    .translate('transferred_mode'),
                                labelStyle: TextStyle(
                                  color: CustomColors.mfinBlue,
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 10.0),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: CustomColors.mfinWhite)),
                              ),
                              items: _transferMode.entries.map(
                                (f) {
                                  return DropdownMenuItem<String>(
                                    value: f.key,
                                    child: Text(f.value),
                                  );
                                },
                              ).toList(),
                              onChanged: (newVal) {
                                _setTransferredMode(newVal);
                              },
                              value: transferredMode,
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
                            child: DropdownButtonFormField(
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)
                                      .translate('payment_template'),
                                  labelStyle: TextStyle(
                                    color: CustomColors.mfinBlue,
                                  ),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  fillColor: CustomColors.mfinWhite,
                                  filled: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 3.0, horizontal: 10.0),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: CustomColors.mfinWhite)),
                                ),
                                items: _tempMap.entries.map(
                                  (f) {
                                    return DropdownMenuItem<String>(
                                      value: f.key,
                                      child: Text(f.value),
                                    );
                                  },
                                ).toList(),
                                value: _selectedTempID,
                                onChanged: (newVal) {
                                  _setSelectedTemp(newVal);
                                }),
                          ),
                          Padding(padding: EdgeInsets.only(left: 10)),
                          Flexible(
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)
                                    .translate('collection_mode'),
                                labelStyle: TextStyle(
                                  color: CustomColors.mfinBlue,
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 10.0),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: CustomColors.mfinWhite)),
                              ),
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
                    selectedCollectionModeID == '0'
                        ? Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: CustomColors.mfinGrey, width: 1.0),
                            ),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  AppLocalizations.of(context)
                                      .translate('scheduled_collection_days'),
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: GestureDetector(
                              onTap: () => _selectCollectionDate(context),
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: _collectionDate,
                                  keyboardType: TextInputType.datetime,
                                  decoration: InputDecoration(
                                    labelText: AppLocalizations.of(context)
                                        .translate('start_date'),
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
                            child: GestureDetector(
                              child: AbsorbPointer(
                                child: TextFormField(
                                  readOnly: true,
                                  controller: _collectionDate,
                                  keyboardType: TextInputType.datetime,
                                  decoration: InputDecoration(
                                    labelText: AppLocalizations.of(context)
                                        .translate('end_date'),
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
                                    fillColor: CustomColors.mfinLightGrey,
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
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              initialValue: commission.toString(),
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)
                                    .translate('referral_commission'),
                                labelText: AppLocalizations.of(context)
                                    .translate('referral_commission'),
                                labelStyle:
                                    TextStyle(color: CustomColors.mfinBlue),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 10),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: CustomColors.mfinWhite)),
                              ),
                              validator: (commission) {
                                if (commission.trim().isEmpty) {
                                  this.commission = 0;
                                } else {
                                  this.commission = int.parse(commission);
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
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.text,
                              initialValue: notes,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)
                                    .translate('notes'),
                                labelText: AppLocalizations.of(context)
                                    .translate('notes'),
                                labelStyle: TextStyle(
                                  color: CustomColors.mfinBlue,
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 10.0),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: CustomColors.mfinWhite)),
                              ),
                              validator: (notes) {
                                if (notes.trim().isEmpty) {
                                  this.notes = "";
                                } else {
                                  this.notes = notes.trim();
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
                        AppLocalizations.of(context).translate('payment_info'),
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
                      color: CustomColors.mfinAlertRed,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              controller: totalAmountController,
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)
                                    .translate('total_amount'),
                                labelText: AppLocalizations.of(context)
                                    .translate('total_amount'),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelStyle:
                                    TextStyle(color: CustomColors.mfinBlue),
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 10.0),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: CustomColors.mfinWhite)),
                              ),
                              onChanged: (val) {
                                double iAmount =
                                    _user.accPreferences.interestRate > 0
                                        ? (int.parse(val) ~/ 100) *
                                            _user.accPreferences.interestRate
                                        : 0;
                                int pAmount = int.parse(val) - iAmount.round();
                                setState(() {
                                  interestRateController.text =
                                      iAmount.round().toString();
                                  principalAmountController.text =
                                      pAmount.toString();
                                });
                              },
                              validator: (amount) {
                                if (amount.trim().isEmpty ||
                                    amount.trim() == "0") {
                                  return "Cannot be empty!";
                                } else {
                                  this.totalAmount = int.parse(amount.trim());
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 10)),
                          Flexible(
                            child: TextFormField(
                              controller: interestRateController,
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)
                                    .translate('interest_amount'),
                                labelText: AppLocalizations.of(context)
                                    .translate('interest_amount'),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelStyle:
                                    TextStyle(color: CustomColors.mfinBlue),
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 10.0),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: CustomColors.mfinWhite)),
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
                              validator: (tenure) {
                                if (tenure.trim().isEmpty) {
                                  this.interestAmount = 0;
                                } else {
                                  this.interestAmount = int.parse(tenure);
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
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)
                                    .translate('principal_amount'),
                                labelText: AppLocalizations.of(context)
                                    .translate('principal_amount'),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelStyle:
                                    TextStyle(color: CustomColors.mfinBlue),
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 10.0),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: CustomColors.mfinWhite)),
                              ),
                              validator: (amount) {
                                if (amount.trim().isEmpty ||
                                    amount.trim() == "0") {
                                  return "Cannot be empty!";
                                } else {
                                  this.principalAmount =
                                      int.parse(amount.trim());
                                  return null;
                                }
                              },
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 10)),
                          Flexible(
                            child: TextFormField(
                              controller: tenureController,
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)
                                    .translate('number_of_collection'),
                                labelText: AppLocalizations.of(context)
                                    .translate('number_of_collection'),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelStyle:
                                    TextStyle(color: CustomColors.mfinBlue),
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 10.0),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: CustomColors.mfinWhite)),
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
                              validator: (tenure) {
                                if (tenure.trim().isEmpty ||
                                    tenure.trim() == '0') {
                                  return 'Cannot be empty!';
                                } else {
                                  this.tenure = int.parse(tenure);
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              controller: collectionAmountController,
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)
                                    .translate('collection_amount'),
                                labelText: AppLocalizations.of(context)
                                    .translate('collection_amount'),
                                labelStyle:
                                    TextStyle(color: CustomColors.mfinBlue),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 10.0),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: CustomColors.mfinWhite)),
                              ),
                              validator: (collAmount) {
                                if (collAmount.trim().isEmpty ||
                                    collAmount.trim() == '0') {
                                  return "Cannot be empty or zero";
                                }
                                this.collectionAmount =
                                    int.parse(collAmount.trim());
                                return null;
                              },
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 10)),
                          Flexible(
                            child: TextFormField(
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.number,
                              initialValue: alreadyReceivedAmount.toString(),
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)
                                    .translate('amount_received'),
                                labelText: AppLocalizations.of(context)
                                    .translate('amount_received'),
                                labelStyle:
                                    TextStyle(color: CustomColors.mfinBlue),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 10.0),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: CustomColors.mfinWhite)),
                              ),
                              validator: (aCollAmount) {
                                if (aCollAmount.trim().isEmpty) {
                                  this.alreadyReceivedAmount = 0;
                                } else {
                                  this.alreadyReceivedAmount =
                                      int.parse(aCollAmount.trim());
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
                              controller: docChargeController,
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)
                                    .translate('document_recharge'),
                                labelText: AppLocalizations.of(context)
                                    .translate('document_recharge'),
                                labelStyle:
                                    TextStyle(color: CustomColors.mfinBlue),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 10),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: CustomColors.mfinWhite)),
                              ),
                              validator: (charge) {
                                if (charge.trim().isEmpty) {
                                  this.docCharge = 0;
                                } else {
                                  this.docCharge = int.parse(charge);
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 10)),
                          Flexible(
                            child: TextFormField(
                              controller: surChargeController,
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)
                                    .translate('service_recharge'),
                                labelText: AppLocalizations.of(context)
                                    .translate('service_recharge'),
                                labelStyle:
                                    TextStyle(color: CustomColors.mfinBlue),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 10.0),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: CustomColors.mfinWhite)),
                              ),
                              validator: (surcharge) {
                                if (surcharge.trim().isEmpty) {
                                  this.surCharge = 0;
                                } else {
                                  this.surCharge = int.parse(surcharge);
                                }
                                return null;
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.all(40))
            ],
          ),
        ),
      ),
    );
  }

  Future getCollectionTemp() async {
    try {
      PaymentTemplateController _ctc = PaymentTemplateController();
      List<PaymentTemplate> templates = await _ctc.getAllTemplates();
      for (int index = 0; index < templates.length; index++) {
        _tempMap[(index + 1).toString()] = templates[index].name;
      }
      setState(() {
        tempList = templates;
      });
    } catch (err) {
      print("Unable to load Payment templates for Payment ADD!");
    }
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

  Future<void> _selectCollectionDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime(1990),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null && picked != collectionDate)
      setState(
        () {
          collectionDate = picked;
          _collectionDate.text = DateUtils.formatDate(picked);
        },
      );
  }

  Future<void> _selectPaymentDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate)
      setState(
        () {
          selectedDate = picked;
          _date.text = DateUtils.formatDate(picked);
          if (selectedCollectionModeID == "0") {
            collectionDate = selectedDate.add(Duration(days: 1));
            _collectionDate.text =
                DateUtils.formatDate(selectedDate.add(Duration(days: 1)));
          } else if (selectedCollectionModeID == "1") {
            collectionDate = selectedDate.add(Duration(days: 7));
            _collectionDate.text =
                DateUtils.formatDate(selectedDate.add(Duration(days: 7)));
          } else if (selectedCollectionModeID == "2") {
            collectionDate = DateTime(
                selectedDate.year, selectedDate.month + 1, selectedDate.day);
            _collectionDate.text = DateUtils.formatDate(DateTime(
                selectedDate.year, selectedDate.month + 1, selectedDate.day));
          }
        },
      );
  }

  _setTransferredMode(String newVal) {
    setState(() {
      transferredMode = newVal;
    });
  }

  _setSelectedCollectionMode(String newVal) {
    if (newVal == "0") {
      collectionDate = selectedDate.add(Duration(days: 1));
      _collectionDate.text =
          DateUtils.formatDate(selectedDate.add(Duration(days: 1)));
    } else if (newVal == "1") {
      collectionDate = selectedDate.add(Duration(days: 7));
      _collectionDate.text =
          DateUtils.formatDate(selectedDate.add(Duration(days: 7)));
    } else if (newVal == "2") {
      collectionDate =
          DateTime(selectedDate.year, selectedDate.month + 1, selectedDate.day);
      _collectionDate.text = DateUtils.formatDate(DateTime(
          selectedDate.year, selectedDate.month + 1, selectedDate.day));
    }

    setState(() {
      selectedCollectionModeID = newVal;
    });
  }

  _setSelectedTemp(String newVal) {
    if (tempList != null && newVal != "0") {
      selectedTemp = tempList[int.parse(newVal) - 1];
      setState(() {
        _selectedTempID = newVal;
        collectionDays = selectedTemp.collectionDays;
        selectedCollectionModeID = selectedTemp.collectionMode.toString();
        totalAmountController.text = selectedTemp.totalAmount.toString();
        principalAmountController.text =
            selectedTemp.principalAmount.toString();
        docChargeController.text = selectedTemp.docCharge.toString();
        surChargeController.text = selectedTemp.surcharge.toString();
        tenureController.text = selectedTemp.tenure.toString();
        interestRateController.text = selectedTemp.interestAmount.toString();
        collectionAmountController.text =
            selectedTemp.collectionAmount.toString();
      });
    }
  }

  _submit() async {
    final FormState form = _formKey.currentState;

    if (selectedCollectionModeID == "0") {
      if (collectionDate.weekday <= 6 &&
          !collectionDays.contains(collectionDate.weekday)) {
        _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
            AppLocalizations.of(context).translate('collection_start_date'),
            2));
        return;
      } else if (collectionDate.weekday == 7 && !collectionDays.contains(0)) {
        _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
            AppLocalizations.of(context).translate('collection_start_date'),
            2));
        return;
      }
    }

    if (form.validate()) {
      if (totalAmount != tenure * collectionAmount) {
        _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
            AppLocalizations.of(context).translate('collection_amount_equal'),
            3));
        return;
      } else if (!(alreadyReceivedAmount < totalAmount)) {
        _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
            AppLocalizations.of(context).translate('received_lesser'), 3));
        return;
      }

      CustomDialogs.actionWaiting(context, "Adding Payment");
      PaymentController _pc = PaymentController();
      var result = await _pc.createPayment(
          widget.customer.id,
          '${widget.customer.firstName} ${widget.customer.lastName}',
          paymentID.toString(),
          DateUtils.getUTCDateEpoch(selectedDate),
          totalAmount,
          principalAmount,
          tenure,
          collectionAmount,
          int.parse(selectedCollectionModeID),
          collectionDays,
          int.parse(transferredMode),
          alreadyReceivedAmount,
          DateUtils.getUTCDateEpoch(collectionDate),
          docCharge,
          surCharge,
          commission,
          interestAmount,
          givenBy,
          notes);

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
          AppLocalizations.of(context).translate('please_fill'), 2));
    }
  }
}
