import 'package:flutter/material.dart';
import 'package:instamfin/screens/settings/add/AddNewFinance.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class AddFinanceWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Wish to be a Complete Financier?",
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: 16,
              color: CustomColors.mfinBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Material(
            elevation: 10.0,
            shadowColor: CustomColors.mfinButtonGreen,
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.75,
              height: 50,
              child: FlatButton.icon(
                icon: Icon(
                  Icons.business_center,
                  size: 35.0,
                  color: CustomColors.mfinButtonGreen,
                ),
                label: Text(
                  "Register Your Finance!",
                  style: TextStyle(
                      fontFamily: 'Georgia',
                      color: CustomColors.mfinBlue,
                      fontSize: 17.0),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddFinancePage(),
                    settings: RouteSettings(name: '/settings/finance/add'),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
