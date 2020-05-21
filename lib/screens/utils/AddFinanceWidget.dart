import 'package:flutter/material.dart';
import 'package:instamfin/screens/settings/add/AddNewFinance.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/IconButton.dart';

class AddFinanceWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              " Wish to be a Complete Financier?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 17,
                color: CustomColors.mfinBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: 115.0, top: 10, bottom: 10),
          child: InkWell(
            splashColor: CustomColors.mfinButtonGreen,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddFinancePage(),
                  settings: RouteSettings(name: '/settings/finance/add'),
                ),
              );
            }, // button pressed
            child: Container(
              color: CustomColors.mfinBlue,
              child: new Row(children: <Widget>[
                customIconButton(
                    Icons.business_center, 35.0, CustomColors.mfinButtonGreen,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddFinancePage(),
                      settings: RouteSettings(name: '/settings/finance/add'),
                    ),
                  );
                }),
                new Text(
                  "Register your Finance here!",
                  style: TextStyle(
                      fontFamily: 'Georgia',
                      color: CustomColors.mfinButtonGreen,
                      fontSize: 17.0),
                ),
              ]),
            ),
          ),
        ),
      ],
    );
  }
}
