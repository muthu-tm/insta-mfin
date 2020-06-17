import 'package:flutter/material.dart';
import 'package:instamfin/screens/transaction/collection/CollectionBookPayments.dart';
import 'package:instamfin/screens/transaction/collection/CollectionsTab.dart';
import 'package:instamfin/screens/transaction/collection/PaymentReports.dart';
import 'package:instamfin/screens/transaction/collection/PaymentTemplatesScreen.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class CollectionBookHome extends StatelessWidget {
  final DateTime currentDate = DateTime.now();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: _scaffoldKey,
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
                        name: 'transactions/collections/template'),
                  ),
                );
              },
            )
          ],
          bottom: TabBar(
            unselectedLabelColor: CustomColors.mfinWhite,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              gradient: LinearGradient(colors: [
                CustomColors.mfinLightBlue,
                CustomColors.mfinBlue,
                CustomColors.mfinLightBlue
              ]),
              borderRadius: BorderRadius.circular(10),
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
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CollectionsTab(),
            CollectionBookPayments(),
            PaymentReportScreen(),
          ],
        ),
      ),
    );
  }
}
