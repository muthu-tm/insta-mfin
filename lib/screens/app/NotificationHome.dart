import 'package:flutter/material.dart';
import 'package:instamfin/screens/app/NotificationListWidget.dart';
import 'package:instamfin/screens/app/SearchAppBar.dart';
import 'package:instamfin/screens/app/sideDrawer.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/IconButton.dart';

class NotificationHome extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: openDrawer(context),
        appBar: AppBar(
          backgroundColor: CustomColors.mfinBlue,
          automaticallyImplyLeading: false,
          title: InkWell(
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
          ],
          bottom: TabBar(
            unselectedLabelColor: CustomColors.mfinWhite,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 0.5,
            indicator: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  CustomColors.mfinFadedButtonGreen,
                  CustomColors.mfinBlue,
                  CustomColors.mfinFadedButtonGreen
                ],
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            tabs: [
              Tab(
                child: Align(
                  alignment: Alignment.center,
                  child: Text("All"),
                ),
              ),
              Tab(
                child: Align(
                  alignment: Alignment.center,
                  child: Text("Finance"),
                ),
              ),
              Tab(
                child: Align(
                  alignment: Alignment.center,
                  child: Text("Alert"),
                ),
              ),
              Tab(
                child: Align(
                  alignment: Alignment.center,
                  child: Text("Personal"),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            NotificationListWidget("No Notification received yet!",
                CustomColors.mfinBlue, true, [0]),
            NotificationListWidget("No Finance Notification received yet!",
                CustomColors.mfinBlue, false, [1]),
            NotificationListWidget(
                "No Alerts received yet!", CustomColors.mfinBlue, false, [2]),
            NotificationListWidget("No Personal Notification received yet!",
                CustomColors.mfinBlue, false, [3]),
          ],
        ),
      ),
    );
  }
}
