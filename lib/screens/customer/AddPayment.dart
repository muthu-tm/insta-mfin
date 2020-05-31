import 'package:flutter/material.dart';
import 'package:instamfin/db/enums/payment_status.dart';
import 'package:instamfin/db/enums/tenure_type.dart';
import 'package:instamfin/db/models/payment_template.dart';
import 'package:instamfin/db/models/customer.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/transaction/paymentTemp_controller.dart';
import 'package:instamfin/services/controllers/transaction/payment_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class AddPayment extends StatefulWidget {
  AddPayment(this.customer);

  final Customer customer;

  @override
  _AddPaymentState createState() => _AddPaymentState();
}

class _AddPaymentState extends State<AddPayment> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final User _user = UserController().getCurrentUser();

  String _selectedTempID = "0";
  String _selectedCollectionModeID = "1";
  String _selectedCollectionDayID = "1";
  Map<String, String> _tempMap = {"0": "Choose Type.."};
  Map<String, String> _tempCollectionMode = {
    "1": "Daily",
    "2": "Weekly",
    "3": "Monthly"
  };
  Map<String, String> _tempCollectionDays = {
    "1": "Sunday",
    "2": "Monday",
    "3": "Tuesday",
    "4": "Wednesday",
    "5": "Thursday",
    "6": "Friday",
    "7": "Saturday",
  };
  List<PaymentTemplate> templates = new List<PaymentTemplate>();
  List<PaymentTemplate> tempList;
  PaymentTemplate selectedTemp;

  TextEditingController _date = new TextEditingController();
  TextEditingController _collectionDate = new TextEditingController();

  DateTime selectedDate = DateTime.now();
  DateTime collectionDate = DateTime.now().add(Duration(days: 1));
  int totalAmount = 0;
  int principalAmount = 0;
  int docCharge = 0;
  int surCharge = 0;
  int tenure = 0;
  double intrestRate = 0.0;
  int collectionAmount = 0;
  String givenTo = '';
  String givenBy = '';
  String notes = '';

  @override
  void initState() {
    super.initState();
    this.getCollectionTemp();
    givenTo = widget.customer.name;
    givenBy = _user.name;

    _tAmountController.addListener(_tAmountListener);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: CustomColors.mfinGrey,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Add Payment'),
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
                          "CUSTOMER:",
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Georgia",
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinBlue,
                          ),
                        ),
                      ),
                      title: TextFormField(
                        enabled: false,
                        autofocus: false,
                        initialValue: widget.customer.name,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            color: CustomColors.mfinBlue,
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
                          "GIVEN TO:",
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
                        initialValue: givenTo,
                        decoration: InputDecoration(
                          hintText: 'Amount Given To',
                          fillColor: CustomColors.mfinWhite,
                          filled: true,
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 3.0),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: CustomColors.mfinWhite)),
                        ),
                        validator: (givenTo) {
                          if (givenTo.trim().isEmpty) {
                            return "Fill the person name who received the amount";
                          }

                          this.givenTo = givenTo.trim();
                          return null;
                        },
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
                        initialValue: givenBy,
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
                          }

                          this.givenBy = givenby.trim();
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
                        initialValue: notes,
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
                          if (notes.trim().isEmpty) {
                            this.notes = "";
                          } else {
                            this.notes = notes.trim();
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
                        value: _selectedCollectionModeID,
                      ),
                    ),
                    int.parse(_selectedCollectionModeID) == 1
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
                    int.parse(_selectedCollectionModeID) == 2
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
                                  value: _selectedCollectionDayID,
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    int.parse(_selectedCollectionModeID) == 3
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
                        initialValue: totalAmount.toString(),
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
                          } else {
                            this.totalAmount = int.parse(amount.trim());
                            return null;
                          }
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
                        initialValue: principalAmount.toString(),
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
                          } else {
                            this.principalAmount = int.parse(amount.trim());
                            return null;
                          }
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
                        initialValue: docCharge.toString(),
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
                          if (charge.trim().isEmpty) {
                            this.docCharge = 0;
                          } else {
                            this.docCharge = int.parse(charge);
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
                        initialValue: surCharge.toString(),
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
                        validator: (surcharge) {
                          if (surcharge.trim().isEmpty) {
                            this.surCharge = 0;
                          } else {
                            this.surCharge = int.parse(surcharge);
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
                        initialValue: tenure.toString(),
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
                          }

                          this.tenure = int.parse(tenure);
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
                        initialValue: intrestRate.toString(),
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
                        validator: (tenure) {
                          if (tenure.trim().isEmpty) {
                            this.intrestRate = double.parse('0');
                          } else {
                            this.intrestRate = double.parse(tenure);
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
                        initialValue: collectionAmount.toString(),
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
                          }

                          this.collectionAmount = int.parse(collAmount.trim());
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

  final _tAmountController = TextEditingController();
  void _tAmountListener() {
    setState(() {
      _tAmountController.text = this.totalAmount.toString();
    });
  }

  _setSelectedTemp(String newVal) {
    if (tempList != null && newVal != "0") {
      selectedTemp = tempList[int.parse(newVal) - 1];

      this.totalAmount = selectedTemp.totalAmount;
      this.principalAmount = selectedTemp.principalAmount;
      this.docCharge = selectedTemp.docCharge;
      this.surCharge = selectedTemp.surcharge;
      this.tenure = selectedTemp.tenure;
      this.intrestRate = selectedTemp.interestRate;
      this.collectionAmount = selectedTemp.collectionAmount;
    }

    setState(() {
      _selectedTempID = newVal;
    });
  }

  _setSelectedCollectionMode(String newVal) {
    setState(() {
      _selectedCollectionModeID = newVal;
    });
  }

  _setSelectedCollectionDay(String newVal) {
    setState(() {
      _selectedCollectionDayID = newVal;
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
      print("Unable to load Payment templates for Payment ADD!");
    }
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
          _date.value = TextEditingValue(
            text: DateUtils.formatDate(picked),
          );
        },
      );
  }

  Future<Null> _selectCollectionDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: collectionDate,
      firstDate: DateTime.now().add(Duration(days: 1)),
      lastDate: DateTime.now().add(Duration(days: 365 * 5)),
    );
    if (picked != null && picked != collectionDate)
      setState(
        () {
          collectionDate = picked;
          _collectionDate.value = TextEditingValue(
            text: DateUtils.formatDate(picked),
          );
        },
      );
  }

  _submit() async {
    final FormState form = _formKey.currentState;

    if (form.validate()) {
      CustomDialogs.actionWaiting(context, " Adding Payment");
      PaymentController _pc = PaymentController();
      var result = await _pc.createPayment(
          widget.customer.mobileNumber,
          selectedDate,
          totalAmount,
          principalAmount,
          tenure,
          collectionAmount,
          TenureType.Daily.name,
          docCharge,
          surCharge,
          intrestRate,
          givenTo,
          givenBy,
          PaymentStatus.Active.name,
          notes);

      if (!result['is_success']) {
        Navigator.pop(context);
        _scaffoldKey.currentState
            .showSnackBar(CustomSnackBar.errorSnackBar(result['message'], 5));
        print("Unable to Create Payment: " + result['message']);
      } else {
        Navigator.pop(context);
        print("New Payment added successfully for ${widget.customer.name}");
        Navigator.pop(context);
      }
    } else {
      print("Invalid form submitted");
      _scaffoldKey.currentState.showSnackBar(
          CustomSnackBar.errorSnackBar("Please fill required fields!", 2));
    }
  }
}
