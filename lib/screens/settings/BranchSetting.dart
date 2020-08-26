import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:instamfin/db/models/branch.dart';
import 'package:instamfin/screens/settings/widgets/BranchProfileWidget.dart';
import 'package:instamfin/screens/settings/widgets/BranchUsersWidget.dart';
import 'package:instamfin/screens/settings/widgets/SubBranchesWidget.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:instamfin/services/controllers/user/user_service.dart';

class BranchSetting extends StatefulWidget {
  BranchSetting(this.financeID, this.branchName);

  final String financeID;
  final String branchName;
  @override
  _BranchSettingState createState() => _BranchSettingState();
}

class _BranchSettingState extends State<BranchSetting> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _pController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Branch branch = Branch();

    return StreamBuilder<DocumentSnapshot>(
      stream: branch
          .getDocumentReference(widget.financeID, widget.branchName)
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        Widget body;

        if (snapshot.hasData) {
          branch = Branch.fromJson(snapshot.data.data);
          body = SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  BranchProfileWidget(widget.financeID, branch),
                  SubBranchesWidget(widget.financeID, branch.branchName),
                  BranchUsersWidget(_scaffoldKey, widget.financeID, branch),
                  Padding(padding: EdgeInsets.only(top: 35, bottom: 35))
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          body = Container(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width * 1.0,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: AsyncWidgets.asyncError(),
              ),
            ),
          );
        } else {
          body = Container(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width * 1.0,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: AsyncWidgets.asyncWaiting(),
              ),
            ),
          );
        }

        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(widget.branchName),
            backgroundColor: CustomColors.mfinBlue,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: CustomColors.mfinAlertRed.withOpacity(0.7),
            onPressed: () async {
              await forceDeactivate(context);
            },
            label: Text(
              "DeActivate Branch",
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
          body: body,
        );
      },
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
            height: 200,
            child: Column(
              children: <Widget>[
                Text(
                    "Deactivating your Branch will deactivate all your SubBranches too.\nPlease Confirm with your Secret KEY!"),
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
                _pController.text = "";

                if (isValid) {
                  try {
                    Branch branch = await Branch()
                        .getBranchByName(widget.financeID, widget.branchName);
                    if (branch != null) {
                      if (!branch.admins.contains(cachedLocalUser.getIntID())) {
                        Navigator.pop(context);
                        _scaffoldKey.currentState.showSnackBar(
                          CustomSnackBar.errorSnackBar(
                            "You are not admin for this Branch. You cannot DeActivate",
                            3,
                          ),
                        );
                        return;
                      }
                    } else {
                      Navigator.pop(context);
                      _scaffoldKey.currentState.showSnackBar(
                        CustomSnackBar.errorSnackBar(
                          "Unable to find your Branch now! Please try again later.",
                          3,
                        ),
                      );
                      return;
                    }

                    CustomDialogs.actionWaiting(context, "Deactivating..");

                    await branch.update(widget.financeID, widget.branchName, {
                      'is_active': false,
                      'deactivated_at':
                          DateUtils.getUTCDateEpoch(DateTime.now())
                    });
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  } catch (err) {
                    Navigator.pop(context);
                    _scaffoldKey.currentState.showSnackBar(
                      CustomSnackBar.errorSnackBar(
                        "Unable to deactivate your Branch now! Please try again later.",
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
