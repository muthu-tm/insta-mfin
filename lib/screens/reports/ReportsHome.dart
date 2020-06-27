import 'package:flutter/material.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/app/appBar.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/app/sideDrawer.dart';
import 'package:instamfin/screens/home/Home.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

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

  int fromDate = DateUtils.getUTCDateEpoch(DateTime.now());
  int toDate = DateUtils.getUTCDateEpoch(DateTime.now());

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
      types.add('Referral Commission');
      types.add('Penalty');
      types.add('Settlement');
    } else if (cVal == '4') {
      types.add('All');
      types.add('Jornal In');
      types.add('Jornal Out');
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
      initialDate: DateTime.fromMillisecondsSinceEpoch(fromDate),
      firstDate: DateTime(1990),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );
    if (picked != null)
      setState(
        () {
          fromDate = DateUtils.getUTCDateEpoch(picked);
          _fromDate.text = DateUtils.formatDate(picked);
        },
      );
  }

  Future<Null> _selectToDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.fromMillisecondsSinceEpoch(toDate),
      firstDate: DateTime(1990),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );
    if (picked != null)
      setState(
        () {
          toDate = DateUtils.getUTCDateEpoch(picked);
          _toDate.text = DateUtils.formatDate(picked);
        },
      );
  }

  _submit() async {
    CustomDialogs.actionWaiting(context, "Fetching Report!");
    await Future.delayed(Duration(seconds: 2));
    Navigator.pop(context);
  }
}
