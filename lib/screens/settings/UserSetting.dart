import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:instamfin/screens/home/AuthPage.dart';
import 'package:instamfin/screens/settings/widgets/PrimaryFinanceWidget.dart';
import 'package:instamfin/screens/settings/widgets/UserProfileWidget.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/auth/auth_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:instamfin/app_localizations.dart';
import 'package:instamfin/services/controllers/user/user_service.dart';

class UserSetting extends StatefulWidget {
  @override
  _UserSettingState createState() => _UserSettingState();
}

class _UserSettingState extends State<UserSetting> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _pController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('profile_settings')),
        backgroundColor: CustomColors.mfinBlue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: CustomColors.mfinAlertRed.withOpacity(0.7),
        onPressed: () async {
          await forceDeactivate(context);
        },
        label: Text(
          "DeActivate Account",
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
              PrimaryFinanceWidget("Finance Details", true),
              UserProfileWidget(cachedLocalUser),
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
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.start,
          ),
          content: Container(
            height: 225,
            child: Column(
              children: <Widget>[
                Text(
                    "Deactivating account won't remove your Finance Data.\n\nIf you wish to clean all, Deactivate your finance first, please!"),
                Card(
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

                if (isValid) {
                  try {
                    await cachedLocalUser.updateByID({
                      'is_active': false,
                      'deactivated_at':
                          DateUtils.getUTCDateEpoch(DateTime.now())
                    }, cachedLocalUser.getID());
                    await AuthController().signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AuthPage(),
                        settings: RouteSettings(name: '/logout'),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  } catch (err) {
                    Navigator.pop(context);
                    _scaffoldKey.currentState.showSnackBar(
                      CustomSnackBar.errorSnackBar(
                        "Unable to deactivate your account now! Please try again later.",
                        3,
                      ),
                    );
                  }
                } else {
                  _pController.text = "";
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
