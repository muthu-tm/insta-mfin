import 'package:flutter/material.dart';
import 'package:instamfin/screens/transaction/miscellaneous/MiscellaneousCategoryScreen.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

Widget miscellaneousAppBar(BuildContext context) {
  return AppBar(
    title: Text("Miscellaneous Expenses"),
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
              builder: (context) => MiscellaneousCategoryScreen(),
              settings: RouteSettings(name: '/transactions/miscellaneous/categories'),
            ),
          );
        },
      )
    ],
  );
}
