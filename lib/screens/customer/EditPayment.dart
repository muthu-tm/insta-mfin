import 'package:flutter/material.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/transaction/payment_controller.dart';

class EditPayment extends StatefulWidget {
  EditPayment(this.payment);

  final Payment payment;

  @override
  _EditPaymentState createState() => _EditPaymentState();
}

class _EditPaymentState extends State<EditPayment> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController principalAmountController = TextEditingController();

  String selectedCollectionModeID = "0";
  Map<String, String> _tempCollectionMode = {
    "0": "Daily",
    "1": "Weekly",
    "2": "Monthly"
  };

  String transferredMode = "0";
  Map<String, String> _transferMode = {
    "0": "Cash",
    "1": "NetBanking",
    "2": "GPay"
  };

  List<int> collectionDays = [1, 2, 3, 4, 5];
  Map<String, String> tempCollectionDays = {
    "0": "Sun",
    "1": "Mon",
    "2": "Tue",
    "3": "Wed",
    "4": "Thu",
    "5": "Fri",
    "6": "Sat",
  };

  TextEditingController _date = new TextEditingController();
  TextEditingController _collectionDate = new TextEditingController();

  Map<String, dynamic> updatedPayment = new Map();

  @override
  void initState() {
    super.initState();
    selectedCollectionModeID = widget.payment.collectionMode.toString();
    principalAmountController.text = widget.payment.principalAmount.toString();

    _date.text =
        DateUtils.getFormattedDateFromEpoch(widget.payment.dateOfPayment);

    _collectionDate.text = DateUtils.getFormattedDateFromEpoch(
        widget.payment.collectionStartsFrom);
    if (widget.payment.collectionMode == 0)
      collectionDays.addAll(widget.payment.collectionDays);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Edit Payment'),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 40,
                      alignment: Alignment.center,
                      child: Text(
                        "General Info",
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              readOnly: true,
                              initialValue: widget.payment.custName,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                labelText: 'Customer name',
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: GestureDetector(
                              onTap: () => _selectPaymentDate(context),
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: _date,
                                  keyboardType: TextInputType.datetime,
                                  decoration: InputDecoration(
                                    labelText: 'Date of Payment',
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
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.text,
                              initialValue: widget.payment.paymentID ?? "",
                              decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                hintText: 'Payment ID',
                                labelText: 'Payment ID',
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
                                if (paymentID.trim() !=
                                    widget.payment.paymentID) {
                                  updatedPayment['payment_id'] =
                                      paymentID.trim();
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
                              initialValue: widget.payment.givenBy,
                              decoration: InputDecoration(
                                hintText: 'Amount given by',
                                labelText: 'Amount given by',
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
                                } else if (givenby.trim() !=
                                    widget.payment.givenBy) {
                                  updatedPayment['given_by'] = givenby.trim();
                                }

                                return null;
                              },
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 10)),
                          Flexible(
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                labelText: 'Transferred Mode',
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
                                _setSelectedTransferredMode(newVal);
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
                          Padding(padding: EdgeInsets.only(left: 10)),
                          Flexible(
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                labelText: 'Collection mode',
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              border: Border.all(
                                  color: Colors.grey[350], width: 1.0),
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
                                    labelText: 'Start date',
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
                              onTap: () => _selectCollectionDate(context),
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: _collectionDate,
                                  keyboardType: TextInputType.datetime,
                                  decoration: InputDecoration(
                                    labelText: 'End date',
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
                          )
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
                                  widget.payment.rCommission.toString(),
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Referral Commission',
                                labelText: 'Referral Commission',
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
                                if (commission.trim() !=
                                    widget.payment.rCommission.toString()) {
                                  if (commission.trim().isEmpty) {
                                    updatedPayment['referral_commission'] = 0;
                                  } else {
                                    updatedPayment['referral_commission'] =
                                        int.parse(commission);
                                  }
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
                              initialValue: widget.payment.notes,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: 'Notes',
                                labelText: 'Notes',
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
                                if (notes.trim() != widget.payment.notes) {
                                  updatedPayment['notes'] = notes.trim();
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
                        "Payment Info",
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
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.number,
                              initialValue:
                                  widget.payment.totalAmount.toString(),
                              decoration: InputDecoration(
                                hintText: 'Total amount',
                                labelText: 'Total amount',
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
                                  return "Total Amount should not be empty!";
                                } else if (amount.trim() !=
                                    widget.payment.totalAmount.toString()) {
                                  updatedPayment['total_amount'] =
                                      int.parse(amount.trim());
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 10)),
                          Flexible(
                            child: TextFormField(
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.number,
                              initialValue:
                                  widget.payment.interestAmount.toString(),
                              decoration: InputDecoration(
                                hintText: 'Interest Amount',
                                labelText: 'Interest Amount',
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
                                int tAmount =
                                    updatedPayment.containsKey('total_amount')
                                        ? updatedPayment['total_amount']
                                        : widget.payment.totalAmount;

                                int iAmount =
                                    tAmount > 0 ? tAmount - int.parse(val) : 0;
                                setState(() {
                                  principalAmountController.text =
                                      iAmount.toString();
                                });
                              },
                              validator: (iRate) {
                                if (iRate.trim() !=
                                    widget.payment.interestAmount.toString()) {
                                  if (iRate.trim().isEmpty) {
                                    updatedPayment['interest_amount'] = 0;
                                  } else {
                                    updatedPayment['interest_amount'] =
                                        int.parse(iRate.trim());
                                  }
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
                              keyboardType: TextInputType.number,
                              controller: principalAmountController,
                              decoration: InputDecoration(
                                hintText: 'Principal amount',
                                labelText: 'Principal amount',
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
                                  return "Principal Amount should not be empty!";
                                } else if (amount.trim() !=
                                    widget.payment.principalAmount.toString()) {
                                  updatedPayment['principal_amount'] =
                                      int.parse(amount.trim());
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 10)),
                          Flexible(
                            child: TextFormField(
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.number,
                              initialValue: widget.payment.tenure.toString(),
                              decoration: InputDecoration(
                                hintText: 'Number of Collections',
                                labelText: 'No. of collections',
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
                              validator: (tenure) {
                                if (tenure.trim().isEmpty) {
                                  return 'Enter the Number of Collections';
                                } else if (tenure.trim() !=
                                    widget.payment.tenure.toString()) {
                                  updatedPayment['tenure'] =
                                      int.parse(tenure.trim());
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
                              keyboardType: TextInputType.number,
                              initialValue:
                                  widget.payment.collectionAmount.toString(),
                              decoration: InputDecoration(
                                hintText: 'Each Collection Amount',
                                labelText: 'Collection amount',
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
                                  return "Collection amount should not be empty pr Zero";
                                } else if (collAmount.trim() !=
                                    widget.payment.collectionAmount
                                        .toString()) {
                                  updatedPayment['collection_amount'] =
                                      int.parse(collAmount.trim());
                                }

                                return null;
                              },
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 10)),
                          Flexible(
                            child: TextFormField(
                                textAlign: TextAlign.start,
                                keyboardType: TextInputType.number,
                                initialValue: widget
                                    .payment.alreadyCollectedAmount
                                    .toString(),
                                decoration: InputDecoration(
                                  hintText: 'Amount received so far',
                                  labelText: 'Amount received',
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
                                  if (collAmount.trim() !=
                                      widget.payment.alreadyCollectedAmount
                                          .toString()) {
                                    updatedPayment['already_collected_amount'] =
                                        int.parse(collAmount.trim());
                                  }
                                  return null;
                                }),
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
                              initialValue: widget.payment.docCharge.toString(),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Document charge',
                                labelText: 'Document charge',
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
                                if (charge.trim() !=
                                    widget.payment.docCharge.toString()) {
                                  if (charge.trim().isEmpty) {
                                    updatedPayment['doc_charge'] = 0;
                                  } else {
                                    updatedPayment['doc_charge'] =
                                        int.parse(charge.trim());
                                  }
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 10)),
                          Flexible(
                            child: TextFormField(
                              textAlign: TextAlign.start,
                              initialValue: widget.payment.surcharge.toString(),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Service charge if any',
                                labelText: 'Service charge',
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
                              validator: (charge) {
                                if (charge.trim() !=
                                    widget.payment.surcharge.toString()) {
                                  if (charge.trim().isEmpty) {
                                    updatedPayment['surcharge'] = 0;
                                  } else {
                                    updatedPayment['surcharge'] =
                                        int.parse(charge.trim());
                                  }
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
              Padding(padding: EdgeInsets.all(40))
            ],
          ),
        ),
      ),
    );
  }

  _setSelectedCollectionMode(String newVal) {
    setState(() {
      if (widget.payment.collectionMode != int.parse(newVal))
        updatedPayment['collection_mode'] = int.parse(newVal);
      selectedCollectionModeID = newVal;
    });
  }

  _setSelectedTransferredMode(String newVal) {
    setState(() {
      if (widget.payment.transferredMode != int.parse(newVal))
        updatedPayment['transferred_mode'] = int.parse(newVal);
      transferredMode = newVal;
    });
  }

  Iterable<Widget> get selectedDays sync* {
    for (MapEntry days in tempCollectionDays.entries) {
      yield Transform(
        transform: Matrix4.identity()..scale(0.8),
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
      initialDate: DateTime.fromMillisecondsSinceEpoch(
          widget.payment.collectionStartsFrom),
      firstDate: DateTime(1990),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null &&
        picked !=
            DateTime.fromMillisecondsSinceEpoch(
                widget.payment.collectionStartsFrom))
      setState(
        () {
          updatedPayment['collection_starts_from'] =
              DateUtils.getUTCDateEpoch(picked);
          _collectionDate.text = DateUtils.formatDate(picked);
        },
      );
  }

  Future<void> _selectPaymentDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate:
          DateTime.fromMillisecondsSinceEpoch(widget.payment.dateOfPayment),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (picked != null &&
        picked !=
            DateTime.fromMillisecondsSinceEpoch(widget.payment.dateOfPayment))
      setState(
        () {
          updatedPayment['date_of_payment'] = DateUtils.getUTCDateEpoch(picked);
          _date.text = DateUtils.formatDate(picked);

          updatedPayment['collection_starts_from'] =
              DateUtils.getUTCDateEpoch(picked.add(Duration(days: 1)));
          _collectionDate.text =
              DateUtils.formatDate(picked.add(Duration(days: 1)));
        },
      );
  }

  _submit() async {
    final FormState form = _formKey.currentState;

    if (selectedCollectionModeID == "0") {
      int collectionDate = updatedPayment.containsKey('collection_starts_from')
          ? updatedPayment['collection_starts_from']
          : widget.payment.collectionStartsFrom;
      if (DateTime.fromMillisecondsSinceEpoch(collectionDate).weekday <= 6 &&
          !collectionDays.contains(
              DateTime.fromMillisecondsSinceEpoch(collectionDate).weekday)) {
        _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
            'Collection Start Date must be in collection days', 2));
        return;
      } else if (DateTime.fromMillisecondsSinceEpoch(collectionDate).weekday ==
              7 &&
          !collectionDays.contains(0)) {
        _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
            'Collection Start Date should be in collection days', 2));
        return;
      }
    }

    if (form.validate()) {
      if (collectionDays != widget.payment.collectionDays)
        updatedPayment['collection_days'] = collectionDays;

      int totalAmount = updatedPayment.containsKey('total_amount')
          ? updatedPayment['total_amount']
          : widget.payment.totalAmount;

      int tenure = updatedPayment.containsKey('tenure')
          ? updatedPayment['tenure']
          : widget.payment.tenure;

      int collectionAmount = updatedPayment.containsKey('collection_amount')
          ? updatedPayment['collection_amount']
          : widget.payment.collectionAmount;

      int alreadyReceivedAmount =
          updatedPayment.containsKey('already_collected_amount')
              ? updatedPayment['already_collected_amount']
              : widget.payment.alreadyCollectedAmount;

      if (totalAmount != tenure * collectionAmount) {
        _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
            'Total amount should be equal to Collection amount * No. of collections',
            3));
        return;
      } else if (!(alreadyReceivedAmount < totalAmount)) {
        _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
            'Amount Received should be lesser than Total Amount', 3));
        return;
      }

      if (updatedPayment.length == 0) {
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        CustomDialogs.actionWaiting(context, "Editing Payment");
        PaymentController _pc = PaymentController();
        var result = await _pc.updatePayment(widget.payment, updatedPayment);

        if (!result['is_success']) {
          Navigator.pop(context);
          _scaffoldKey.currentState
              .showSnackBar(CustomSnackBar.errorSnackBar(result['message'], 5));
        } else {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          _scaffoldKey.currentState.showSnackBar(CustomSnackBar.successSnackBar(
              "Please wait... We are updating your collections..!", 3));
        }
      }
    } else {
      _scaffoldKey.currentState.showSnackBar(
          CustomSnackBar.errorSnackBar("Please fill required fields!", 2));
    }
  }
}
