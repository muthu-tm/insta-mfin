import 'package:flutter/material.dart';
import 'package:instamfin/screens/app/sideDrawer.dart';
import 'package:instamfin/screens/customer/CustomerListWidget.dart';
import 'package:instamfin/screens/utils/IconButton.dart';
import 'package:instamfin/screens/app/appBar.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class TransactionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: topAppBar(context),
      drawer: openDrawer(context),
      body: new Container(
        height: MediaQuery.of(context).size.height * 0.80,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly, //change here don't //worked
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  splashColor: CustomColors.mfinButtonGreen, // splash color
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CustomerListWidget("New Customer"),
                      ),
                    );
                  }, // button pressed
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      customIconButton(
                        Icons.arrow_upward,
                        50.0,
                        CustomColors.mfinAlertRed,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CustomerListWidget("New Customer"),
                            ),
                          );
                        },
                      ),
                      Padding(padding: EdgeInsets.all(05.0)),
                      Text(
                        "Payments",
                        style: TextStyle(
                          fontSize: 17,
                          color: CustomColors.mfinAlertRed,
                          fontWeight: FontWeight.bold,
                        ),
                      ), // text
                    ],
                  ),
                ),
                InkWell(
                  splashColor: CustomColors.mfinButtonGreen, // splash color
                  onTap: () {}, // button pressed
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      customIconButton(
                        Icons.arrow_downward,
                        50.0,
                        CustomColors.mfinPositiveGreen,
                        () {
                          print("Pressed Collections");
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.all(05.0),
                      ),
                      Text(
                        "Collections",
                        style: TextStyle(
                          fontSize: 17,
                          color: CustomColors.mfinPositiveGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ), // text
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly, //change here don't //worked
              crossAxisAlignment: CrossAxisAlignment.start,

              children: <Widget>[
                InkWell(
                  splashColor: CustomColors.mfinButtonGreen, // splash color
                  onTap: () {}, // button pressed
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      customIconButton(
                        Icons.playlist_add,
                        50.0,
                        CustomColors.mfinPositiveGreen,
                        () {
                          print("Pressed Miscellaneous Expense");
                        },
                      ),
                      Padding(padding: EdgeInsets.all(05.0)),
                      Text(
                        "Miscellaneous Expenses",
                        style: TextStyle(
                          fontSize: 17,
                          color: CustomColors.mfinPositiveGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ), // text
                    ],
                  ),
                ),
                InkWell(
                  splashColor: CustomColors.mfinButtonGreen, // splash color
                  onTap: () {}, // button pressed
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      customIconButton(
                        Icons.swap_horiz,
                        50.0,
                        CustomColors.mfinGrey,
                        () {
                          print("Pressed Journal Entry");
                        },
                      ),
                      Padding(padding: EdgeInsets.all(05.0)),
                      Text(
                        "Journal Entries",
                        style: TextStyle(
                          fontSize: 17,
                          color: CustomColors.mfinGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ), // text
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly, //change here don't //worked
              crossAxisAlignment: CrossAxisAlignment.start,

              children: <Widget>[
                InkWell(
                  splashColor: CustomColors.mfinButtonGreen, // splash color
                  onTap: () {}, // button pressed
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      customIconButton(
                        Icons.settings_applications,
                        50.0,
                        CustomColors.mfinBlue,
                        () {
                          print("Pressed Transaction Settings");
                        },
                      ),
                      Padding(padding: EdgeInsets.all(05.0)),
                      Text(
                        "Transaction Settings",
                        style: TextStyle(
                          fontSize: 17,
                          color: CustomColors.mfinBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ), // text
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomSheet: bottomBar(context),
    );
  }
}
