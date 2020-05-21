import 'package:flutter/material.dart';
import 'package:instamfin/screens/transaction/journal/JournalCategoryScreen.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

Widget journalAppBar(BuildContext context) {
  return AppBar(
    title: Text("Journal Entries"),
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
              builder: (context) => JournalCategoryScreen(),
              settings: RouteSettings(name: '/transactions/journal/categories'),
            ),
          );
        },
      )
    ],
  );
}
