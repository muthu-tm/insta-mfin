import 'package:flutter/material.dart';
import 'package:instamfin/db/models/finance.dart';
import 'package:instamfin/screens/settings/editors/EditFinanceProfile.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/finance/finance_controller.dart';
import 'package:instamfin/app_localizations.dart';

class FinanceProfileWidget extends StatelessWidget {
  final FinanceController _financeController = FinanceController();

  FinanceProfileWidget(this.financeID);

  final String financeID;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Finance>(
        future: _financeController.getFinanceByID(financeID),
        builder: (BuildContext context, AsyncSnapshot<Finance> snapshot) {
          List<Widget> children;

          if (snapshot.hasData) {
            children = <Widget>[
              ListTile(
                title: TextFormField(
                  initialValue: snapshot.data.financeName,
                  decoration: InputDecoration(
                    hintText:
                        AppLocalizations.of(context).translate('finance_name'),
                    fillColor: CustomColors.mfinWhite,
                    filled: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.mfinGrey)),
                  ),
                  readOnly: true,
                ),
              ),
              ListTile(
                title: TextFormField(
                  initialValue: snapshot.data.registrationID,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)
                        .translate('registration_id'),
                    fillColor: CustomColors.mfinWhite,
                    filled: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.mfinGrey)),
                  ),
                  readOnly: true,
                ),
              ),
              ListTile(
                title: TextFormField(
                  initialValue: snapshot.data.dateOfRegistration != null
                      ? DateUtils.formatDate(
                          DateTime.fromMillisecondsSinceEpoch(
                              snapshot.data.dateOfRegistration))
                      : "",
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)
                        .translate('registered_date'),
                    fillColor: CustomColors.mfinWhite,
                    filled: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.mfinGrey)),
                  ),
                  readOnly: true,
                ),
              ),
              ListTile(
                title: TextFormField(
                  initialValue: snapshot.data.contactNumber,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)
                        .translate('contact_number'),
                    fillColor: CustomColors.mfinWhite,
                    filled: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.mfinGrey)),
                  ),
                  readOnly: true,
                ),
              ),
              ListTile(
                title: TextFormField(
                  initialValue: snapshot.data.emailID,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)
                        .translate('finance_email_id'),
                    fillColor: CustomColors.mfinWhite,
                    filled: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.mfinWhite)),
                  ),
                  readOnly: true,
                ),
              ),
              ListTile(
                title: TextFormField(
                  initialValue: snapshot.data.address.toString(),
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)
                        .translate('finance_address'),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                    fillColor: CustomColors.mfinWhite,
                    filled: true,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.mfinGrey)),
                  ),
                  readOnly: true,
                ),
              ),
            ];
          } else if (snapshot.hasError) {
            children = AsyncWidgets.asyncError();
          } else {
            children = AsyncWidgets.asyncWaiting();
          }

          return Card(
            color: CustomColors.mfinLightGrey,
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(
                    Icons.account_balance,
                    size: 35.0,
                    color: CustomColors.mfinButtonGreen,
                  ),
                  title: Text(
                    AppLocalizations.of(context).translate('finance_details'),
                    style: TextStyle(
                      color: CustomColors.mfinBlue,
                      fontSize: 18.0,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.edit,
                      size: 35.0,
                      color: CustomColors.mfinBlue,
                    ),
                    onPressed: () {
                      if (snapshot.hasData) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditFinanceProfile(snapshot.data),
                            settings:
                                RouteSettings(name: '/settings/finance/edit'),
                          ),
                        );
                      } else {
                        Scaffold.of(context).showSnackBar(
                            CustomSnackBar.errorSnackBar(
                                "Unable to open Editor! Finance not loaded correctly!",
                                3));
                      }
                    },
                  ),
                ),
                Divider(
                  color: CustomColors.mfinBlue,
                  thickness: 1,
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: children,
                  ),
                ),
              ],
            ),
          );
        });
  }
}
