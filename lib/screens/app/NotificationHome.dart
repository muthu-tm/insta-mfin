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
      length: 3,
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
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: CustomColors.mfinWhite,
            unselectedLabelColor: CustomColors.mfinWhite,
            indicatorWeight: 0,
            labelPadding: EdgeInsets.only(left: 5.0, right: 5.0),
            indicator: BoxDecoration(
              color: CustomColors.mfinLightBlue,
              borderRadius: BorderRadius.circular(3),
            ),
            tabs: [
              Tab(
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    AppLocalizations.of(context).translate('all'),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    AppLocalizations.of(context).translate('finance'),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    AppLocalizations.of(context).translate('promotions'),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            NotificationListWidget("No Notification received yet!",
                CustomColors.mfinBlue, true, [0]),
            NotificationListWidget("No Notification received yet!",
                CustomColors.mfinBlue, false, [1]),
            NotificationListWidget("No Promotions and Offers received yet!",
                CustomColors.mfinBlue, false, [2]),
          ],
        ),
      ),
    );
  }
}
