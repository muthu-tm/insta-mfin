import 'package:flutter/material.dart';
import 'package:instamfin/screens/settings/AddNewFinance.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/IconButton.dart';

class AddFinanceWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Row(children: <Widget>[
                Text(
                  " Wish to be a Complete Financier?",
                  style: TextStyle(
                    fontFamily: 'Georgia',
                    fontSize: 17,
                    color: CustomColors.mfinBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 120.0, top: 10),
          child: InkWell(
            splashColor: CustomColors.mfinButtonGreen,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddFinancePage()),
              );
            }, // button pressed
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Container(
                  color: CustomColors.mfinBlue,
                  child: new Row(children: <Widget>[
                    customIconButton(Icons.business_center, 35.0,
                        CustomColors.mfinButtonGreen, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddFinancePage()),
                      );
                    }),
                    new Text(
                      "Register your finance here!",
                      style: TextStyle(
                          fontFamily: 'Georgia',
                          color: CustomColors.mfinButtonGreen,
                          fontSize: 17.0),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
