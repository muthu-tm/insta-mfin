import 'package:flutter/material.dart';
import 'package:instamfin/screens/app/sideDrawer.dart';
import 'package:instamfin/screens/transaction/settings/TransactionCollectionBuilder.dart';
import 'package:instamfin/screens/transaction/settings/TransactionJournalBuilder.dart';
import 'package:instamfin/screens/transaction/settings/TransactionMiscellaneousBuilder.dart';
import 'package:instamfin/screens/transaction/settings/TransactionSettings.dart';
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
              child: InkWell(
                onTap: () {
                  print("Pressed Collection Book");
                },
                child: Row(
                  children: <Widget>[
                    Material(
                      color: CustomColors.mfinBlue,
                      elevation: 10.0,
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.33,
                        height: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Spacer(),
                            Icon(
                              Icons.library_books,
                              size: 50.0,
                              color: CustomColors.mfinWhite,
                            ),
                            Spacer(),
                            Text(
                              "Collection Book",
                              style: TextStyle(
                                fontSize: 17,
                                color: CustomColors.mfinWhite,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                    Material(
                      color: CustomColors.mfinLightGrey,
                      elevation: 10.0,
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.57,
                        height: 150,
                        child: TransactionCollectionBuilder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
              child: InkWell(
                onTap: () {
                  print("Pressed Miscellaneous Expenses");
                },
                child: Row(
                  children: <Widget>[
                    Material(
                      color: CustomColors.mfinBlue,
                      elevation: 10.0,
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.33,
                        height: 120,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Spacer(),
                            Icon(
                              Icons.playlist_add,
                              size: 55.0,
                              color: CustomColors.mfinAlertRed,
                            ),
                            Spacer(),
                            Text(
                              "Miscellaneous Expenses",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 17,
                                color: CustomColors.mfinAlertRed,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                    Material(
                      color: CustomColors.mfinLightGrey,
                      elevation: 10.0,
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.57,
                        height: 120,
                        child: TransactionMiscellaneousBuilder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
              child: InkWell(
                onTap: () {
                  print("Pressed Journal Entries");
                },
                child: Row(
                  children: <Widget>[
                    Material(
                      color: CustomColors.mfinBlue,
                      elevation: 10.0,
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.33,
                        height: 120,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Spacer(),
                            Icon(
                              Icons.swap_horiz,
                              size: 55.0,
                              color: CustomColors.mfinWhite,
                            ),
                            Spacer(),
                            Text(
                              "Journal Entries",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 17,
                                color: CustomColors.mfinWhite,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                    Material(
                      color: CustomColors.mfinLightGrey,
                      elevation: 10.0,
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.57,
                        height: 120,
                        child: TransactionJournalBuilder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
              child: Material(
                color: CustomColors.mfinLightGrey,
                elevation: 10.0,
                borderRadius: BorderRadius.circular(10.0),
                child: InkWell(
                  splashColor: CustomColors.mfinButtonGreen,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TransactionSetting()));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.90,
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Spacer(),
                        Icon(
                          Icons.settings,
                          size: 55.0,
                          color: CustomColors.mfinBlue,
                        ),
                        Spacer(),
                        Text(
                          "Settings & Preferences",
                          style: TextStyle(
                            fontSize: 18,
                            color: CustomColors.mfinBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: bottomBar(context),
    );
  }
}
