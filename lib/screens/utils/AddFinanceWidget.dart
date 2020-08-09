import 'package:flutter/material.dart';
import 'package:instamfin/screens/settings/add/AddNewFinance.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/app_localizations.dart';

class AddFinanceWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            AppLocalizations.of(context)
                .translate("wish_to_complete_financier"),
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: 16,
              color: CustomColors.mfinBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(5.0),
          child: Material(
            elevation: 5.0,
            shadowColor: CustomColors.mfinButtonGreen,
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              width: 275,
              height: 50,
              child: FlatButton.icon(
                icon: Icon(
                  Icons.business_center,
                  size: 35.0,
                  color: CustomColors.mfinButtonGreen,
                ),
                label: Text(
                  AppLocalizations.of(context)
                      .translate("register_your_finance"),
                  style: TextStyle(
                      fontFamily: 'Georgia',
                      color: CustomColors.mfinBlue,
                      fontSize: 15.0),
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
