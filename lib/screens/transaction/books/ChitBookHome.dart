import 'package:flutter/material.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/app/RechargeAlertScreen.dart';
import 'package:instamfin/screens/transaction/books/ChitBookTab.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class ChitBookHome extends StatefulWidget {
  @override
  _ChitBookHomeState createState() => _ChitBookHomeState();
}

class _ChitBookHomeState extends State<ChitBookHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final User _user = UserController().getCurrentUser();

  bool hasValidSubscription = true;

  @override
  void initState() {
    super.initState();

    if (_user.chitSubscription < DateUtils.getUTCDateEpoch(DateTime.now())) {
      hasValidSubscription = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return hasValidSubscription
        ? DefaultTabController(
            length: 3,
            initialIndex: 1,
            child: Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                title: Text("Chit Book"),
                backgroundColor: CustomColors.mfinBlue,
                bottom: TabBar(
                  unselectedLabelColor: CustomColors.mfinWhite,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: CustomColors.mfinLightBlue,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  tabs: [
                    Tab(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("Pending"),
                      ),
                    ),
                    Tab(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("Today"),
                      ),
                    ),
                    Tab(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("Tomorrow"),
                      ),
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  ChitBookTab(
                      _scaffoldKey,
                      true,
                      DateUtils.getUTCDateEpoch(
                          DateTime.now().subtract(Duration(days: 1))),
                      CustomColors.mfinAlertRed,
                      CustomColors.mfinGrey),
                  ChitBookTab(
                      _scaffoldKey,
                      false,
                      DateUtils.getUTCDateEpoch(DateTime.now()),
                      CustomColors.mfinBlue,
                      CustomColors.mfinGrey),
                  ChitBookTab(
                      _scaffoldKey,
                      false,
                      DateUtils.getUTCDateEpoch(
                          DateTime.now().add(Duration(days: 1))),
                      CustomColors.mfinGrey,
                      CustomColors.mfinWhite),
                ],
              ),
            ),
          )
        : RechargeAlertScreen("Chit Book");
  }
}
