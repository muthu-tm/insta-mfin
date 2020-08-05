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

class AddCustomCollection extends StatefulWidget {
  AddCustomCollection(this.payment, this.colls, this.tReceived);

  final Payment payment;
  final List<Collection> colls;
  final int tReceived;

  @override
  _AddCustomCollectionState createState() => _AddCustomCollectionState();
}

class _AddCustomCollectionState extends State<AddCustomCollection> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final User _user = UserController().getCurrentUser();

  Map<String, dynamic> collDetails = {
    'collected_on': DateUtils.getUTCDateEpoch(DateTime.now()),
    'penalty_amount': 0
  };

  String transferredMode = "0";
  Map<String, String> _transferMode = {
    "0": "Cash",
    "1": "NetBanking",
    "2": "GPay"
  };

  int collectedOn = DateUtils.getUTCDateEpoch(DateTime.now());
  int totalAmount = 0;
  int collectedAmount = 0;
  int status = 0;
  String collectedBy = '';
  String receivedFrom = '';
  String notes = '';

  @override
  void initState() {
    super.initState();
    this._date.text = DateUtils.formatDate(DateTime.now());
    this.receivedFrom = widget.payment.custName;
    this.collectedBy = _user.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Add Collection Details'),
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
                elevation: 10.0,
                margin: EdgeInsets.only(
                    top: 10.0, bottom: 10.0, left: 5.0, right: 5.0),
                shadowColor: CustomColors.mfinPositiveGreen,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              readOnly: true,
                              initialValue: widget.payment.custName,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                labelText: "Customer Name",
                                labelStyle: TextStyle(
                                  fontSize: 10,
                                  color: CustomColors.mfinBlue,
                                ),
                                fillColor: CustomColors.mfinLightGrey,
                                filled: true,
                              ),
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
                            child: GestureDetector(
                              onTap: () => _selectDate(context),
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: _date,
                                  keyboardType: TextInputType.datetime,
                                  decoration: InputDecoration(
                                    hintText: 'Date Collected',
                                    labelText: "Collected On",
                                    labelStyle: TextStyle(
                                      fontSize: 10,
                                      color: CustomColors.mfinBlue,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
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
                          Padding(padding: EdgeInsets.only(left: 5)),
                          Flexible(
                            child: TextFormField(
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.number,
                              initialValue: totalAmount.toString(),
                              decoration: InputDecoration(
                                hintText: 'Collected Amount',
                                labelText: 'Collected Amount',
                                labelStyle: TextStyle(
                                  fontSize: 10,
                                  color: CustomColors.mfinBlue,
                                ),
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 3.0),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: CustomColors.mfinWhite)),
                              ),
                              validator: (amount) {
                                if (amount.trim().isEmpty ||
                                    amount.trim() == "0") {
                                  return "Collected Amount should not be empty!";
                                } else {
                                  collectedAmount = int.parse(amount.trim());
                                  return null;
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
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                labelText: 'Transferred Mode',
                                labelStyle: TextStyle(
                                  fontSize: 10,
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
                      padding: EdgeInsets.all(5.0),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.text,
                              initialValue: receivedFrom,
                              decoration: InputDecoration(
                                hintText: 'Amount Received From',
                                labelText: "Collected From",
                                labelStyle: TextStyle(
                                  fontSize: 10,
                                  color: CustomColors.mfinBlue,
                                ),
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 3.0),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: CustomColors.mfinWhite)),
                              ),
                              validator: (receivedFrom) {
                                if (receivedFrom.trim().isEmpty) {
                                  return "Fill the person name who Paid the amount";
                                }
                                this.receivedFrom = receivedFrom.trim();
                                return null;
                              },
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 5)),
                          Flexible(
                            child: TextFormField(
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.text,
                              initialValue: collectedBy,
                              decoration: InputDecoration(
                                hintText: 'Amount Collected by',
                                labelText: "Collected By",
                                labelStyle: TextStyle(
                                  fontSize: 10,
                                  color: CustomColors.mfinBlue,
                                ),
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 3.0),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: CustomColors.mfinWhite)),
                              ),
                              validator: (collectedBy) {
                                if (collectedBy.trim().isEmpty) {
                                  return "Please fill the person name who collected the amount";
                                }
                                this.collectedBy = collectedBy.trim();
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
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.text,
                              initialValue: notes,
                              maxLines: 2,
                              decoration: InputDecoration(
                                labelText: 'Notes',
                                hintText:
                                    "Short notes/reference about the Collection",
                                labelStyle: TextStyle(
                                  fontSize: 10,
                                  color: CustomColors.mfinBlue,
                                ),
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 3.0),
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
            ],
          ),
        ),
      ),
    );
  }

  _setTransferredMode(String newVal) {
    setState(() {
      transferredMode = newVal;
    });
  }

  TextEditingController _date = new TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != DateTime.now())
      setState(
        () {
          collDetails['collected_on'] = DateUtils.getUTCDateEpoch(picked);
          collectedOn = DateUtils.getUTCDateEpoch(picked);
          _date.text = DateUtils.formatDate(picked);
        },
      );
  }

  _submit() async {
    final FormState form = _formKey.currentState;

    if (form.validate()) {
      CustomDialogs.actionWaiting(context, "Adding Collection");
      if (widget.payment.totalAmount < widget.tReceived + collectedAmount) {
        Navigator.pop(context);
        _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
            "You are trying to add more than Payment's total amount, try Settlement!",
            3));
        return;
      }

      CollectionController _cc = CollectionController();

      if (widget.colls.length >= widget.payment.tenure) {
        int remainingAmount = collectedAmount;
        var result = {
          'is_success': false,
          'message': "Unable to process your request!"
        };

        for (int i = 0; i < widget.colls.length && remainingAmount > 0; i++) {
          Collection coll = widget.colls[i];

          if (!coll.isPaid) {
            bool isPaid = false;

            //check existing collectiondate matches with the current one
            if (coll.collectedOn.contains(collectedOn)) {
              result = {
                'is_success': false,
                'message':
                    "Already added a collection on this day, please remove/edit the same!"
              };

              break;
            }

            if (coll.collectionDate >= collectedOn)
              collDetails['is_paid_late'] = false;
            else
              collDetails['is_paid_late'] = true;

            if ((coll.collectionAmount - coll.getReceived()) <=
                remainingAmount) {
              isPaid = true;
              collDetails['amount'] =
                  coll.collectionAmount - coll.getReceived();
              remainingAmount = remainingAmount -
                  (coll.collectionAmount - coll.getReceived());
            } else {
              isPaid = false;
              collDetails['amount'] = remainingAmount;
              remainingAmount = 0;
            }

            collDetails['notes'] = notes;
            collDetails['collected_from'] = receivedFrom;
            collDetails['collected_by'] = collectedBy;
            collDetails['penalty_amount'] = 0;
            collDetails['collected_on'] = collectedOn;
            collDetails['transferred_mode'] = int.parse(transferredMode);
            collDetails['created_at'] = DateTime.now();
            collDetails['added_by'] = _user.mobileNumber;
            int id = coll.collectionDate;
            if (coll.type == 3) id = coll.collectionDate + 3;

            result = await _cc.updateCollectionDetails(
                coll.financeID,
                coll.branchName,
                coll.subBranchName,
                coll.paymentID,
                id,
                isPaid,
                true,
                collDetails,
                false);

            // stop the loop for any error
            if (!result['is_success']) {
              result = {'is_success': false, 'message': result['message']};
              break;
            }
          }
        }
        if (!result['is_success']) {
          Navigator.pop(context);
          _scaffoldKey.currentState.showSnackBar(
            CustomSnackBar.errorSnackBar(result['message'], 5),
          );
        } else {
          Navigator.pop(context);
          Navigator.pop(context);
        }
      } else {
        Map<String, dynamic> collDetails = {};

        collDetails['amount'] = collectedAmount;
        collDetails['collected_from'] = receivedFrom;
        collDetails['collected_by'] = collectedBy;
        collDetails['notes'] = notes;
        collDetails['penalty_amount'] = 0;
        collDetails['collected_on'] = collectedOn;
        collDetails['transferred_mode'] = transferredMode;
        collDetails['added_by'] = _user.mobileNumber;
        collDetails['is_paid_late'] = false;
        var result = await _cc.createCollection(
            widget.payment.financeID,
            widget.payment.branchName,
            widget.payment.subBranchName,
            widget.payment.customerID,
            widget.payment.id,
            widget.payment.paymentID,
            widget.colls.length + 1,
            0,
            collectedAmount,
            true,
            collectedOn,
            collDetails);

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
