import 'package:flutter/material.dart';
import 'package:instamfin/screens/app/notification_icon.dart';
import 'package:instamfin/screens/utils/IconButton.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

Widget topAppBar(BuildContext context) {
  return AppBar(
    // Here we take the value from the MyHomePage object that was created by
    // the App.build method, and use it to set our appbar title.
    backgroundColor: CustomColors.mfinBlue,
    leading: Builder(
      builder: (context) => IconButton(
        icon: new Icon(Icons.account_box,
            size: 45.0, color: CustomColors.mfinWhite),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
    ),
    actions: <Widget>[
      customIconButton(Icons.search, 35.0, CustomColors.mfinWhite, () {
        print("Pressed Customers search");
      }),
      PushNotification(),
    ],
  );
}
