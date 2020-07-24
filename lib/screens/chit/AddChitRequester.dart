import 'package:flutter/material.dart';
import 'package:instamfin/db/models/chit_fund.dart';
import 'package:instamfin/db/models/chit_requesters.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/chit/chit_controller.dart';

import '../../app_localizations.dart';

class AddChitRequester extends StatefulWidget {
  AddChitRequester(this.chit);

  final ChitFund chit;
  @override
  _AddChitRequesterState createState() => _AddChitRequesterState();
}

class _AddChitRequesterState extends State<AddChitRequester> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int selectedCust;
  List<int> customers = [];
  List<int> chitNumbers = [];

  DateTime selectedDate = DateTime.now();
  String notes = "";
  int chitNumber = 1;

  TextEditingController _date = new TextEditingController();

  @override
  void initState() {
    super.initState();

    _date.text = DateUtils.formatDate(DateTime.now());
    customers = widget.chit.customers;
    selectedCust = customers[0];
    for (int i = 0; i < widget.chit.tenure; i++) {
      chitNumbers.add(i + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: CustomColors.mfinGrey,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate('new_requester'),
        ),
        backgroundColor: CustomColors.mfinBlue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: CustomColors.mfinBlue,
        onPressed: () async {
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
        child: Container(
          color: CustomColors.mfinWhite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ListTile(
                leading: SizedBox(
                  width: 80,
                  child: Text(
                    AppLocalizations.of(context).translate('customer_colon'),
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: "Georgia",
                      fontWeight: FontWeight.bold,
                      color: CustomColors.mfinBlue,
                    ),
                  ),
                ),
                title: DropdownButton<int>(
                  dropdownColor: CustomColors.mfinLightGrey,
                  isExpanded: true,
                  items: customers.map(
                    (f) {
                      return DropdownMenuItem<int>(
                        value: f,
                        child: Text(f.toString()),
                      );
                    },
                  ).toList(),
                  onChanged: (newVal) {
                    setState(() {
                      selectedCust = newVal;
                    });
                  },
                  value: selectedCust,
                ),
              ),
              ListTile(
                leading: SizedBox(
                  width: 80,
                  child: Text(
                    AppLocalizations.of(context).translate('chit_colon'),
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: "Georgia",
                      fontWeight: FontWeight.bold,
                      color: CustomColors.mfinBlue,
                    ),
                  ),
                ),
                title: DropdownButton<int>(
                  dropdownColor: CustomColors.mfinLightGrey,
                  isExpanded: true,
                  items: chitNumbers.map(
                    (f) {
                      return DropdownMenuItem<int>(
                        value: f,
                        child: Text(f.toString()),
                      );
                    },
                  ).toList(),
                  onChanged: (newVal) {
                    setState(() {
                      chitNumber = newVal;
                    });
                  },
                  value: chitNumber,
                ),
              ),
              ListTile(
                leading: SizedBox(
                  width: 80,
                  child: Text(
                    AppLocalizations.of(context)
                        .translate('requested_at_colon'),
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: "Georgia",
                      fontWeight: FontWeight.bold,
                      color: CustomColors.mfinBlue,
                    ),
                  ),
                ),
                title: GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _date,
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: CustomColors.mfinBlue,
                        ),
                        fillColor: CustomColors.mfinLightGrey,
                        filled: true,
                        suffixIcon: Icon(
                          Icons.date_range,
                          color: CustomColors.mfinBlue,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: SizedBox(
                  width: 80,
                  child: Text(
                    AppLocalizations.of(context).translate('notes_colon'),
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: "Georgia",
                      fontWeight: FontWeight.bold,
                      color: CustomColors.mfinBlue,
                    ),
                  ),
                ),
                title: new TextFormField(
                  keyboardType: TextInputType.text,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context).translate('short_notes'),
                    labelStyle: TextStyle(
                      color: CustomColors.mfinBlue,
                    ),
                    fillColor: CustomColors.mfinLightGrey,
                    filled: true,
                  ),
                  validator: (note) {
                    if (note.trim().isEmpty) {
                      this.notes = "";
                    } else {
                      this.notes = note.trim();
                    }

                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate)
      setState(
        () {
          selectedDate = picked;
          _date.text = DateUtils.formatDate(picked);
        },
      );
  }

  _submit() async {
    final FormState form = _formKey.currentState;

    if (form.validate()) {
      CustomDialogs.actionWaiting(context, "Adding Requester!");
      ChitRequesters _cr = ChitRequesters();
      _cr.chitNumber = chitNumber;
      _cr.requestedAt = DateUtils.getUTCDateEpoch(selectedDate);
      _cr.custNumber = selectedCust;
      _cr.notes = notes;
      _cr.isAllocated = false;
      var result = await ChitController().addRequester(
          widget.chit.financeID,
          widget.chit.branchName,
          widget.chit.subBranchName,
          widget.chit.chitID,
          _cr);
      if (!result['is_success']) {
        Navigator.pop(context);
        _scaffoldKey.currentState
            .showSnackBar(CustomSnackBar.errorSnackBar(result['message'], 5));
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
      }
    } else {
      _scaffoldKey.currentState.showSnackBar(
          CustomSnackBar.errorSnackBar("Please fill required fields!", 2));
    }
  }
}
