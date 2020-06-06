import 'package:flutter/material.dart';
import 'package:instamfin/screens/app/appBar.dart';
import 'package:instamfin/screens/app/sideDrawer.dart';
import 'package:instamfin/screens/statistics/PaymentStatisticsWidget.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/date_utils.dart';

class StatisticsHome extends StatefulWidget {
  @override
  _StatisticsHomeState createState() => _StatisticsHomeState();
}

class _StatisticsHomeState extends State<StatisticsHome> {
  String _selectedChart = "0";
  String _selectedY = "0";
  Map<String, String> _chartList = {"0": "Bar", "1": "Pie", "2": "Line"};
  Map<String, String> _yList = {"0": "Amount", "1": "Count"};

  DateTime selectedF = DateTime.now().subtract(Duration(days: 7));
  TextEditingController _fDate = new TextEditingController();
  DateTime selectedT = DateTime.now();
  TextEditingController _tDate = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: topAppBar(context),
      drawer: openDrawer(context),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Card(
              elevation: 10.0,
              color: CustomColors.mfinLightGrey,
              child: SizedBox(
                height: 250,
                width: MediaQuery.of(context).size.width * 0.97,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ListTile(
                      leading: SizedBox(
                        width: 90,
                        child: TextFormField(
                          initialValue: "FROM:",
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                              color: CustomColors.mfinBlue,
                            ),
                            fillColor: CustomColors.mfinLightGrey,
                            filled: true,
                          ),
                          enabled: false,
                          autofocus: false,
                        ),
                      ),
                      title: GestureDetector(
                        onTap: () => _selectFDate(context),
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: _fDate,
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
                        width: 90,
                        child: TextFormField(
                          initialValue: "TO: ",
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                              color: CustomColors.mfinBlue,
                            ),
                            fillColor: CustomColors.mfinLightGrey,
                            filled: true,
                          ),
                          enabled: false,
                          autofocus: false,
                        ),
                      ),
                      title: GestureDetector(
                        onTap: () => _selectTDate(context),
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: _tDate,
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
                        width: 90,
                        child: TextFormField(
                          initialValue: "CHART",
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                              color: CustomColors.mfinBlue,
                            ),
                            fillColor: CustomColors.mfinLightGrey,
                            filled: true,
                          ),
                          enabled: false,
                          autofocus: false,
                        ),
                      ),
                      title: DropdownButton<String>(
                        dropdownColor: CustomColors.mfinWhite,
                        isExpanded: true,
                        value: _selectedChart,
                        items: _chartList.entries.map(
                          (f) {
                            return DropdownMenuItem<String>(
                              value: f.key,
                              child: Text(f.value),
                            );
                          },
                        ).toList(),
                        onChanged: (newVal) {
                          setState(() {
                            _selectedChart = newVal;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      leading: SizedBox(
                        width: 90,
                        child: TextFormField(
                          initialValue: "Y-Axis",
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                              color: CustomColors.mfinBlue,
                            ),
                            fillColor: CustomColors.mfinLightGrey,
                            filled: true,
                          ),
                          enabled: false,
                          autofocus: false,
                        ),
                      ),
                      title: DropdownButton<String>(
                        dropdownColor: CustomColors.mfinWhite,
                        isExpanded: true,
                        value: _selectedY,
                        items: _yList.entries.map(
                          (f) {
                            return DropdownMenuItem<String>(
                              value: f.key,
                              child: Text(f.value),
                            );
                          },
                        ).toList(),
                        onChanged: (newVal) {
                          setState(() {
                            _selectedY = newVal;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            PaymentStatisticsWidget()
          ],
        ),
      ),
    );
  }

  Future<Null> _selectFDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedF,
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedF)
      setState(
        () {
          selectedF = picked;
          _fDate.value = TextEditingValue(
            text: DateUtils.formatDate(picked),
          );
        },
      );
  }

  Future<Null> _selectTDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedT,
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedT)
      setState(
        () {
          selectedT = picked;
          _tDate.value = TextEditingValue(
            text: DateUtils.formatDate(picked),
          );
        },
      );
  }
}
