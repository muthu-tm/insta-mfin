import 'package:flutter/material.dart';
import 'package:instamfin/screens/home/AuthPage.dart';
import 'package:instamfin/screens/home/HomeScreen.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';

class UserHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () => CustomDialogs.confirm(
          context, "Warning!", "Do you really want to exit?", () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => AuthPage(),
            settings: RouteSettings(name: '/close'),
          ),
          (Route<dynamic> route) => false,
        );
      }, () => Navigator.pop(context, false)),
      child: HomeScreen(),
    );
  }
}
