import 'package:flutter/material.dart';
import 'package:instamfin/db/models/chit_collection.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/chit/chit_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

import '../../app_localizations.dart';

class AddChitCollectionDetails extends StatefulWidget {
  AddChitCollectionDetails(this.collection);

  final ChitCollection collection;

  @override
  _AddChitCollectionDetailsState createState() =>
      _AddChitCollectionDetailsState();
}

class _AddChitCollectionDetailsState extends State<AddChitCollectionDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final User _user = UserController().getCurrentUser();

  Map<String, dynamic> collDetails = {
    'collected_on': DateUtils.getUTCDateEpoch(DateTime.now()),
  };

  String transferredMode = "0";
  Map<String, String> _transferMode = {
    "0": "Cash",
    "1": "NetBanking",
    "2": "GPay"
  };

  int totalAmount = 0;
  int status = 0;
  String collectedBy = '';
  String notes = '';
  bool isLatePay = false;

  @override
  void initState() {
    super.initState();
    this._date.text = DateUtils.formatDate(DateTime.now());
    this.collectedBy = _user.name;
    this.totalAmount =
        widget.collection.collectionAmount - widget.collection.getReceived();

    if (widget.collection.chitDate <
        (DateUtils.getCurrentUTCDate().millisecondsSinceEpoch)) {
      setState(() {
        isLatePay = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate('chit_collection_details'),
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
                elevation: 10.0,
                margin: EdgeInsets.only(
                    top: 10.0, bottom: 10.0, left: 5.0, right: 5.0),
                shadowColor: CustomColors.mfinPositiveGreen,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 40,
                      alignment: Alignment.center,
                      child: ListTile(
                        leading: Text(
                          widget.collection.chitNumber.toString(),
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: "Georgia",
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinBlue,
                          ),
                        ),
                        title: Text(
                          DateUtils.getFormattedDateFromEpoch(
                              widget.collection.chitDate),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: "Georgia",
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinBlue,
                          ),
                        ),
                        trailing: Text(
                          widget.collection.getReceived().toString(),
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
                                    hintText: AppLocalizations.of(context)
                                        .translate('date_collected'),
                                    labelText: AppLocalizations.of(context)
                                        .translate('collected_on'),
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
                              textAlign: TextAlign.end,
                              keyboardType: TextInputType.number,
                              initialValue: totalAmount.toString(),
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)
                                    .translate('collected_amount'),
                                labelText: AppLocalizations.of(context)
                                    .translate('collected_amount'),
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
                                  collDetails['amount'] =
                                      int.parse(amount.trim());
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
                                labelText: AppLocalizations.of(context)
                                    .translate('transferred_mode'),
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
                              textAlign: TextAlign.end,
                              keyboardType: TextInputType.text,
                              initialValue: "",
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)
                                    .translate('amount_received_from'),
                                labelText: AppLocalizations.of(context)
                                    .translate('collected_from'),
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
                                  collDetails['collected_from'] = "";
                                } else {
                                  collDetails['collected_from'] =
                                      receivedFrom.trim();
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 5)),
                          Flexible(
                            child: TextFormField(
                              textAlign: TextAlign.end,
                              keyboardType: TextInputType.text,
                              initialValue: collectedBy,
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)
                                    .translate('amount_collected_by'),
                                labelText: AppLocalizations.of(context)
                                    .translate('collected_by'),
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
                                  return "Person who collected the amount";
                                }

                                collDetails['collected_by'] =
                                    collectedBy.trim();
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
                                labelText: AppLocalizations.of(context)
                                    .translate('notes'),
                                hintText: AppLocalizations.of(context)
                                    .translate('notes_hint'),
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
                                  collDetails['notes'] = "";
                                } else {
                                  collDetails['notes'] = notes.trim();
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
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: 50,
                    child: CheckboxListTile(
                      value: isLatePay,
                      onChanged: (bool newValue) {
                        setState(() {
                          isLatePay = newValue;
                        });
                        collDetails['is_paid_late'] = newValue;
                      },
                      title: Text(
                        AppLocalizations.of(context)
                            .translate('is_collected_late'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: "Georgia",
                          fontWeight: FontWeight.bold,
                          color: CustomColors.mfinBlue,
                        ),
                      ),
                      controlAffinity: ListTileControlAffinity.trailing,
                      activeColor: CustomColors.mfinAlertRed,
                    ),
                  ),
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
          _date.value = TextEditingValue(
            text: DateUtils.formatDate(picked),
          );

          if (widget.collection.chitDate < (collDetails['collected_on'])) {
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
      if (collDetails['amount'] >
          (widget.collection.collectionAmount -
              widget.collection.getReceived())) {
        _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
            AppLocalizations.of(context).translate('collected_equal'), 3));
      } else {
        CustomDialogs.actionWaiting(context, "Updating Collection");
        ChitController _cc = ChitController();
        bool isPaid = false;

        if (collDetails['amount'] + widget.collection.getReceived() >=
            widget.collection.collectionAmount) isPaid = true;

        collDetails['transferred_mode'] = int.parse(transferredMode);
        collDetails['created_at'] = DateTime.now();
        collDetails['added_by'] = _user.mobileNumber;
        collDetails['is_paid_late'] = isLatePay;
        var result = await _cc.updateCollectionDetails(
            widget.collection.financeID,
            widget.collection.branchName,
            widget.collection.subBranchName,
            widget.collection.chitID,
            widget.collection.customerNumber,
            widget.collection.chitNumber,
            isPaid,
            true,
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
      _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
          AppLocalizations.of(context).translate('please_fill'), 2));
    }
  }
}
