import 'package:flutter/material.dart';
import 'package:instamfin/db/models/account_preferences.dart';
import 'package:instamfin/db/models/chit_template.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/app/appBar.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/app/sideDrawer.dart';
import 'package:instamfin/screens/chit/widgets/ActiveChitWidget.dart';
import 'package:instamfin/screens/chit/widgets/ClosedChitWidget.dart';
import 'package:instamfin/screens/chit/widgets/PublishDialogWidget.dart';
import 'package:instamfin/screens/home/UserFinanceSetup.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class ChitHome extends StatefulWidget {
  @override
  _ChitHomeState createState() => _ChitHomeState();
}

class _ChitHomeState extends State<ChitHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AccountPreferences _accPref =
      UserController().getCurrentUser().accPreferences;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await UserController().refreshUser(false);
        return Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) => UserFinanceSetup(),
          ),
          (Route<dynamic> route) => false,
        );
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: openDrawer(context),
        appBar: topAppBar(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (_accPref.chitEnabled) {
              CustomDialogs.actionWaiting(context, "Loading...");
              List<ChitTemplate> temps =
                  await ChitTemplate().getAllChitTemplates();
              Navigator.pop(context);
              showDialog(
                context: context,
                routeSettings: RouteSettings(name: "/chit/publish/dialog"),
                builder: (context) {
                  return Center(
                    child: chitPublishDialog(context, temps),
                  );
                },
              );
            } else {
              _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
                  "Please Enable Chit Fund for this Fiannce in Settings -> Preferences!",
                  3));
            }
          },
          backgroundColor: CustomColors.mfinBlue,
          splashColor: CustomColors.mfinWhite,
          child: Icon(
            Icons.add,
            size: 30,
            color: CustomColors.mfinButtonGreen,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(padding: EdgeInsets.all(5)),
              ActiveChitWidget(),
              Padding(padding: EdgeInsets.all(5)),
              ClosedChitWidget(),
              Padding(padding: EdgeInsets.all(35)),
            ],
          ),
        ),
        bottomNavigationBar: bottomBar(context),
      ),
    );
  }
}
