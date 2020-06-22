import 'package:flutter/material.dart';
import 'package:instamfin/screens/transaction/collection/CollectionBookTab.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/date_utils.dart';

class CollectionBookHome extends StatelessWidget {
  final DateTime currentDate = DateTime.now();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Collection Book"),
          backgroundColor: CustomColors.mfinBlue,
          bottom: TabBar(
            unselectedLabelColor: CustomColors.mfinWhite,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              color: CustomColors.mfinLightBlue,
              borderRadius: BorderRadius.circular(5),
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
            CollectionBookTab(
                DateUtils.getUTCDateEpoch(
                    DateTime.now().subtract(Duration(days: 1))),
                CustomColors.mfinAlertRed,
                CustomColors.mfinGrey),
            CollectionBookTab(DateUtils.getUTCDateEpoch(DateTime.now()),
                CustomColors.mfinBlue, CustomColors.mfinGrey),
            CollectionBookTab(
                DateUtils.getUTCDateEpoch(
                    DateTime.now().add(Duration(days: 1))),
                CustomColors.mfinGrey,
                CustomColors.mfinWhite),
          ],
        ),
      ),
    );
  }
}
