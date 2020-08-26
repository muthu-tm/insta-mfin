import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/db/models/collection.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/screens/customer/widgets/CollectionDetailsWidget.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/transaction/collection_controller.dart';
import 'package:instamfin/services/controllers/user/user_service.dart';
import 'package:instamfin/services/pdf/collection_receipt.dart';

import '../../app_localizations.dart';

class ViewCollection extends StatefulWidget {
  ViewCollection(this.pay, this._collection, this.iconColor);

  final Payment pay;
  final Collection _collection;
  final Color iconColor;

  @override
  _ViewCollectionState createState() => _ViewCollectionState();
}

class _ViewCollectionState extends State<ViewCollection> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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

  TextEditingController totalAmountController = TextEditingController();

  int totalAmount = 0;
  int status = 0;
  String collectedBy = '';
  String receivedFrom = '';
  String notes = '';
  bool isLatePay = false;
  bool hasPenalty = false;
  bool isReceived = false;

  @override
  void initState() {
    super.initState();
    this._date.text = DateUtils.formatDate(DateTime.now());
    this.receivedFrom = widget.pay.custName;
    this.collectedBy = cachedLocalUser.name;
    this.totalAmount =
        widget._collection.collectionAmount - widget._collection.getReceived();
    this.totalAmountController.text = this.totalAmount.toString();

    if (widget._collection.collectionDate <
        (DateUtils.getCurrentUTCDate().millisecondsSinceEpoch)) {
      setState(() {
        isLatePay = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Collection().streamCollectionByID(
          widget._collection.financeID,
          widget._collection.branchName,
          widget._collection.subBranchName,
          widget._collection.paymentID,
          (widget._collection.type != 1 &&
                  widget._collection.type != 2 &&
                  widget._collection.type != 3 &&
                  widget._collection.type != 4 &&
                  widget._collection.type != 5)
              ? widget._collection.collectionDate
              : (widget._collection.collectionDate + widget._collection.type)),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          if (snapshot.data.exists) {
            Collection collection = Collection.fromJson(snapshot.data.data);
            totalAmountController.text =
                (collection.collectionAmount - collection.getReceived())
                    .toString();

            (collection.getReceived() >= collection.collectionAmount)
                ? isReceived = true
                : isReceived = false;

            children = <Widget>[
              ListTile(
                leading: Icon(
                  Icons.drafts,
                  size: 35.0,
                  color: widget.iconColor,
                ),
                title: Text(
                  collection.getType(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: CustomColors.mfinBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.print,
                    size: 35.0,
                    color: CustomColors.mfinBlack,
                  ),
                  onPressed: () async {
                    await CollectionReceipt().generateInvoice(
                        cachedLocalUser, widget.pay, collection);
                  },
                ),
              ),
              Divider(
                color: CustomColors.mfinButtonGreen,
              ),
              ListTile(
                leading: SizedBox(
                  width: 100,
                  child: Text(
                    AppLocalizations.of(context).translate('customer_caps'),
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Georgia",
                      fontWeight: FontWeight.bold,
                      color: CustomColors.mfinGrey,
                    ),
                  ),
                ),
                title: TextFormField(
                  readOnly: true,
                  initialValue: widget.pay.custName,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: CustomColors.mfinGrey,
                      ),
                    ),
                    fillColor: CustomColors.mfinLightGrey,
                    filled: true,
                  ),
                ),
              ),
              ListTile(
                leading: SizedBox(
                  width: 100,
                  child: Text(
                    AppLocalizations.of(context).translate('coll_no_caps'),
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Georgia",
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mfinGrey),
                  ),
                ),
                title: TextFormField(
                  readOnly: true,
                  textAlign: TextAlign.end,
                  initialValue: collection.collectionNumber.toString(),
                  decoration: InputDecoration(
                    fillColor: CustomColors.mfinWhite,
                    filled: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: CustomColors.mfinGrey,
                      ),
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: SizedBox(
                  width: 100,
                  child: Text(
                    AppLocalizations.of(context).translate('date_caps'),
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Georgia",
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mfinGrey),
                  ),
                ),
                title: TextFormField(
                  readOnly: true,
                  textAlign: TextAlign.end,
                  initialValue: DateUtils.formatDate(
                      DateTime.fromMillisecondsSinceEpoch(
                          collection.collectionDate)),
                  decoration: InputDecoration(
                    fillColor: CustomColors.mfinWhite,
                    filled: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: CustomColors.mfinGrey,
                      ),
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
                        fontSize: 15,
                        fontFamily: "Georgia",
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mfinGrey),
                  ),
                ),
                title: TextFormField(
                  readOnly: true,
                  textAlign: TextAlign.end,
                  initialValue: collection.collectionAmount.toString(),
                  decoration: InputDecoration(
                    fillColor: CustomColors.mfinWhite,
                    filled: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: CustomColors.mfinGrey,
                      ),
                    ),
                  ),
                ),
              ),
              !isReceived
                  ? Card(
                      elevation: 5.0,
                      color: CustomColors.mfinLightGrey,
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Divider(
                              color: CustomColors.mfinButtonGreen,
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
                                            labelText:
                                                AppLocalizations.of(context)
                                                    .translate('collected_on'),
                                            labelStyle: TextStyle(
                                              fontSize: 10.0,
                                              color: CustomColors.mfinBlue,
                                            ),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 3.0,
                                                    horizontal: 3.0),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: CustomColors
                                                        .mfinWhite)),
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
                                      controller: totalAmountController,
                                      decoration: InputDecoration(
                                        hintText: 'Collected Amount',
                                        labelText: AppLocalizations.of(context)
                                            .translate('collected_amount'),
                                        labelStyle: TextStyle(
                                          fontSize: 10.0,
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
                                          fontSize: 10.0,
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
                                        labelText: AppLocalizations.of(context)
                                            .translate('collected_from'),
                                        labelStyle: TextStyle(
                                          fontSize: 10.0,
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

                                        collDetails['collected_from'] =
                                            receivedFrom.trim();
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
                                        labelText: AppLocalizations.of(context)
                                            .translate('collected_by'),
                                        labelStyle: TextStyle(
                                          fontSize: 10.0,
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
                                        hintText:
                                            "Short notes/reference about the Collection",
                                        labelStyle: TextStyle(
                                          fontSize: 10.0,
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
                            isLatePay
                                ? Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: TextFormField(
                                      textAlign: TextAlign.end,
                                      keyboardType: TextInputType.number,
                                      initialValue: '0',
                                      decoration: InputDecoration(
                                        hintText: 'Penalty Amount',
                                        labelText: AppLocalizations.of(context)
                                            .translate('penalty_amount'),
                                        labelStyle: TextStyle(
                                          fontSize: 10.0,
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
                                          collDetails['penalty_amount'] = 0;
                                          hasPenalty = false;
                                        } else {
                                          hasPenalty = true;
                                          collDetails['penalty_amount'] =
                                              int.parse(amount.trim());
                                        }
                                        return null;
                                      },
                                    ),
                                  )
                                : Padding(
                                    padding: EdgeInsets.all(5.0),
                                  ),
                            Padding(
                              padding: EdgeInsets.all(5.0),
                              child: RaisedButton.icon(
                                color:
                                    CustomColors.mfinAlertRed.withOpacity(0.7),
                                onPressed: () async {
                                  if (isReceived) {
                                    _scaffoldKey.currentState.showSnackBar(
                                        CustomSnackBar.errorSnackBar(
                                            "You have already collected full Amount",
                                            3));
                                    return;
                                  } else {
                                    await _submit();
                                  }
                                },
                                icon: Icon(Icons.collections_bookmark),
                                label: Text("Add Collection"),
                              ),
                            ),
                            Divider(
                              color: CustomColors.mfinButtonGreen,
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListTile(
                      leading: SizedBox(
                        width: 100,
                        child: Text(
                          AppLocalizations.of(context)
                              .translate('received_caps'),
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Georgia",
                              fontWeight: FontWeight.bold,
                              color: CustomColors.mfinGrey),
                        ),
                      ),
                      title: TextFormField(
                        readOnly: true,
                        textAlign: TextAlign.end,
                        initialValue: collection.getReceived().toString(),
                        decoration: InputDecoration(
                          fillColor: CustomColors.mfinWhite,
                          filled: true,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 3.0),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: CustomColors.mfinGrey,
                            ),
                          ),
                        ),
                      ),
                    ),
              CollectionDetailsWidget(widget.pay.isSettled, _scaffoldKey,
                  collection, widget.pay.custName),
            ];
          } else {
            // No Collections available for this filterred view
            children = [
              Container(
                height: 90,
                child: Column(
                  children: <Widget>[
                    Spacer(),
                    Text(
                      AppLocalizations.of(context)
                          .translate('unable_find_collection'),
                      style: TextStyle(
                        color: CustomColors.mfinAlertRed,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ];
          }
        } else if (snapshot.hasError) {
          children = AsyncWidgets.asyncError();
        } else {
          children = AsyncWidgets.asyncWaiting();
        }

        return Scaffold(
          appBar: AppBar(
            title:
                Text(AppLocalizations.of(context).translate('view_collection')),
            backgroundColor: CustomColors.mfinBlue,
          ),
          key: _scaffoldKey,
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: children),
            ),
          ),
        );
      },
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

          if (widget._collection.collectionDate <
              (collDetails['collected_on'])) {
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
          (widget._collection.collectionAmount -
              widget._collection.getReceived())) {
        _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
            "Collected AMOUNT must be equal or lesser than Balance Amount", 3));
      } else {
        CustomDialogs.actionWaiting(context, "Updating Collection");
        CollectionController _cc = CollectionController();
        bool isPaid = false;

        if (collDetails['amount'] + widget._collection.getReceived() >=
            widget._collection.collectionAmount) isPaid = true;

        collDetails['transferred_mode'] = int.parse(transferredMode);
        collDetails['created_at'] = DateTime.now();
        collDetails['added_by'] = cachedLocalUser.getIntID();
        collDetails['is_paid_late'] = isLatePay;
        int id = widget._collection.collectionDate;
        if (widget._collection.type == 3)
          id = widget._collection.collectionDate + 3;
        var result = await _cc.updateCollectionDetails(
            widget._collection.financeID,
            widget._collection.branchName,
            widget._collection.subBranchName,
            widget._collection.paymentID,
            id,
            isPaid,
            true,
            collDetails,
            hasPenalty);

        if (!result['is_success']) {
          Navigator.pop(context);
          _scaffoldKey.currentState
              .showSnackBar(CustomSnackBar.errorSnackBar(result['message'], 5));
        } else {
          Navigator.pop(context);
        }
      }
    } else {
      _scaffoldKey.currentState.showSnackBar(
          CustomSnackBar.errorSnackBar("Please fill required fields!", 2));
    }
  }
}
