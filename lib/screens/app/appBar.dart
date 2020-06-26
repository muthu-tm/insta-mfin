import 'package:flutter/material.dart';
import 'package:instamfin/screens/app/SearchAppBar.dart';
import 'package:instamfin/screens/app/notification_icon.dart';
import 'package:instamfin/screens/utils/IconButton.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

Widget topAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: CustomColors.mfinBlue,
    titleSpacing: 0.0,
    automaticallyImplyLeading: false,
    title: Builder(
      builder: (context) => InkWell(
        onTap: () => Scaffold.of(context).openDrawer(),
        child: Container(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.menu,
            size: 30.0,
            color: CustomColors.mfinWhite,
          ),
        ),
      ),
    ),
    actions: <Widget>[
      customIconButton(Icons.search, 30.0, CustomColors.mfinWhite, () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchAppBar(),
            settings: RouteSettings(name: '/Search'),
          ),
        );
      }),
      PushNotification(),
    ],
  );
}
