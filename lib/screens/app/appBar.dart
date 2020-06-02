import 'package:flutter/material.dart';
import 'package:instamfin/screens/app/SearchAppBar.dart';
import 'package:instamfin/screens/app/notification_icon.dart';
import 'package:instamfin/screens/utils/IconButton.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

Widget topAppBar(GlobalKey<ScaffoldState> _scaffoldKey, BuildContext context) {
  String picURL = UserController().getCurrentUser().getProfilePicPath();

  return AppBar(
    backgroundColor: CustomColors.mfinBlue,
    titleSpacing: 0.0,
    automaticallyImplyLeading: false,
    title: InkWell(
      onTap: () => _scaffoldKey.currentState.openDrawer(),
      child: Container(
        width: 50,
        padding: EdgeInsets.only(left: 5.0),
        child: picURL == ""
            ? Icon(Icons.account_box, size: 45.0, color: CustomColors.mfinWhite)
            : ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
                child: Align(
                  alignment: Alignment.center,
                  heightFactor: 0.7,
                  widthFactor: 0.8,
                  child: Image.network(picURL),
                ),
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
