import 'package:flutter/material.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

Widget journalAppBar(BuildContext context, title, routes, screen) {
  return AppBar(
    title: Text(title),
    backgroundColor: CustomColors.mfinBlue,
    actions: <Widget>[
      IconButton(
        alignment: Alignment.centerLeft,
        iconSize: 40,
        highlightColor: CustomColors.mfinWhite,
        color: CustomColors.mfinFadedButtonGreen,
        splashColor: CustomColors.mfinWhite,
        icon: Icon(Icons.category),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => screen,
              settings: RouteSettings(name: routes),
            ),
          );
        },
      )
    ],
  );
}
