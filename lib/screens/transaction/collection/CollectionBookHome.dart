import 'package:flutter/material.dart';
import 'package:instamfin/screens/home/Home.dart';
import 'package:instamfin/screens/transaction/add/AddPaymentTemplate.dart';
import 'package:instamfin/screens/transaction/collection/CollectionBookPayments.dart';
import 'package:instamfin/screens/transaction/collection/CollectionsTab.dart';
import 'package:instamfin/screens/transaction/collection/PaymentReports.dart';
import 'package:instamfin/screens/transaction/collection/PaymentTemplatesScreen.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: CustomColors.mfinBlue,
          splashColor: CustomColors.mfinWhite,
          child: Icon(
            Icons.navigation,
            size: 30,
            color: CustomColors.mfinButtonGreen,
          ),
          onPressed: () {
            showMaterialModalBottomSheet(
                expand: false,
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context, scrollController) {
                  return Material(
                    child: SafeArea(
                        top: false,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              title: Text('Add payment template'),
                              leading: Icon(
                                Icons.monetization_on,
                                color: CustomColors.mfinBlue,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddPaymentTemplate(),
                                    settings: RouteSettings(
                                        name:
                                            '/transactions/collectionbook/template/add'),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              title: Text('Payment template list'),
                              leading: Icon(
                                Icons.view_list,
                                color: CustomColors.mfinBlue,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PaymentTemplateScreen(),
                                    settings: RouteSettings(
                                        name:
                                            'transactions/collections/template'),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              title: Text('Home'),
                              leading: Icon(
                                Icons.home,
                                color: CustomColors.mfinBlue,
                              ),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserHomeScreen(),
                                  settings: RouteSettings(name: '/home'),
                                ),
                              ),
                            )
                          ],
                        )),
                  );
                });
          },
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
