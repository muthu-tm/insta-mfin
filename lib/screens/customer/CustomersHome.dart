import 'package:flutter/material.dart';
import 'package:instamfin/screens/app/SearchAppBar.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/app/notification_icon.dart';
import 'package:instamfin/screens/app/sideDrawer.dart';
import 'package:instamfin/screens/customer/AddCustomer.dart';
import 'package:instamfin/screens/customer/widgets/CustomerListWidget.dart';
import 'package:instamfin/screens/home/Home.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomTabBar.dart';
import 'package:instamfin/screens/utils/IconButton.dart';

class CustomersHome extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => UserHomeScreen(),
        ),
        (Route<dynamic> route) => false,
      ),
      child: DefaultTabController(
        length: 5,
        child: Scaffold(
          key: _scaffoldKey,
          drawer: openDrawer(context),
          appBar: AppBar(
            centerTitle: true,
            title: Text("Customers"),
            backgroundColor: CustomColors.mfinBlue,
            automaticallyImplyLeading: false,
            leading: InkWell(
              onTap: () => _scaffoldKey.currentState.openDrawer(),
              child: Container(
                padding: EdgeInsets.only(left: 5.0),
                child: Icon(
                  Icons.menu,
                  size: 35.0,
                  color: CustomColors.mfinWhite,
                ),
              ),
            ),
            actions: <Widget>[
              customIconButton(
                Icons.search,
                35.0,
                CustomColors.mfinWhite,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchAppBar(),
                      settings: RouteSettings(name: '/Search'),
                    ),
                  );
                },
              ),
              PushNotification(),
            ],
            bottom: CustomTabBar(
              CustomColors.mfinLightGrey,
              TabBar(
                isScrollable: true,
                labelColor: CustomColors.mfinWhite,
                indicatorWeight: 0,
                labelPadding: EdgeInsets.only(left: 5.0, right: 5.0),
                indicator: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      CustomColors.mfinLightBlue,
                      CustomColors.mfinLightGrey,
                      CustomColors.mfinLightBlue,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                tabs: [
                  Tab(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      alignment: Alignment.center,
                      child: Text(
                        "All",
                        style: TextStyle(
                          color: CustomColors.mfinBlue,
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      alignment: Alignment.center,
                      child: Text(
                        "New",
                        style: TextStyle(
                          color: CustomColors.mfinBlue,
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      alignment: Alignment.center,
                      child: Text(
                        "Active",
                        style: TextStyle(
                          color: CustomColors.mfinButtonGreen,
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      alignment: Alignment.center,
                      child: Text(
                        "Pending",
                        style: TextStyle(
                          color: CustomColors.mfinAlertRed,
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      alignment: Alignment.center,
                      child: Text(
                        "Closed",
                        style: TextStyle(
                          color: CustomColors.mfinBlack,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: CustomColors.mfinBlue,
            tooltip: "Add Customer",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddCustomer(),
                  settings: RouteSettings(name: '/customers/add'),
                ),
              );
            },
            elevation: 5.0,
            label: Text(
              'Add',
              style: TextStyle(
                color: CustomColors.mfinWhite,
                fontSize: 16,
              ),
            ),
            icon: Icon(
              Icons.add,
              size: 40,
              color: CustomColors.mfinButtonGreen,
            ),
          ),
          body: TabBarView(
            children: [
              CustomerListWidget(_scaffoldKey, 'All Customers', 0, true),
              CustomerListWidget(_scaffoldKey, 'New Customers', 0, false),
              CustomerListWidget(_scaffoldKey, 'Active Customers', 1, false),
              CustomerListWidget(_scaffoldKey, 'Pending Customers', 2, false),
              CustomerListWidget(_scaffoldKey, 'Closed Customers', 3, false),
            ],
          ),
          bottomNavigationBar: bottomBar(context),
        ),
      ),
    );
  }
}
