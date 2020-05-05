import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:instamfin/db/models/sub_branch.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/settings/widgets/SubBranchProfileWidget.dart';
import 'package:instamfin/screens/settings/widgets/SubBranchUsersWidget.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class SubBranchSetting extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  SubBranchSetting(this.financeID, this.branchName, this.subBranch);

  final String financeID;
  final String branchName;
  final SubBranch subBranch;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(subBranch.subBranchName),
        backgroundColor: CustomColors.mfinBlue,
      ),
      body: new Center(
        child: new SingleChildScrollView(
          child: new Container(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SubBranchProfileWidget(_scaffoldKey, financeID, branchName, subBranch),
                SubBranchUsersWidget(_scaffoldKey, financeID, branchName, subBranch),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: bottomBar(context),
    );
  }
}
