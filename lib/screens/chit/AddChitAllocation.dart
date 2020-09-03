import 'package:flutter/material.dart';
import 'package:instamfin/db/models/chit_allocation_details.dart';
import 'package:instamfin/db/models/chit_allocations.dart';
import 'package:instamfin/db/models/chit_fund_details.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/chit/chit_allocation_controller.dart';
import 'package:instamfin/services/controllers/user/user_service.dart';

import '../../app_localizations.dart';

class AddChitAllocation extends StatefulWidget {
  AddChitAllocation(this.chitAlloc, this.fund);

  final ChitAllocations chitAlloc;
  final ChitFundDetails fund;

  @override
  _AddChitAllocationState createState() => _AddChitAllocationState();
}

class _AddChitAllocationState extends State<AddChitAllocation> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ChitAllocationDetails allocDetails = ChitAllocationDetails();

  String transferredMode = "0";
  Map<String, String> _transferMode = {
    "0": "Cash",
    "1": "NetBanking",
    "2": "GPay"
  };

  int allocatedOn = DateUtils.getUTCDateEpoch(DateTime.now());
  int amount = 0;
  String givenBy = '';
  String givenTo = '';
  String notes = '';

  @override
  void initState() {
    super.initState();
    this._date.text = DateUtils.formatDate(DateTime.now());
    this.givenBy = cachedLocalUser.name;
    this.amount =
        widget.chitAlloc.allocationAmount - widget.chitAlloc.getTotalPaid();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate('add_allocation'),
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
                          widget.chitAlloc.chitNumber.toString(),
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: "Georgia",
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinBlue,
                          ),
                        ),
                        trailing: Text(
                          DateUtils.getFormattedDateFromEpoch(
                              widget.fund.chitDate),
                          textAlign: TextAlign.center,
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
                                        .translate('date_given'),
                                    labelText: AppLocalizations.of(context)
                                        .translate('given_on'),
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
                              initialValue: amount.toString(),
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)
                                    .translate('given_amount'),
                                labelText: AppLocalizations.of(context)
                                    .translate('given_amount'),
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
                                  this.amount = int.parse(amount.trim());
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
                                    .translate('given_to'),
                                labelText: AppLocalizations.of(context)
                                    .translate('given_to'),
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
                              validator: (given) {
                                if (given.trim().isEmpty) {
                                  this.givenTo = "";
                                } else {
                                  this.givenTo = given.trim();
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
                              initialValue: givenBy,
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)
                                    .translate('given_by'),
                                labelText: AppLocalizations.of(context)
                                    .translate('given_by'),
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
                              validator: (givenBy) {
                                if (givenBy.trim().isEmpty) {
                                  return "Please fill the person name who collected the amount";
                                }
                                givenBy = givenBy.trim();
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
                                  notes = "";
                                } else {
                                  notes = notes.trim();
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
          allocatedOn = DateUtils.getUTCDateEpoch(picked);
          _date.value = TextEditingValue(
            text: DateUtils.formatDate(picked),
          );
        },
      );
  }

  _submit() async {
    final FormState form = _formKey.currentState;

    if (form.validate()) {
      if (amount >
          (widget.fund.allocationAmount - widget.chitAlloc.getTotalPaid())) {
        _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
            AppLocalizations.of(context).translate('amount_equal'), 3));
      } else {
        CustomDialogs.actionWaiting(context, "Updating Allocation");
        ChitAllocationController _cc = ChitAllocationController();
        bool isPaid = false;

        if (amount + widget.chitAlloc.getTotalPaid() >=
            widget.fund.allocationAmount) isPaid = true;

        allocDetails.addedBy = cachedLocalUser.getIntID();
        allocDetails.amount = amount;
        allocDetails.createdAt = DateTime.now();
        allocDetails.givenBy = givenBy;
        allocDetails.givenOn = allocatedOn;
        allocDetails.givenTo = givenTo;
        allocDetails.notes = notes;
        allocDetails.transferredMode = int.parse(transferredMode);

        var result = await _cc.updateAllocationDetails(
            widget.chitAlloc.financeID,
            widget.chitAlloc.branchName,
            widget.chitAlloc.subBranchName,
            widget.chitAlloc.chitID,
            widget.fund.chitNumber,
            isPaid,
            true,
            allocDetails.toJson());

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
