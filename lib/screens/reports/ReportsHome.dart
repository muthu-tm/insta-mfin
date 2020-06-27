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
import 'package:instamfin/screens/home/Home.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/transaction/Journal_controller.dart';
import 'package:instamfin/services/controllers/transaction/expense_controller.dart';
import 'package:instamfin/services/controllers/transaction/payment_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:instamfin/services/pdf/reports/coll_report.dart';

class ReportsHome extends StatefulWidget {
  @override
  _ReportsHomeState createState() => _ReportsHomeState();
}

class _ReportsHomeState extends State<ReportsHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final User _user = UserController().getCurrentUser();

  String _selectedCategory = "0";
  Map<String, String> _categoriesMap = {
    "0": "Transactions",
    "1": "Customer",
    "2": "Payment",
    "3": "Collection",
    "4": "Journal",
    "5": "Expense"
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

    _fromDate.text = DateUtils.formatDate(DateTime.now());
    _toDate.text = DateUtils.formatDate(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => Home(),
        ),
        (Route<dynamic> route) => false,
      ),
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
                    setState(() {
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
    } else if (cVal == '1') {
      types.add('All');
      types.add('New');
      types.add('Active');
      types.add('Pending');
      types.add('Settled');
    } else if (cVal == '2') {
      types.add('All');
      types.add('Active');
      types.add('Pending');
      types.add('Settled');
    } else if (cVal == '3') {
      types.add('All');
      types.add('Collection');
      types.add('Doc Charge');
      types.add('Surcharge');
      types.add('Settlement');
      types.add('Penalty');
      types.add('Referral Commission');
    } else if (cVal == '4') {
      types.add('All');
      // types.add('Jornal In');
      // types.add('Jornal Out');
    } else if (cVal == '5') {
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
      PaymentController _pc = PaymentController();
      JournalController _jc = JournalController();
      ExpenseController _ec = ExpenseController();
      List<Payment> pays;
      List<Collection> colls;
      List<Journal> journals;
      List<Expense> expenses;

      if (_selectedRange == '0') {
        // Todays Report
        pays = await _pc.getPaymentsByDate(
            _user.primaryFinance,
            _user.primaryBranch,
            _user.primarySubBranch,
            DateUtils.getUTCDateEpoch(fromDate));

        colls = await Collection().allCollectionByDate(
            _user.primaryFinance,
            _user.primaryBranch,
            _user.primarySubBranch,
            [0, 1, 2, 3, 4, 5],
            DateUtils.getUTCDateEpoch(fromDate));

        journals = await _jc.getJournalByDate(_user.primaryFinance,
            _user.primaryBranch, _user.primarySubBranch, fromDate);

        expenses = await _ec.getExpenseByDate(_user.primaryFinance,
            _user.primaryBranch, _user.primarySubBranch, fromDate);
      } else {
        // Date Range Report
        pays = await _pc.getAllPaymentsByDateRange(_user.primaryFinance,
            _user.primaryBranch, _user.primarySubBranch, fromDate, toDate);

        colls = await Collection().getAllCollectionsByDateRange(
            _user.primaryFinance,
            _user.primaryBranch,
            _user.primarySubBranch,
            [0, 1, 2, 3, 4, 5],
            DateUtils.getUTCDateEpoch(fromDate),
            DateUtils.getUTCDateEpoch(toDate));

        journals = await _jc.getAllJournalByDateRange(_user.primaryFinance,
            _user.primaryBranch, _user.primarySubBranch, fromDate, toDate);

        expenses = await _ec.getAllExpenseByDateRange(_user.primaryFinance,
            _user.primaryBranch, _user.primarySubBranch, fromDate, toDate);
      }
    } else if (_selectedCategory == '1') {
      List<Customer> customers;

      if (_selectedRange == '0') {
        // Todays Customer Report
        customers = await Customer().getAllByDate(
            _user.primaryFinance,
            _user.primaryBranch,
            _user.primarySubBranch,
            DateUtils.getUTCDateEpoch(fromDate));
      } else {
        // Customer Report by Date Range
        customers = await Customer().getAllByDateRange(
            _user.primaryFinance,
            _user.primaryBranch,
            _user.primarySubBranch,
            DateUtils.getUTCDateEpoch(fromDate),
            DateUtils.getUTCDateEpoch(toDate));
      }
    } else if (_selectedCategory == '2') {
      PaymentController _pc = PaymentController();
      List<Payment> pays;

      if (_selectedRange == '0') {
        // Todays Payment Report
        pays = await _pc.getPaymentsByDate(
            _user.primaryFinance,
            _user.primaryBranch,
            _user.primarySubBranch,
            DateUtils.getUTCDateEpoch(fromDate));
      } else {
        // Payment Report by Date Range
        pays = await _pc.getAllPaymentsByDateRange(_user.primaryFinance,
            _user.primaryBranch, _user.primarySubBranch, fromDate, toDate);
      }
    } else if (_selectedCategory == '3') {
      List<Collection> colls;

      if (_selectedRange == '0') {
        // Todays Collection Report
        colls = await Collection().allCollectionByDate(
            _user.primaryFinance,
            _user.primaryBranch,
            _user.primarySubBranch,
            _selectedType == '0'
                ? [0, 1, 2, 3, 4, 5]
                : [int.parse(_selectedType) - 1],
            DateUtils.getUTCDateEpoch(fromDate));
      } else {
        // Collection Report by Date Range
        colls = await Collection().getAllCollectionsByDateRange(
            _user.primaryFinance,
            _user.primaryBranch,
            _user.primarySubBranch,
            _selectedType == '0'
                ? [0, 1, 2, 3, 4, 5]
                : [int.parse(_selectedType) - 1],
            DateUtils.getUTCDateEpoch(fromDate),
            DateUtils.getUTCDateEpoch(toDate));
      }
      Navigator.pop(context);
      if (colls.length > 0) {
        _scaffoldKey.currentState.showSnackBar(CustomSnackBar.successSnackBar(
            "Generating you Report! Please wait...", 2));
        await CollectionReport().generateReport(_user, colls);
      } else {
        _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
            "No Data found. Please try different criteria!", 2));
      }
    } else if (_selectedCategory == '4') {
      JournalController _jc = JournalController();
      List<Journal> journals;

      if (_selectedRange == '0') {
        // Todays Journal Report
        journals = await _jc.getJournalByDate(_user.primaryFinance,
            _user.primaryBranch, _user.primarySubBranch, fromDate);
      } else {
        // Journal Report by Date Range
        journals = await _jc.getAllJournalByDateRange(_user.primaryFinance,
            _user.primaryBranch, _user.primarySubBranch, fromDate, toDate);
      }
    } else if (_selectedCategory == '5') {
      ExpenseController _ec = ExpenseController();
      List<Expense> expenses;

      if (_selectedRange == '0') {
        // Todays Expense Report
        expenses = await _ec.getExpenseByDate(_user.primaryFinance,
            _user.primaryBranch, _user.primarySubBranch, fromDate);
      } else {
        // Expense Report by Date Range
        expenses = await _ec.getAllExpenseByDateRange(_user.primaryFinance,
            _user.primaryBranch, _user.primarySubBranch, fromDate, toDate);
      }
    }
  }
}
