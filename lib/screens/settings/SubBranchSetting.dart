import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:instamfin/db/models/sub_branch.dart';
import 'package:instamfin/screens/settings/widgets/SubBranchProfileWidget.dart';
import 'package:instamfin/screens/settings/widgets/SubBranchUsersWidget.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class SubBranchSetting extends StatefulWidget {
  SubBranchSetting(this.financeID, this.branchName, this.subBranch);

  final String financeID;
  final String branchName;
  final SubBranch subBranch;

  @override
  _SubBranchSettingState createState() => _SubBranchSettingState();
}

class _SubBranchSettingState extends State<SubBranchSetting> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _pController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.subBranch.subBranchName),
        backgroundColor: CustomColors.mfinBlue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: CustomColors.mfinAlertRed.withOpacity(0.7),
        onPressed: () async {
          await forceDeactivate(context);
        },
        label: Text(
          "DeActivate SubBranch",
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SubBranchProfileWidget(
                widget.financeID, widget.branchName, widget.subBranch),
            SubBranchUsersWidget(_scaffoldKey, widget.financeID,
                widget.branchName, widget.subBranch),
            Padding(padding: EdgeInsets.only(top: 35, bottom: 35))
          ],
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
                    "Enter your Secret KEY! \n Deactivating your SubBranch, Please Confirm!"),
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
                    SubBranch subBranch = await SubBranch().getSubBranchByName(
                        widget.financeID,
                        widget.branchName,
                        widget.subBranch.subBranchName);
                    if (subBranch != null) {
                      if (!subBranch.admins
                          .contains(UserController().getCurrentUserID())) {
                        Navigator.pop(context);
                        _scaffoldKey.currentState.showSnackBar(
                          CustomSnackBar.errorSnackBar(
                            "You are not admin for this SubBranch. You cannot DeActivate",
                            3,
                          ),
                        );
                        return;
                      }
                    } else {
                      Navigator.pop(context);
                      _scaffoldKey.currentState.showSnackBar(
                        CustomSnackBar.errorSnackBar(
                          "Unable to find your SubBranch now! Please try again later.",
                          3,
                        ),
                      );
                      return;
                    }

                    CustomDialogs.actionWaiting(context, "Deactivating..");
                    await subBranch.update(widget.financeID, widget.branchName,
                        widget.subBranch.subBranchName, {
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
                        "Unable to deactivate your SubBranch now! Please try again later.",
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
