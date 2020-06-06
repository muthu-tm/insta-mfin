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
      length: 5,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: openDrawer(context),
        appBar: AppBar(
          centerTitle: true,
          title: Text("Notifications"),
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
          ],
          bottom: ColoredTabBar(
            CustomColors.mfinLightGrey,
            TabBar(
              isScrollable: true,
              indicatorColor: CustomColors.mfinWhite,
              labelColor: CustomColors.mfinWhite,
              unselectedLabelColor: CustomColors.mfinBlue,
              indicatorWeight: 0,
              labelPadding: EdgeInsets.only(left: 5.0, right: 5.0),
              indicator: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    CustomColors.mfinLightBlue,
                    CustomColors.mfinBlue,
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
                    child: Text("All"),
                  ),
                ),
                Tab(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    alignment: Alignment.center,
                    child: Text("Finance"),
                  ),
                ),
                Tab(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    alignment: Alignment.center,
                    child: Text("Alert"),
                  ),
                ),
                Tab(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    alignment: Alignment.center,
                    child: Text("Personal"),
                  ),
                ),
                Tab(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    alignment: Alignment.center,
                    child: Text("Promotions"),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            NotificationListWidget("No Notification received yet!",
                CustomColors.mfinBlue, true, [0]),
            NotificationListWidget("No Finance Notification received yet!",
                CustomColors.mfinBlue, false, [5]),
            NotificationListWidget(
                "No Alerts received yet!", CustomColors.mfinBlue, false, [3]),
            NotificationListWidget("No Personal Notification received yet!",
                CustomColors.mfinBlue, false, [6]),
            NotificationListWidget("No Promotions and Offers received yet!",
                CustomColors.mfinBlue, false, [2]),
          ],
        ),
      ),
    );
  }
}

class ColoredTabBar extends Container implements PreferredSizeWidget {
  ColoredTabBar(this.color, this.tabBar);

  final Color color;
  final TabBar tabBar;

  @override
  Size get preferredSize => tabBar.preferredSize;

  @override
  Widget build(BuildContext context) => Container(
        child: tabBar,
        decoration: BoxDecoration(
          color: color,
        ),
      );
}
