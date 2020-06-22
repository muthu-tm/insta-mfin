import 'package:flutter/material.dart';
import 'package:instamfin/screens/transaction/collection/AllTransactions.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class AllTransactionsBook extends StatefulWidget {
  @override
  _AllTransactionsBookState createState() => _AllTransactionsBookState();
}

class _AllTransactionsBookState extends State<AllTransactionsBook> {
  final int groupPref =
      UserController().getCurrentUser().preferences.transactionGroupBy;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Transactions Book"),
        backgroundColor: CustomColors.mfinBlue,
      ),
      body: SingleChildScrollView(
          child: groupPref == 0
              ? getTransactionsForDaily()
              : groupPref == 1
                  ? getTransactionsForWeekly()
                  : getTransactionsForMonthly()),
    );
  }

  Widget getTransactionsForDaily() {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        primary: false,
        itemCount: 7,
        itemBuilder: (BuildContext context, int index) {
          DateTime date = DateTime.now().subtract(Duration(days: index));
          String text = DateUtils.formatDate(date);

          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: Material(
              elevation: 10.0,
              borderRadius: BorderRadius.circular(10.0),
              color: CustomColors.mfinLightGrey,
              child: ExpansionTile(
                leading: Icon(
                  Icons.calendar_today,
                  size: 35.0,
                  color: CustomColors.mfinBlue,
                ),
                title: Text(
                  text,
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: <Widget>[
                  AllTransactionsBuilder(false, date, date),
                ],
              ),
            ),
          );
        });
  }

  Widget getTransactionsForWeekly() {
    DateTime sDate;
    DateTime eDate = DateTime.now();

    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        primary: false,
        itemCount: 7,
        itemBuilder: (BuildContext context, int index) {
          DateTime endDate = eDate;

          String eDateString = DateUtils.formatDate(eDate);
          sDate = eDate.subtract(Duration(days: eDate.weekday));
          eDate = sDate;
          String sDateString = DateUtils.formatDate(sDate);
          String tText = '$sDateString - $eDateString';

          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: Material(
              elevation: 10.0,
              borderRadius: BorderRadius.circular(10.0),
              color: CustomColors.mfinLightGrey,
              child: ExpansionTile(
                leading: Icon(
                  Icons.date_range,
                  size: 35.0,
                  color: CustomColors.mfinBlue,
                ),
                title: Text(
                  tText,
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: <Widget>[
                  AllTransactionsBuilder(true, sDate, endDate),
                ],
              ),
            ),
          );
        });
  }

  Widget getTransactionsForMonthly() {
    DateTime sDate;
    DateTime eDate = DateTime.now();

    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        primary: false,
        itemCount: 7,
        itemBuilder: (BuildContext context, int index) {
          DateTime endDate = eDate;

          String eDateString = DateUtils.formatDate(eDate);
          sDate = DateTime(eDate.year, eDate.month, 1, 0, 0, 0, 0, 0);
          eDate = sDate.subtract(Duration(days: 1));
          String sDateString = DateUtils.formatDate(sDate);
          String tText = '$sDateString - $eDateString';

          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: Material(
              elevation: 10.0,
              borderRadius: BorderRadius.circular(10.0),
              color: CustomColors.mfinLightGrey,
              child: ExpansionTile(
                leading: Icon(
                  Icons.date_range,
                  size: 35.0,
                  color: CustomColors.mfinBlue,
                ),
                title: Text(
                  tText,
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: <Widget>[
                  AllTransactionsBuilder(true, sDate, endDate),
                ],
              ),
            ),
          );
        });
  }
}
