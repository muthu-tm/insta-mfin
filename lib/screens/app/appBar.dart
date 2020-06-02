import 'package:flutter/material.dart';
import 'package:instamfin/screens/app/SearchAppBar.dart';
import 'package:instamfin/screens/app/notification_icon.dart';
import 'package:instamfin/screens/utils/IconButton.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

Widget topAppBar(BuildContext context) {
  String picURL = UserController().getCurrentUser().getProfilePicPath();

  return AppBar(
    // Here we take the value from the MyHomePage object that was created by
    // the App.build method, and use it to set our appbar title.
    backgroundColor: CustomColors.mfinBlue,
    leading: Builder(
      builder: (context) => InkWell(
        onTap: () => Scaffold.of(context).openDrawer(),
        child: picURL == ""
            ? Icon(Icons.account_box, size: 45.0, color: CustomColors.mfinWhite)
            : CircleAvatar(
                radius: 35.0,
                backgroundImage: NetworkImage(picURL),
                backgroundColor: Colors.transparent,
              ),
      ),
    ),
    actions: <Widget>[
      customIconButton(Icons.search, 35.0, CustomColors.mfinWhite, () {
        print("Pressed Customers search");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchAppBar(),
          ),
        );
      }),
      PushNotification(),
    ],
  );
}
