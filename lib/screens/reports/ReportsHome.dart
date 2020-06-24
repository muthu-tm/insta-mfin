import 'package:flutter/material.dart';
import 'package:instamfin/screens/app/appBar.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/app/sideDrawer.dart';
import 'package:instamfin/screens/home/Home.dart';

class ReportsHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => UserHomeScreen(),
        ),
        (Route<dynamic> route) => false,
      ),
      child: Scaffold(
        drawer: openDrawer(context),
        appBar: topAppBar(context),
        body: new Container(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("TODO"),
            ],
          ),
        ),
        bottomSheet: bottomBar(context),
      ),
    );
  }
}
