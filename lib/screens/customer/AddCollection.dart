import 'package:flutter/material.dart';
import 'package:instamfin/db/models/collection.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/transaction/collection_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

import '../../app_localizations.dart';

class AddCollection extends StatefulWidget {
  AddCollection(this.payment);

  final Payment payment;

  @override
  _AddCollectionState createState() => _AddCollectionState();
}

class _AddCollectionState extends State<AddCollection> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final User _user = UserController().getCurrentUser();

  TextEditingController _cNumberController = new TextEditingController();
  TextEditingController _cAmountController = new TextEditingController();
  TextEditingController _aCollectedController = new TextEditingController();

  int collDate = DateUtils.getUTCDateEpoch(DateTime.now());
  int collectedDate = DateUtils.getUTCDateEpoch(DateTime.now());
  String collType = "0";
  Map<String, String> _collTypes = {
    "0": "Collection",
    "1": "DocCharge",
    "2": "Surcharge",
    "4": "Penalty"
  };

  int collAmount = 0;
  bool isLatePay = false;
  bool hasPenalty = false;
  int penaltyAmount = 0;

  @override
  void initState() {
    super.initState();
    this._date.text = DateUtils.formatDate(DateTime.now());
    this._cAmountController.text = widget.payment.collectionAmount.toString();
    this._aCollectedController.text = "0";
    this._cNumberController.text = "0";
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate('add_collection'),
        ),
        backgroundColor: CustomColors.mfinBlue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
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
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Card(
                elevation: 10.0,
                margin: EdgeInsets.only(
                    top: 10.0, bottom: 10.0, left: 5.0, right: 5.0),
                child: new Column(
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
                      color: CustomColors.mfinBlue,
                    ),
                    ListTile(
                      leading: SizedBox(
                        width: 100,
                        child: Text(
                          AppLocalizations.of(context)
                              .translate('customer_caps'),
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Georgia",
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinBlue,
                          ),
                        ),
                      ),
                      title: TextFormField(
                        readOnly: true,
                        initialValue: widget.payment.custName,
                        textAlign: TextAlign.end,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextStyle(
                            color: CustomColors.mfinBlue,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 10.0),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: CustomColors.mfinFadedButtonGreen)),
                          fillColor: CustomColors.mfinLightGrey,
                          filled: true,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: SizedBox(
                        width: 100,
                        child: Text(
                          AppLocalizations.of(context).translate('id'),
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Georgia",
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinBlue,
                          ),
                        ),
                      ),
                      title: TextFormField(
                        readOnly: true,
                        initialValue: widget.payment.paymentID ?? "",
                        textAlign: TextAlign.end,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextStyle(
                            color: CustomColors.mfinBlue,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 10.0),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: CustomColors.mfinFadedButtonGreen)),
                          fillColor: CustomColors.mfinLightGrey,
                          filled: true,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: SizedBox(
                        width: 100,
                        child: Text(
                          AppLocalizations.of(context).translate('date'),
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Georgia",
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinBlue,
                          ),
                        ),
                      ),
                      title: TextFormField(
                        readOnly: true,
                        initialValue: DateUtils.formatDate(
                            DateTime.fromMillisecondsSinceEpoch(
                                widget.payment.dateOfPayment)),
                        keyboardType: TextInputType.datetime,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextStyle(
                            color: CustomColors.mfinBlue,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 10.0),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: CustomColors.mfinWhite)),
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
                    ListTile(
                      leading: SizedBox(
                        width: 100,
                        child: Text(
                          AppLocalizations.of(context).translate('amount_caps'),
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Georgia",
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinBlue,
                          ),
                        ),
                      ),
                      title: TextFormField(
                        readOnly: true,
                        textAlign: TextAlign.end,
                        initialValue: widget.payment.totalAmount.toString(),
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextStyle(color: CustomColors.mfinBlue),
                          fillColor: CustomColors.mfinLightGrey,
                          filled: true,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 10.0),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: CustomColors.mfinWhite)),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: SizedBox(
                        width: 100,
                        child: Text(
                          AppLocalizations.of(context)
                              .translate('pay_out_caps'),
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Georgia",
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinBlue,
                          ),
                        ),
                      ),
                      title: TextFormField(
                        readOnly: true,
                        textAlign: TextAlign.end,
                        initialValue: widget.payment.principalAmount.toString(),
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextStyle(color: CustomColors.mfinBlue),
                          fillColor: CustomColors.mfinLightGrey,
                          filled: true,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 10.0),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: CustomColors.mfinWhite)),
                        ),
                      ),
                    ),
                    Divider(
                      color: CustomColors.mfinButtonGreen,
                    ),
                    Container(
                      height: 40,
                      alignment: Alignment.center,
                      child: Text(
                        AppLocalizations.of(context)
                            .translate('collection_info'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: "Georgia",
                          fontWeight: FontWeight.bold,
                          color: CustomColors.mfinBlue,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              controller: _cNumberController,
                              readOnly: collType == "0" || collType == "4"
                                  ? false
                                  : true,
                              keyboardType: TextInputType.datetime,
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)
                                    .translate('collection_number'),
                                labelText: AppLocalizations.of(context)
                                    .translate('collection_number'),
                                labelStyle: TextStyle(
                                  color: CustomColors.mfinBlue,
                                ),
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 3.0),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: CustomColors.mfinWhite)),
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                              ),
                              validator: (number) {
                                if (number.trim().isEmpty ||
                                    number.trim() == "0") {
                                  if (collType == "0" || collType == "4")
                                    return "Collected Amount should not be empty!";
                                  else
                                    _cNumberController.text = "0";
                                } else {
                                  _cNumberController.text = number.trim();
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 10)),
                          Flexible(
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)
                                    .translate('type'),
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
                              items: _collTypes.entries.map(
                                (f) {
                                  return DropdownMenuItem<String>(
                                    value: f.key,
                                    child: Text(f.value),
                                  );
                                },
                              ).toList(),
                              onChanged: (newVal) {
                                _setCollectionType(newVal);
                              },
                              value: collType,
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
                              textAlign: TextAlign.end,
                              readOnly: collType == "0" || collType == "4"
                                  ? false
                                  : true,
                              keyboardType: TextInputType.number,
                              controller: _cAmountController,
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)
                                    .translate('collection_amount'),
                                labelText: AppLocalizations.of(context)
                                    .translate('collection_amount'),
                                labelStyle: TextStyle(
                                  color: CustomColors.mfinBlue,
                                ),
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 3.0),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: CustomColors.mfinWhite)),
                              ),
                              validator: (amount) {
                                if (amount.trim().isEmpty ||
                                    amount.trim() == "0") {
                                  return "Collection Amount should not be empty!";
                                } else {
                                  collAmount = int.parse(amount.trim());
                                  return null;
                                }
                              },
                              onChanged: (val) {
                                if (collType == "4") {
                                  setState(() {
                                    _aCollectedController.text = val;
                                  });
                                }
                              },
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 10)),
                          Flexible(
                            child: GestureDetector(
                              onTap: () => collType == "0" || collType == "4"
                                  ? _selectDate(context)
                                  : {},
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: _date,
                                  keyboardType: TextInputType.datetime,
                                  readOnly: collType == "0" || collType == "4"
                                      ? false
                                      : true,
                                  decoration: InputDecoration(
                                    hintText: AppLocalizations.of(context)
                                        .translate('collection_date'),
                                    labelText: AppLocalizations.of(context)
                                        .translate('collection_date'),
                                    labelStyle: TextStyle(
                                      color: CustomColors.mfinBlue,
                                    ),
                                    contentPadding: new EdgeInsets.symmetric(
                                        vertical: 3.0, horizontal: 3.0),
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
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              textAlign: TextAlign.end,
                              readOnly: collType == "0" ? false : true,
                              keyboardType: TextInputType.number,
                              controller: _aCollectedController,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)
                                    .translate('already_collected'),
                                labelStyle: TextStyle(
                                  color: CustomColors.mfinBlue,
                                ),
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 3.0),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: CustomColors.mfinWhite)),
                              ),
                              validator: (amount) {
                                if (amount.trim().isEmpty ||
                                    amount.trim() == "0") {
                                  _aCollectedController.text = "0";
                                } else {
                                  _aCollectedController.text = amount.trim();
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 10)),
                          Flexible(
                            child: GestureDetector(
                              onTap: () => collType == "0"
                                  ? _selectCollectedDate(context)
                                  : {},
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: _colllectedDate,
                                  keyboardType: TextInputType.datetime,
                                  readOnly: collType == "0" ? false : true,
                                  decoration: InputDecoration(
                                    hintText: AppLocalizations.of(context)
                                        .translate('collected_date'),
                                    labelText: AppLocalizations.of(context)
                                        .translate('collected_date'),
                                    labelStyle: TextStyle(
                                      color: CustomColors.mfinBlue,
                                    ),
                                    contentPadding: new EdgeInsets.symmetric(
                                        vertical: 3.0, horizontal: 3.0),
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
                        ],
                      ),
                    ),
                    isLatePay
                        ? Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              textAlign: TextAlign.end,
                              keyboardType: TextInputType.number,
                              initialValue: '0',
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)
                                    .translate('penalty_amount'),
                                labelText: AppLocalizations.of(context)
                                    .translate('penalty_amount'),
                                labelStyle: TextStyle(
                                  color: CustomColors.mfinBlue,
                                ),
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 3.0),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: CustomColors.mfinWhite)),
                              ),
                              validator: (amount) {
                                if (amount.trim().isEmpty ||
                                    amount.trim() == "0") {
                                  penaltyAmount = 0;
                                  hasPenalty = false;
                                } else {
                                  hasPenalty = true;
                                  penaltyAmount = int.parse(amount.trim());
                                }
                                return null;
                              },
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(10.0),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _setCollectionType(String newVal) {
    if (newVal == "0") {
      _cAmountController.text = widget.payment.collectionAmount.toString();
    } else {
      _date.text = DateUtils.formatDate(
          DateTime.fromMillisecondsSinceEpoch(widget.payment.dateOfPayment));
      _colllectedDate.text = DateUtils.formatDate(
          DateTime.fromMillisecondsSinceEpoch(widget.payment.dateOfPayment));

      collDate = widget.payment.dateOfPayment;
      collectedDate = widget.payment.dateOfPayment;

      if (newVal == "1") {
        _cNumberController.text = "0";

        _cAmountController.text = widget.payment.docCharge.toString();
        _aCollectedController.text = widget.payment.docCharge.toString();
      } else if (newVal == "2") {
        _cNumberController.text = "0";

        _cAmountController.text = widget.payment.surcharge.toString();
        _aCollectedController.text = widget.payment.surcharge.toString();
      } else {
        _aCollectedController.text = _cAmountController.text;
        isLatePay = false;
      }
    }

    setState(() {
      collType = newVal;
    });
  }

  TextEditingController _date = new TextEditingController();
  TextEditingController _colllectedDate = new TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null && picked != DateTime.now())
      setState(
        () {
          if (collType == "4") {
            _colllectedDate.text = DateUtils.formatDate(picked);
          }
          _date.text = DateUtils.formatDate(picked);
          collDate = DateUtils.getUTCDateEpoch(picked);
        },
      );
  }

  Future<Null> _selectCollectedDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != DateTime.now())
      setState(
        () {
          collectedDate = DateUtils.getUTCDateEpoch(picked);
          _colllectedDate.text = DateUtils.formatDate(picked);

          if (collDate < collectedDate) {
            isLatePay = true;
          } else {
            isLatePay = false;
          }
        },
      );
  }

  _submit() async {
    final FormState form = _formKey.currentState;

    if (form.validate()) {
      CustomDialogs.actionWaiting(context, "Adding Collection");

      int type = int.parse(collType);
      int cNumber = int.parse(_cNumberController.text);
      if (type == 0) {
        // check for collection with this collection number
        Collection res = await Collection().getByCollectionNumber(
            widget.payment.financeID,
            widget.payment.branchName,
            widget.payment.subBranchName,
            widget.payment.id,
            cNumber);

        if (res != null) {
          Navigator.pop(context);
          _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
              'Found a Collection with the same Collection NUMBER. Please enter unique Colleciton Number!',
              2));
          return;
        }

        // check already existing collections total amount
        List<Collection> allColl = await Collection()
            .getAllCollectionsForCustomerPayment(
                widget.payment.financeID,
                widget.payment.branchName,
                widget.payment.subBranchName,
                widget.payment.id);

        int cAmount = 0;
        allColl.forEach((c) {
          if (c.type != 1 && c.type != 2 && c.type != 4)
            cAmount += c.collectionAmount;
        });

        if (cAmount == widget.payment.totalAmount) {
          Navigator.pop(context);
          _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
              "You have enough collection entries for this Payment amount $cAmount",
              2));
          return;
        } else if ((cAmount + collAmount) > widget.payment.totalAmount) {
          int bAmount = widget.payment.totalAmount - cAmount;
          Navigator.pop(context);
          _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
              "Total collection amount should not be greater than Payment amount $cAmount! You can create collection for $bAmount",
              2));
          return;
        }
      }

      CollectionController _cc = CollectionController();

      Map<String, dynamic> collDetails = {};
      bool isPaid = false;
      if (int.parse(_aCollectedController.text) > 0) {
        int cAmount = int.parse(_aCollectedController.text);
        if (cAmount >= collAmount) isPaid = true;
        collDetails['amount'] = cAmount;
        collDetails['collected_from'] = widget.payment.custName;
        collDetails['collected_by'] = _user.name;
        collDetails['notes'] = "";
        collDetails['penalty_amount'] = penaltyAmount;
        collDetails['collected_on'] = collectedDate;
        collDetails['transferred_mode'] = 0;
        collDetails['added_by'] = _user.mobileNumber;
        collDetails['is_paid_late'] = isLatePay;
      }

      var result = await _cc.createCollection(
          widget.payment.financeID,
          widget.payment.branchName,
          widget.payment.subBranchName,
          widget.payment.customerID,
          widget.payment.id,
          widget.payment.paymentID,
          cNumber,
          type,
          collAmount,
          isPaid,
          collDate,
          collDetails);

      if (!result['is_success']) {
        Navigator.pop(context);
        _scaffoldKey.currentState
            .showSnackBar(CustomSnackBar.errorSnackBar(result['message'], 5));
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
      }
    } else {
      _scaffoldKey.currentState.showSnackBar(
          CustomSnackBar.errorSnackBar("Please fill required fields!", 2));
    }
  }
}
