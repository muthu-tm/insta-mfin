import 'package:flutter/material.dart';
import 'package:instamfin/screens/app/NotificationListWidget.dart';
import 'package:instamfin/screens/app/SearchAppBar.dart';
import 'package:instamfin/screens/app/sideDrawer.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomTabBar.dart';
import 'package:instamfin/screens/utils/IconButton.dart';

import '../../app_localizations.dart';

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
          title: Text(
            AppLocalizations.of(context).translate('notifications'),
          ),
          backgroundColor: CustomColors.mfinBlue,
          automaticallyImplyLeading: false,
          leading: InkWell(
            onTap: () => _scaffoldKey.currentState.openDrawer(),
            child: Container(
              padding: EdgeInsets.only(left: 5.0),
              child: Icon(
                Icons.menu,
                size: 30.0,
                color: CustomColors.mfinWhite,
              ),
            ),
          ),
          actions: <Widget>[
            customIconButton(
              Icons.search,
              30.0,
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
          bottom: CustomTabBar(
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
                    child: Text(
                      AppLocalizations.of(context).translate('all'),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    alignment: Alignment.center,
                    child: Text(
                      AppLocalizations.of(context).translate('finance'),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    alignment: Alignment.center,
                    child: Text(
                      AppLocalizations.of(context).translate('alert'),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    alignment: Alignment.center,
                    child: Text(
                      AppLocalizations.of(context).translate('personal'),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    alignment: Alignment.center,
                    child: Text(
                      AppLocalizations.of(context).translate('promotions'),
                    ),
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
