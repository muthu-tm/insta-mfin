import 'package:flutter/material.dart';
import 'package:instamfin/screens/statistics/CollectionStatisticsWidget.dart';
import 'package:instamfin/screens/statistics/ExpenseStatisticsWidget.dart';
import 'package:instamfin/screens/statistics/JournalStatisticsWidget.dart';
import 'package:instamfin/screens/statistics/PaymentStatisticsWidget.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/date_utils.dart';

class WeeklyStatistics extends StatefulWidget {
  @override
  _WeeklyStatisticsState createState() => _WeeklyStatisticsState();
}

class _WeeklyStatisticsState extends State<WeeklyStatistics> {
  String _selectedChart = "2";
  String _selectedY = "0";
  Map<String, String> _chartList = {"0": "Line", "1": "Bubble", "2": "Bar"};
  Map<String, String> _yList = {"0": "Amount", "1": "Count"};

  DateTime selectedF = DateTime.now().subtract(Duration(days: 28));
  TextEditingController _fDate = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Card(
            elevation: 10.0,
            color: CustomColors.mfinLightGrey,
            child: SizedBox(
              height: 175,
              width: MediaQuery.of(context).size.width * 0.97,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
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
                  ListTile(
                    leading: SizedBox(
                      width: 90,
                      child: TextFormField(
                        initialValue: "FROM",
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
                                borderSide:
                                    BorderSide(color: CustomColors.mfinWhite)),
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
                ],
              ),
            ),
          ),
          PaymentStatisticsWidget(
            int.parse(_selectedChart),
            1,
            selectedF,
            selectedF.add(
              Duration(days: 29),
            ),
          ),
          CollectionStatisticsWidget(
            int.parse(_selectedChart),
            1,
            selectedF,
            selectedF.add(
              Duration(days: 29),
            ),
          ),
          ExpenseStatisticsWidget(
            int.parse(_selectedChart),
            1,
            selectedF,
            selectedF.add(
              Duration(days: 29),
            ),
          ),
          JournalStatisticsWidget(
            int.parse(_selectedChart),
            1,
            selectedF,
            selectedF.add(
              Duration(days: 29),
            ),
          ),
        ],
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
}
