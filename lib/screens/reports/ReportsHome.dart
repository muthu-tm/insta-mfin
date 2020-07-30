import 'package:flutter/material.dart';
import 'package:instamfin/db/models/collection.dart';
import 'package:instamfin/db/models/customer.dart';
import 'package:instamfin/db/models/expense.dart';
import 'package:instamfin/db/models/journal.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/app/appBar.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/app/sideDrawer.dart';
import 'package:instamfin/screens/home/UserFinanceSetup.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/transaction/Journal_controller.dart';
import 'package:instamfin/services/controllers/transaction/expense_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:instamfin/services/pdf/reports/coll_report.dart';
import 'package:instamfin/services/pdf/reports/customer_report.dart';
import 'package:instamfin/services/pdf/reports/expense_report.dart';
import 'package:instamfin/services/pdf/reports/journal_report.dart';
import 'package:instamfin/services/pdf/reports/payment_report.dart';

class ReportsHome extends StatefulWidget {
  @override
  _ReportsHomeState createState() => _ReportsHomeState();
}

class _ReportsHomeState extends State<ReportsHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final User _user = UserController().getCurrentUser();

  String _selectedCategory = "0";
  Map<String, String> _categoriesMap = {
    "0": "Customer",
    "1": "Payment",
    "2": "Collection",
    "3": "Journal",
    "4": "Expense"
  };

  String _selectedType = "0";
  Map<String, String> _typesMap = {"0": "All"};
  Map<String, String> _typesTempMap = new Map();
  String _selectedRange = "0";
  Map<String, String> _rangeMap = {
    "0": "Today",
    "1": "This Week",
    "2": "This Month",
    "3": "Custom"
  };
  String _selectedFormat = "0";
  Map<String, String> _formatsMap = {"0": ".pdf", "1": ".xlsx"};

  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  TextEditingController _toDate = new TextEditingController();
  TextEditingController _fromDate = new TextEditingController();

  @override
  void initState() {
    super.initState();
    this._setTypesMap(_selectedType);
    _typesMap = _typesTempMap;

    _fromDate.text = DateUtils.formatDate(DateTime.now());
    _toDate.text = DateUtils.formatDate(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await UserController().refreshUser(false);
        return Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) => UserFinanceSetup(),
          ),
          (Route<dynamic> route) => false,
        );
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: openDrawer(context),
        appBar: topAppBar(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: CustomColors.mfinBlue,
          onPressed: () async {
            _submit();
          },
          label: Text(
            "GET REPORT",
            style: TextStyle(
              fontSize: 17,
              fontFamily: "Georgia",
              fontWeight: FontWeight.bold,
            ),
          ),
          splashColor: CustomColors.mfinWhite,
          icon: Icon(
            Icons.file_download,
            size: 35,
            color: CustomColors.mfinFadedButtonGreen,
          ),
        ),
        body: new Container(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ListTile(
                leading: SizedBox(
                  width: 85,
                  child: Text(
                    "CATEGORY:",
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: "Georgia",
                      fontWeight: FontWeight.bold,
                      color: CustomColors.mfinBlue,
                    ),
                  ),
                ),
                title: DropdownButton<String>(
                  dropdownColor: CustomColors.mfinLightGrey,
                  isExpanded: true,
                  items: _categoriesMap.entries.map(
                    (f) {
                      return DropdownMenuItem<String>(
                        value: f.key,
                        child: Text(f.value),
                      );
                    },
                  ).toList(),
                  onChanged: (newVal) {
                    _setTypesMap(newVal);

                    setState(() {
                      _typesMap = _typesTempMap;
                      _selectedCategory = newVal;
                    });
                  },
                  value: _selectedCategory,
                ),
              ),
              ListTile(
                leading: SizedBox(
                  width: 85,
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
                  dropdownColor: CustomColors.mfinLightGrey,
                  isExpanded: true,
                  items: _typesMap.entries.map(
                    (f) {
                      return DropdownMenuItem<String>(
                        value: f.key,
                        child: Text(f.value),
                      );
                    },
                  ).toList(),
                  onChanged: (newVal) {
                    setState(() {
                      _selectedType = newVal;
                    });
                  },
                  value: _selectedType,
                ),
              ),
              ListTile(
                leading: SizedBox(
                  width: 85,
                  child: Text(
                    "RANGE:",
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: "Georgia",
                      fontWeight: FontWeight.bold,
                      color: CustomColors.mfinBlue,
                    ),
                  ),
                ),
                title: DropdownButton<String>(
                  dropdownColor: CustomColors.mfinLightGrey,
                  isExpanded: true,
                  items: _rangeMap.entries.map(
                    (f) {
                      return DropdownMenuItem<String>(
                        value: f.key,
                        child: Text(f.value),
                      );
                    },
                  ).toList(),
                  onChanged: (newVal) {
                    if (newVal == '0') {
                      fromDate = DateTime.now();
                      toDate = DateTime.now();
                    } else if (newVal == '1') {
                      DateTime today = DateTime.now();
                      fromDate = today.subtract(Duration(days: today.weekday));
                      toDate = DateTime.now();
                    } else if (newVal == '2') {
                      DateTime today = DateTime.now();
                      fromDate =
                          DateTime(today.year, today.month, 1, 0, 0, 0, 0, 0);
                      toDate = DateTime.now();
                    }

                    setState(() {
                      _fromDate.text = DateUtils.formatDate(fromDate);
                      _toDate.text = DateUtils.formatDate(toDate);
                      _selectedRange = newVal;
                    });
                  },
                  value: _selectedRange,
                ),
              ),
              ListTile(
                leading: SizedBox(
                  width: 85,
                  child: Text(
                    "FROM:",
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: "Georgia",
                      fontWeight: FontWeight.bold,
                      color: CustomColors.mfinBlue,
                    ),
                  ),
                ),
                title: GestureDetector(
                  onTap: () => {
                    _selectedRange == '3'
                        ? _selectFromDate(context)
                        : print('Not in custom Range!'),
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      readOnly: _selectedRange == '3' ? false : true,
                      controller: _fromDate,
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        hintText: 'Reports From',
                        labelStyle: TextStyle(
                          color: CustomColors.mfinBlue,
                        ),
                        fillColor: _selectedRange == '3'
                            ? CustomColors.mfinWhite
                            : CustomColors.mfinLightGrey,
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
                  width: 85,
                  child: Text(
                    "To:",
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: "Georgia",
                      fontWeight: FontWeight.bold,
                      color: CustomColors.mfinBlue,
                    ),
                  ),
                ),
                title: GestureDetector(
                  onTap: () => {
                    _selectedRange == '3'
                        ? _selectToDate(context)
                        : print('Not in custom Range!'),
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _toDate,
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        hintText: 'Reports till',
                        labelStyle: TextStyle(
                          color: CustomColors.mfinBlue,
                        ),
                        fillColor: _selectedRange == '3'
                            ? CustomColors.mfinWhite
                            : CustomColors.mfinLightGrey,
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
                  width: 85,
                  child: Text(
                    "FORMAT:",
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: "Georgia",
                      fontWeight: FontWeight.bold,
                      color: CustomColors.mfinBlue,
                    ),
                  ),
                ),
                title: DropdownButton<String>(
                  dropdownColor: CustomColors.mfinLightGrey,
                  isExpanded: true,
                  items: _formatsMap.entries.map(
                    (f) {
                      return DropdownMenuItem<String>(
                        value: f.key,
                        child: Text(f.value),
                      );
                    },
                  ).toList(),
                  onChanged: (newVal) {
                    setState(() {
                      _selectedFormat = newVal;
                    });
                  },
                  value: _selectedFormat,
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: bottomBar(context),
      ),
    );
  }

  _setTypesMap(String cVal) {
    List<String> types = [];

    if (cVal == '0') {
      types.add('All');
      types.add('New');
      types.add('Active');
      types.add('Pending');
      types.add('Settled');
    } else if (cVal == '1') {
      types.add('All');
      types.add('Active');
      types.add('Settled');
    } else if (cVal == '2') {
      types.add('All');
      types.add('Collection');
      types.add('Doc Charge');
      types.add('Surcharge');
      types.add('Settlement');
      types.add('Penalty');
      types.add('Referral Commission');
    } else {
      types.add('All');
    }

    _typesTempMap.clear();
    for (int index = 0; index < types.length; index++) {
      _typesTempMap[index.toString()] = types[index];
    }
  }

  Future<Null> _selectFromDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: fromDate,
      firstDate: DateTime(1990),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );
    if (picked != null && fromDate != picked)
      setState(
        () {
          fromDate = picked;
          _fromDate.text = DateUtils.formatDate(picked);
        },
      );
  }

  Future<Null> _selectToDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: toDate,
      firstDate: DateTime(1990),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );
    if (picked != null && toDate != picked)
      setState(
        () {
          toDate = picked;
          _toDate.text = DateUtils.formatDate(picked);
        },
      );
  }

  _submit() async {
    CustomDialogs.actionWaiting(context, "Fetching Report!");
    if (_selectedCategory == '0') {
      List<Customer> customers;
      bool isRange = false;

      if (_selectedRange == '0') {
        // Todays Customer Report
        customers =
            await Customer().getAllByDate(DateUtils.getUTCDateEpoch(fromDate));
      } else {
        isRange = true;
        // Customer Report by Date Range
        customers = await Customer().getAllByDateRange(
            DateUtils.getUTCDateEpoch(fromDate),
            DateUtils.getUTCDateEpoch(toDate));
      }

      Navigator.pop(context);
      if (customers.length > 0) {
        _scaffoldKey.currentState.showSnackBar(CustomSnackBar.successSnackBar(
            "Generating your Customers Report! It may take upto 10-30 seconds, Please wait...", 5));
        await CustomerReport()
            .generateReport(_user, customers, isRange, fromDate, toDate);
      } else {
        _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
            "No Customers data found. Please try different criteria!", 2));
      }
    } else if (_selectedCategory == '1') {
      List<Payment> pays;
      bool isRange = false;

      if (_selectedRange == '0') {
        // Todays Payment Report
        if (_selectedType == '0') {
          // pays = await Payment().getAllPayments();
          pays = await Payment()
              .getAllPaymentsByDate(DateUtils.getUTCDateEpoch(fromDate));
        } else {
          pays = await Payment().getAllByDateStatus(
              DateUtils.getUTCDateEpoch(fromDate),
              _selectedType == '1' ? false : true);
        }
      } else {
        // Payment Report by Date Range
        isRange = true;
        if (_selectedType == '0') {
          pays = await Payment().getAllPaymentsByDateRange(
              DateUtils.getUTCDateEpoch(fromDate),
              DateUtils.getUTCDateEpoch(toDate));
        } else {
          pays = await Payment().getAllByDateRangeStatus(
              DateUtils.getUTCDateEpoch(fromDate),
              DateUtils.getUTCDateEpoch(toDate),
              _selectedType == '1' ? false : true);
        }
      }

      Navigator.pop(context);
      if (pays.length > 0) {
        _scaffoldKey.currentState.showSnackBar(CustomSnackBar.successSnackBar(
            "Generating your Payment Report! It may take upto 10-30 seconds, Please wait...", 5));
        await PaymentReport()
            .generateReport(_user, pays, isRange, fromDate, toDate);
      } else {
        _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
            "No Payments data found. Please try different criteria!", 2));
      }
    } else if (_selectedCategory == '2') {
      List<Collection> colls;
      bool isRange = false;

      if (_selectedRange == '0') {
        // Todays Collection Report
        colls = await Collection().allCollectionByDate(
            _user.primary.financeID,
            _user.primary.branchName,
            _user.primary.subBranchName,
            _selectedType == '0'
                ? [0, 1, 2, 3, 4, 5]
                : [int.parse(_selectedType) - 1],
            DateUtils.getUTCDateEpoch(fromDate));
      } else {
        isRange = true;
        // Collection Report by Date Range
        colls = await Collection().getAllCollectionsByDateRange(
            _user.primary.financeID,
            _user.primary.branchName,
            _user.primary.subBranchName,
            _selectedType == '0'
                ? [0, 1, 2, 3, 4, 5]
                : [int.parse(_selectedType) - 1],
            DateUtils.getUTCDateEpoch(fromDate),
            DateUtils.getUTCDateEpoch(toDate));
      }
      Navigator.pop(context);
      if (colls.length > 0) {
        _scaffoldKey.currentState.showSnackBar(CustomSnackBar.successSnackBar(
            "Generating your Colleciton Report! Please wait...", 2));
        await CollectionReport()
            .generateReport(_user, colls, isRange, fromDate, toDate);
      } else {
        _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
            "No Collection data found. Please try different criteria!", 2));
      }
    } else if (_selectedCategory == '3') {
      JournalController _jc = JournalController();
      List<Journal> journals;
      bool isRange = false;

      if (_selectedRange == '0') {
        // Todays Journal Report
        journals = await _jc.getJournalByDate(_user.primary.financeID,
            _user.primary.branchName, _user.primary.subBranchName, fromDate);
      } else {
        isRange = true;
        // Journal Report by Date Range
        journals = await _jc.getAllJournalByDateRange(
            _user.primary.financeID,
            _user.primary.branchName,
            _user.primary.subBranchName,
            fromDate,
            toDate);
      }
      Navigator.pop(context);
      if (journals.length > 0) {
        _scaffoldKey.currentState.showSnackBar(CustomSnackBar.successSnackBar(
            "Generating your Journal Report! Please wait...", 2));
        await JournalReport()
            .generateReport(_user, journals, isRange, fromDate, toDate);
      } else {
        _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
            "No Journal data found. Please try different criteria!", 2));
      }
    } else if (_selectedCategory == '4') {
      ExpenseController _ec = ExpenseController();
      List<Expense> expenses;
      bool isRange = false;

      if (_selectedRange == '0') {
        // Todays Expense Report
        expenses = await _ec.getExpenseByDate(_user.primary.financeID,
            _user.primary.branchName, _user.primary.subBranchName, fromDate);
      } else {
        isRange = true;
        // Expense Report by Date Range
        expenses = await _ec.getAllExpenseByDateRange(
            _user.primary.financeID,
            _user.primary.branchName,
            _user.primary.subBranchName,
            fromDate,
            toDate);
      }

      Navigator.pop(context);
      if (expenses.length > 0) {
        _scaffoldKey.currentState.showSnackBar(CustomSnackBar.successSnackBar(
            "Generating your Expense Report! Please wait...", 2));
        await ExpenseReport()
            .generateReport(_user, expenses, isRange, fromDate, toDate);
      } else {
        _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
            "No Expense data found. Please try different criteria!", 2));
      }
    }
  }
}
