import 'package:flutter/material.dart';
import 'package:instamfin/db/models/collection_details.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/transaction/collection_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

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
        title: Text('Add Collection'),
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
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Card(
                elevation: 10.0,
                margin: EdgeInsets.only(
                    top: 10.0, bottom: 10.0, left: 5.0, right: 5.0),
                shadowColor: CustomColors.mfinPositiveGreen,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 40,
                      alignment: Alignment.center,
                      child: ListTile(
                        leading: Text(
                          DateUtils.formatDate(
                              DateTime.fromMillisecondsSinceEpoch(
                                  widget.payment.dateOfPayment)),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: "Georgia",
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinAlertRed,
                          ),
                        ),
                        title: Text(
                          widget.payment.customerNumber.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: "Georgia",
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinBlue,
                          ),
                        ),
                        trailing: Text(
                          widget.payment.paymentID.toString(),
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: "Georgia",
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinBlue,
                          ),
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
                              controller: _cNumberController,
                              readOnly: collType == "0" || collType == "4"
                                  ? false
                                  : true,
                              keyboardType: TextInputType.datetime,
                              decoration: InputDecoration(
                                hintText: 'Collection Number',
                                labelText: "Collection Number",
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
                                  if (collType != "0" && collType != "4")
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
                                labelText: 'Type',
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
                                hintText: 'Collection Amount',
                                labelText: 'Collection Amount',
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
                                    hintText: 'Collection Date',
                                    labelText: "Collection Date",
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
                                hintText: 'Collected Amount',
                                labelText: 'Already Collected Amount',
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
                                    hintText: 'Collected Date',
                                    labelText: "Collected Date",
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
                                hintText: 'Penalty Amount',
                                labelText: 'Penalty Amount',
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
      lastDate: DateTime.now().add(Duration(days: 365)),
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
      CustomDialogs.actionWaiting(context, "Updating Collection");
      CollectionController _cc = CollectionController();

      CollectionDetails collectionDetails;
      if (int.parse(_aCollectedController.text) > 0) {
        Map<String, dynamic> collDetails = {};
        collDetails['amount'] = int.parse(_aCollectedController.text);
        collDetails['collected_from'] = widget.payment.custName;
        collDetails['collected_by'] = _user.name;
        collDetails['notes'] = "";
        collDetails['penalty_amount'] = penaltyAmount;
        collDetails['collected_on'] = collectedDate;
        collDetails['transferred_mode'] = 0;
        collDetails['created_at'] = DateTime.now();
        collDetails['added_by'] = _user.mobileNumber;
        collDetails['is_paid_late'] = isLatePay;

        collectionDetails = CollectionDetails.fromJson(collDetails);
      }

      var result = await _cc.createCollection(
          widget.payment.financeID,
          widget.payment.branchName,
          widget.payment.subBranchName,
          widget.payment.customerNumber,
          widget.payment.createdAt,
          int.parse(_cNumberController.text),
          int.parse(collType),
          collAmount,
          collDate,
          collectionDetails);

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
