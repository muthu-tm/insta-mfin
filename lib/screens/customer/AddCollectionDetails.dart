import 'package:flutter/material.dart';
import 'package:instamfin/db/models/collection.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/transaction/collection_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class AddCollectionDetails extends StatefulWidget {
  AddCollectionDetails(this.collection, this.custName);

  final Collection collection;
  final String custName;

  @override
  _AddCollectionDetailsState createState() => _AddCollectionDetailsState();
}

class _AddCollectionDetailsState extends State<AddCollectionDetails> {
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

  int totalAmount = 0;
  int status = 0;
  String collectedBy = '';
  String receivedFrom = '';
  String notes = '';
  bool isLatePay = false;
  bool hasPenalty = false;

  @override
  void initState() {
    super.initState();
    this._date.text = DateUtils.formatDate(DateTime.now());
    this.receivedFrom = widget.custName;
    this.collectedBy = _user.name;
    this.totalAmount =
        widget.collection.collectionAmount - widget.collection.getReceived();

    if (widget.collection.collectionDate <
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
                          widget.collection.collectionNumber.toString(),
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: "Georgia",
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinBlue,
                          ),
                        ),
                        title: Text(
                          DateUtils.getFormattedDateFromEpoch(
                              widget.collection.collectionDate),
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
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              readOnly: true,
                              initialValue: widget.custName,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                labelText: "Customer Name",
                                labelStyle: TextStyle(
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
                      padding: const EdgeInsets.all(8.0),
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
                          Padding(padding: EdgeInsets.only(left: 10)),
                          Flexible(
                            child: TextFormField(
                              textAlign: TextAlign.end,
                              keyboardType: TextInputType.number,
                              initialValue: totalAmount.toString(),
                              decoration: InputDecoration(
                                hintText: 'Collected Amount',
                                labelText: 'Collected Amount',
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
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
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
                            child: TextFormField(
                              textAlign: TextAlign.end,
                              keyboardType: TextInputType.text,
                              initialValue: receivedFrom,
                              decoration: InputDecoration(
                                hintText: 'Amount Received From',
                                labelText: "Collected From",
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
                          Padding(padding: EdgeInsets.only(left: 10)),
                          Flexible(
                            child: TextFormField(
                              textAlign: TextAlign.end,
                              keyboardType: TextInputType.text,
                              initialValue: collectedBy,
                              decoration: InputDecoration(
                                hintText: 'Amount Collected by',
                                labelText: "Collected By",
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
                      padding: const EdgeInsets.all(8.0),
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
                padding: const EdgeInsets.all(10.0),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.75,
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
                        "Is Collected Late? ",
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
                              borderSide:
                                  BorderSide(color: CustomColors.mfinWhite)),
                        ),
                        validator: (amount) {
                          if (amount.trim().isEmpty || amount.trim() == "0") {
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
                      padding: const EdgeInsets.all(10.0),
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

          if (widget.collection.collectionDate <
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
          (widget.collection.collectionAmount -
              widget.collection.getReceived())) {
        _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
            "Collected AMOUNT must be equal or lesser than Balance Amount", 3));
      } else {
        CustomDialogs.actionWaiting(context, "Updating Collection");
        CollectionController _cc = CollectionController();
        bool isPaid = false;

        if (collDetails['amount'] + widget.collection.getReceived() >= widget.collection.collectionAmount)
          isPaid = true;

        collDetails['transferred_mode'] = int.parse(transferredMode);
        collDetails['created_at'] = DateTime.now();
        collDetails['added_by'] = _user.mobileNumber;
        collDetails['is_paid_late'] = isLatePay;
        var result = await _cc.updateCollectionDetails(
            widget.collection.financeID,
            widget.collection.branchName,
            widget.collection.subBranchName,
            widget.collection.paymentID,
            widget.collection.collectionDate,
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
          Navigator.pop(context);
        }
      }
    } else {
      _scaffoldKey.currentState.showSnackBar(
          CustomSnackBar.errorSnackBar("Please fill required fields!", 2));
    }
  }
}
