import 'package:flutter/material.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/db/models/payment_template.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/transaction/paymentTemp_controller.dart';
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

  String _selectedTempID = "0";
  String selectedCollectionModeID = "0";
  String selectedCollectionDayID = "0";
  Map<String, String> _tempMap = {"0": "Choose Type.."};
  Map<String, String> _tempCollectionMode = {
    "0": "Daily",
    "1": "Weekly",
    "2": "Monthly"
  };
  Map<String, String> _tempCollectionDays = {
    "0": "Sunday",
    "1": "Monday",
    "2": "Tuesday",
    "3": "Wednesday",
    "4": "Thursday",
    "5": "Friday",
    "6": "Saturday",
  };
  List<PaymentTemplate> templates = new List<PaymentTemplate>();
  List<PaymentTemplate> tempList;
  PaymentTemplate selectedTemp;

  TextEditingController _date = new TextEditingController();
  TextEditingController _collectionDate = new TextEditingController();

  Map<String, dynamic> updatedPayment = new Map();

  @override
  void initState() {
    super.initState();
    this.getCollectionTemp();

    selectedCollectionDayID = widget.payment.collectionDay.toString();
    selectedCollectionModeID = widget.payment.collectionMode.toString();

    _date.value = TextEditingValue(
      text: DateUtils.getFormattedDateFromEpoch(widget.payment.dateOfPayment),
    );

    _collectionDate.value = TextEditingValue(
        text: DateUtils.getFormattedDateFromEpoch(
            widget.payment.collectionStartsFrom));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: CustomColors.mfinGrey,
      appBar: AppBar(
        title: Text('Edit Payment'),
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
                color: CustomColors.mfinLightGrey,
                elevation: 5.0,
                margin: EdgeInsets.only(top: 5.0),
                shadowColor: CustomColors.mfinLightBlue,
                child: new Column(
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
                      color: CustomColors.mfinBlue,
                    ),
                    ListTile(
                      leading: SizedBox(
                        width: 100,
                        child: Text(
                          "DATE:",
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
                              hintText: 'Date of Payment',
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
                    ListTile(
                      leading: SizedBox(
                        width: 100,
                        child: Text(
                          "GIVEN BY:",
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Georgia",
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinBlue,
                          ),
                        ),
                      ),
                      title: TextFormField(
                        textAlign: TextAlign.end,
                        keyboardType: TextInputType.text,
                        initialValue: widget.payment.givenBy,
                        decoration: InputDecoration(
                          hintText: 'Amount Given by',
                          fillColor: CustomColors.mfinWhite,
                          filled: true,
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 3.0),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: CustomColors.mfinWhite)),
                        ),
                        validator: (givenby) {
                          if (givenby.trim().isEmpty) {
                            return "Please fill the person name who gave the amount";
                          } else if (givenby.trim() != widget.payment.givenBy) {
                            updatedPayment['given_by'] = givenby.trim();
                          }

                          return null;
                        },
                      ),
                    ),
                    ListTile(
                      leading: SizedBox(
                        width: 100,
                        child: Text(
                          "NOTES:",
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Georgia",
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinBlue,
                          ),
                        ),
                      ),
                      title: TextFormField(
                        textAlign: TextAlign.end,
                        keyboardType: TextInputType.text,
                        initialValue: widget.payment.notes,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Notes',
                          fillColor: CustomColors.mfinWhite,
                          filled: true,
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 3.0),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: CustomColors.mfinWhite)),
                        ),
                        validator: (notes) {
                          if (notes.trim() != widget.payment.notes) {
                            updatedPayment['notes'] = notes.trim();
                          }
                          return null;
                        },
                      ),
                    ),
                    ListTile(
                      leading: SizedBox(
                        width: 100,
                        child: Text(
                          "TYPE:",
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Georgia",
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinBlue,
                          ),
                        ),
                      ),
                      title: DropdownButton<String>(
                        dropdownColor: CustomColors.mfinWhite,
                        isExpanded: true,
                        items: _tempMap.entries.map(
                          (f) {
                            return DropdownMenuItem<String>(
                              value: f.key,
                              child: Text(f.value),
                            );
                          },
                        ).toList(),
                        onChanged: (newVal) {
                          _setSelectedTemp(newVal);
                        },
                        value: _selectedTempID,
                      ),
                    ),
                    ListTile(
                      leading: SizedBox(
                        width: 100,
                        child: Text(
                          "MODE:",
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Georgia",
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinBlue,
                          ),
                        ),
                      ),
                      title: DropdownButton<String>(
                        dropdownColor: CustomColors.mfinWhite,
                        isExpanded: true,
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
                    int.parse(selectedCollectionModeID) == 0
                        ? ListTile(
                            leading: SizedBox(
                              width: 100,
                              child: Text(
                                "COLLECTION DATE:",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: "Georgia",
                                  fontWeight: FontWeight.bold,
                                  color: CustomColors.mfinBlue,
                                ),
                              ),
                            ),
                            title: GestureDetector(
                              onTap: () => _selectCollectionDate(context),
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: _collectionDate,
                                  keyboardType: TextInputType.datetime,
                                  decoration: InputDecoration(
                                    hintText: 'Date of Collection',
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
                          )
                        : Container(),
                    int.parse(selectedCollectionModeID) == 1
                        ? Column(
                            children: <Widget>[
                              ListTile(
                                leading: SizedBox(
                                  width: 100,
                                  child: Text(
                                    "COLLECTION DATE:",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: "Georgia",
                                      fontWeight: FontWeight.bold,
                                      color: CustomColors.mfinBlue,
                                    ),
                                  ),
                                ),
                                title: GestureDetector(
                                  onTap: () => _selectCollectionDate(context),
                                  child: AbsorbPointer(
                                    child: TextFormField(
                                      controller: _collectionDate,
                                      keyboardType: TextInputType.datetime,
                                      decoration: InputDecoration(
                                        hintText: 'Date of Collection',
                                        labelStyle: TextStyle(
                                          color: CustomColors.mfinBlue,
                                        ),
                                        contentPadding:
                                            new EdgeInsets.symmetric(
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
                              ListTile(
                                leading: SizedBox(
                                  width: 100,
                                  child: Text(
                                    "DAY:",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: "Georgia",
                                      fontWeight: FontWeight.bold,
                                      color: CustomColors.mfinBlue,
                                    ),
                                  ),
                                ),
                                title: DropdownButton<String>(
                                  dropdownColor: CustomColors.mfinWhite,
                                  isExpanded: true,
                                  items: _tempCollectionDays.entries.map(
                                    (f) {
                                      return DropdownMenuItem<String>(
                                        value: f.key,
                                        child: Text(f.value),
                                      );
                                    },
                                  ).toList(),
                                  onChanged: (newVal) {
                                    _setSelectedCollectionDay(newVal);
                                  },
                                  value: selectedCollectionDayID,
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    int.parse(selectedCollectionModeID) == 2
                        ? ListTile(
                            leading: SizedBox(
                              width: 100,
                              child: Text(
                                "COLLECTION DATE:",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: "Georgia",
                                  fontWeight: FontWeight.bold,
                                  color: CustomColors.mfinBlue,
                                ),
                              ),
                            ),
                            title: GestureDetector(
                              onTap: () => _selectCollectionDate(context),
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: _collectionDate,
                                  keyboardType: TextInputType.datetime,
                                  decoration: InputDecoration(
                                    hintText: 'Date of Collection',
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
                          )
                        : Container(),
                  ],
                ),
              ),
              new Card(
                shadowColor: CustomColors.mfinAlertRed,
                color: CustomColors.mfinLightGrey,
                elevation: 15.0,
                margin: EdgeInsets.only(top: 5.0),
                child: new Column(
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
                      color: CustomColors.mfinBlue,
                    ),
                    ListTile(
                      leading: SizedBox(
                        width: 100,
                        child: Text(
                          "TOTAL AMOUNT:",
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Georgia",
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinBlue,
                          ),
                        ),
                      ),
                      title: new TextFormField(
                        // controller: _tAmountController,
                        textAlign: TextAlign.end,
                        keyboardType: TextInputType.number,
                        initialValue: widget.payment.totalAmount.toString(),
                        decoration: InputDecoration(
                          hintText: 'Total Amount',
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
                    ListTile(
                      leading: SizedBox(
                        width: 100,
                        child: Text(
                          "PRINCIPAL:",
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Georgia",
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinBlue,
                          ),
                        ),
                      ),
                      title: new TextFormField(
                        textAlign: TextAlign.end,
                        keyboardType: TextInputType.number,
                        initialValue: widget.payment.principalAmount.toString(),
                        decoration: InputDecoration(
                          hintText: 'Principal amount given',
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
                    ListTile(
                      leading: SizedBox(
                        width: 100,
                        child: Text(
                          "DOC CHARGE:",
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Georgia",
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinBlue,
                          ),
                        ),
                      ),
                      title: TextFormField(
                        textAlign: TextAlign.end,
                        initialValue: widget.payment.docCharge.toString(),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Document Charge',
                          fillColor: CustomColors.mfinWhite,
                          filled: true,
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 3.0),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: CustomColors.mfinWhite)),
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
                    ListTile(
                      leading: SizedBox(
                        width: 100,
                        child: Text(
                          "SUR CHARGE:",
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Georgia",
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinBlue,
                          ),
                        ),
                      ),
                      title: TextFormField(
                        textAlign: TextAlign.end,
                        initialValue: widget.payment.surcharge.toString(),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Service charge if any',
                          fillColor: CustomColors.mfinWhite,
                          filled: true,
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 3.0),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: CustomColors.mfinWhite)),
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
                    ListTile(
                      leading: SizedBox(
                        width: 100,
                        child: Text(
                          "TENURE:",
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Georgia",
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinBlue,
                          ),
                        ),
                      ),
                      title: TextFormField(
                        textAlign: TextAlign.end,
                        keyboardType: TextInputType.number,
                        initialValue: widget.payment.tenure.toString(),
                        decoration: InputDecoration(
                          hintText: 'Number of Collections',
                          fillColor: CustomColors.mfinWhite,
                          filled: true,
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 3.0),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: CustomColors.mfinWhite)),
                        ),
                        validator: (tenure) {
                          if (tenure.trim().isEmpty) {
                            return 'Enter the Number of Collections';
                          } else if (tenure.trim() !=
                              widget.payment.tenure.toString()) {
                            updatedPayment['tenure'] = int.parse(tenure.trim());
                          }
                          return null;
                        },
                      ),
                    ),
                    ListTile(
                      leading: SizedBox(
                        width: 100,
                        child: Text(
                          "INTEREST:",
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Georgia",
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinBlue,
                          ),
                        ),
                      ),
                      title: TextFormField(
                        textAlign: TextAlign.end,
                        keyboardType: TextInputType.number,
                        initialValue: widget.payment.interestRate.toString(),
                        decoration: InputDecoration(
                          hintText: 'Rate in 0.00%',
                          fillColor: CustomColors.mfinWhite,
                          filled: true,
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 3.0),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: CustomColors.mfinWhite)),
                        ),
                        validator: (iRate) {
                          if (iRate.trim() !=
                              widget.payment.interestRate.toString()) {
                            if (iRate.trim().isEmpty) {
                              updatedPayment['interest_rate'] =
                                  double.parse('0');
                            } else {
                              updatedPayment['interest_rate'] =
                                  double.parse(iRate.trim());
                            }
                          }

                          return null;
                        },
                      ),
                    ),
                    ListTile(
                      leading: SizedBox(
                        width: 100,
                        child: Text(
                          "COLLECTION AMOUNT:",
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Georgia",
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinBlue,
                          ),
                        ),
                      ),
                      title: TextFormField(
                        textAlign: TextAlign.end,
                        keyboardType: TextInputType.number,
                        initialValue:
                            widget.payment.collectionAmount.toString(),
                        decoration: InputDecoration(
                          hintText: 'Each Collection Amount',
                          fillColor: CustomColors.mfinWhite,
                          filled: true,
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 3.0),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: CustomColors.mfinWhite)),
                        ),
                        validator: (collAmount) {
                          if (collAmount.trim().isEmpty ||
                              collAmount.trim() == '0') {
                            return "Collection amount should not be empty pr Zero";
                          } else if (collAmount.trim() !=
                              widget.payment.collectionAmount.toString()) {
                            updatedPayment['collection_amount'] =
                                int.parse(collAmount.trim());
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
      ),
    );
  }

  _setSelectedCollectionMode(String newVal) {
    setState(() {
      updatedPayment['collection_mode'] = int.parse(newVal);
      selectedCollectionModeID = newVal;
    });
  }

  _setSelectedTemp(String newVal) {
    if (tempList != null && newVal != "0") {
      selectedTemp = tempList[int.parse(newVal) - 1];
    }

    setState(() {
      _selectedTempID = newVal;
    });
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
      print("Unable to load Payment templates for Payment EDIT!");
    }
  }

  void _setSelectedCollectionDay(String newVal) {
    setState(() {
      updatedPayment['collection_day'] = int.parse(newVal);
      selectedCollectionDayID = newVal;
    });
  }

  Future<Null> _selectCollectionDate(BuildContext context) async {
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
          _collectionDate.value = TextEditingValue(
            text: DateUtils.formatDate(picked),
          );
        },
      );
  }

  Future<Null> _selectDate(BuildContext context) async {
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
          _date.value = TextEditingValue(
            text: DateUtils.formatDate(picked),
          );
        },
      );
  }

  _submit() async {
    final FormState form = _formKey.currentState;

    if (form.validate()) {
      if (updatedPayment.length == 0) {
        _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
            "No changes detected, Skipping update!", 1));
        Navigator.pop(context);
      } else {
        CustomDialogs.actionWaiting(context, " Editing Payment");
        PaymentController _pc = PaymentController();
        var result = await _pc.updatePayment(widget.payment, updatedPayment);

        if (!result['is_success']) {
          Navigator.pop(context);
          _scaffoldKey.currentState
              .showSnackBar(CustomSnackBar.errorSnackBar(result['message'], 5));
          print("Unable to Edit Payment: " + result['message']);
        } else {
          Navigator.pop(context);
          print("Payment edited successfully");
          Navigator.pop(context);
        }
      }
    } else {
      print("Invalid form submitted");
      _scaffoldKey.currentState.showSnackBar(
          CustomSnackBar.errorSnackBar("Please fill required fields!", 2));
    }
  }
}
