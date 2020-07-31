import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:instamfin/db/models/finance.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/home/UserFinanceSetup.dart';
import 'package:instamfin/screens/settings/widgets/FinanceBranchWidget.dart';
import 'package:instamfin/screens/settings/widgets/FinanceProfileWidget.dart';
import 'package:instamfin/screens/settings/widgets/FinanceUsersWidget.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:instamfin/app_localizations.dart';

class FinanceSetting extends StatefulWidget {
  @override
  _FinanceSettingState createState() => _FinanceSettingState();
}

class _FinanceSettingState extends State<FinanceSetting> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _pController = TextEditingController();
  final User _user = UserController().getCurrentUser();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('finance_settings')),
        backgroundColor: CustomColors.mfinBlue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: CustomColors.mfinAlertRed.withOpacity(0.7),
        onPressed: () async {
          await forceDeactivate(context);
        },
        label: Text(
          "DeActivate Finance",
          style: TextStyle(
            fontSize: 17,
            fontFamily: "Georgia",
            fontWeight: FontWeight.bold,
            color: CustomColors.mfinWhite,
          ),
        ),
        splashColor: CustomColors.mfinWhite,
        icon: Icon(
          Icons.delete_forever,
          size: 35,
          color: CustomColors.mfinWhite,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              FinanceProfileWidget(_user.primary.financeID),
              FinanceBranchWidget(_user.primary.financeID),
              FinanceUsersWidget(_user.primary.financeID),
              Padding(padding: EdgeInsets.only(top: 35, bottom: 35))
            ],
          ),
        ),
      ),
    );
  }

  Future forceDeactivate(BuildContext context) async {
    await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Confirm!",
            style: TextStyle(
                color: CustomColors.mfinAlertRed,
                fontSize: 25.0,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.start,
          ),
          content: Container(
            height: 150,
            child: Column(
              children: <Widget>[
                Text(
                    "Enter your Secret KEY! \n DeActivating your finance will deactivate all your Branches & SubBranches too, Please Confirm!"),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Card(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      obscureText: true,
                      autofocus: false,
                      controller: _pController,
                      decoration: InputDecoration(
                        hintText: 'Secret KEY',
                        fillColor: CustomColors.mfinLightGrey,
                        filled: true,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              color: CustomColors.mfinButtonGreen,
              child: Text(
                "NO",
                style: TextStyle(
                    color: CustomColors.mfinBlue,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.start,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              color: CustomColors.mfinAlertRed,
              child: Text(
                "YES",
                style: TextStyle(
                    color: CustomColors.mfinLightGrey,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.start,
              ),
              onPressed: () async {
                bool isValid = UserController().authCheck(_pController.text);
                _pController.text = "";

                if (isValid) {
                  try {
                    Map<String, dynamic> finDoc =
                        await Finance().getByID(_user.primary.financeID);
                    if (finDoc != null) {
                      Finance fin = Finance.fromJson(finDoc);
                      if (!fin.admins.contains(_user.mobileNumber)) {
                        Navigator.pop(context);
                        _scaffoldKey.currentState.showSnackBar(
                          CustomSnackBar.errorSnackBar(
                            "You are not admin for this Finance. You cannot DeActivate",
                            3,
                          ),
                        );
                        return;
                      }
                    } else {
                      Navigator.pop(context);
                      _scaffoldKey.currentState.showSnackBar(
                        CustomSnackBar.errorSnackBar(
                          "Unable to find your Finance now! Please try again later.",
                          3,
                        ),
                      );
                      return;
                    }

                    CustomDialogs.actionWaiting(context, "Deactivating..");
                    await Finance().updateByID({
                      'is_active': false,
                      'deactivated_at':
                          DateUtils.getUTCDateEpoch(DateTime.now())
                    }, _user.primary.financeID);
                    await UserController().refreshUser(true);
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (BuildContext context) => UserFinanceSetup(),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  } catch (err) {
                    Navigator.pop(context);
                    _scaffoldKey.currentState.showSnackBar(
                      CustomSnackBar.errorSnackBar(
                        "Unable to deactivate your Finance now! Please try again later.",
                        3,
                      ),
                    );
                  }
                } else {
                  Navigator.pop(context);
                  _scaffoldKey.currentState.showSnackBar(
                    CustomSnackBar.errorSnackBar(
                      "Failed to Authenticate!",
                      3,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
