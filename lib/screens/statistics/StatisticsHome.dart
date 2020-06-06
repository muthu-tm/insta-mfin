import 'package:flutter/material.dart';
import 'package:instamfin/screens/app/SearchAppBar.dart';
import 'package:instamfin/screens/app/sideDrawer.dart';
import 'package:instamfin/screens/statistics/DailyStatistics.dart';
import 'package:instamfin/screens/statistics/MonthlyStatistics.dart';
import 'package:instamfin/screens/statistics/WeeklyStatistics.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomTabBar.dart';
import 'package:instamfin/screens/utils/IconButton.dart';

class StatisticsHome extends StatelessWidget {
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
          title: Text("Statistics"),
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
          bottom: CustomTabBar(
            CustomColors.mfinLightGrey,
            TabBar(
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
                    child: Text("Daily"),
                  ),
                ),
                Tab(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    alignment: Alignment.center,
                    child: Text("Weekly"),
                  ),
                ),
                Tab(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    alignment: Alignment.center,
                    child: Text("Monthly"),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            DailyStatistics(),
            WeeklyStatistics(),
            MonthlyStatistics(),
          ],
        ),
      ),
    );
  }
}
