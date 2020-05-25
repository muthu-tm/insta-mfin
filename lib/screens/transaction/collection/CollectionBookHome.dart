import 'package:flutter/material.dart';
import 'package:instamfin/screens/transaction/collection/PaymentListTile.dart';
import 'package:instamfin/screens/transaction/collection/PaymentReports.dart';
import 'package:instamfin/screens/transaction/collection/PaymentTemplatesScreen.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class CollectionBookHome extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  DateTime currentDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Collection Book"),
          backgroundColor: CustomColors.mfinBlue,
          actions: <Widget>[
            IconButton(
              alignment: Alignment.centerLeft,
              iconSize: 40,
              highlightColor: CustomColors.mfinWhite,
              color: CustomColors.mfinFadedButtonGreen,
              splashColor: CustomColors.mfinWhite,
              icon: Icon(Icons.category),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentTemplateScreen(),
                    settings: RouteSettings(
                        name: '/transactions/collectionbook/template'),
                  ),
                );
              },
            )
          ],
        ),
        body: DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                bottom: TabBar(
                    unselectedLabelColor: CustomColors.mfinBlue,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        CustomColors.mfinBlue,
                        CustomColors.mfinLightBlue
                      ]),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    tabs: [
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("Collections"),
                        ),
                      ),
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("Payments"),
                        ),
                      ),
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("All Transactions"),
                        ),
                      ),
                    ]),
              ),
              body: TabBarView(children: [
                PaymentListWidget(currentDate, new DateTime(currentDate.year, currentDate.month,
                        currentDate.day+1)),
                PaymentListWidget(new DateTime(currentDate.year, currentDate.month,
                        currentDate.day-7), currentDate),
                PaymentReportScreen(),
              ]),
            )),
      ),
    );
  }
}
