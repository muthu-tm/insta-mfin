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
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(subBranch.subBranchName),
        backgroundColor: CustomColors.mfinBlue,
      ),
      body: SingleChildScrollView(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SubBranchProfileWidget(financeID, branchName, subBranch),
            SubBranchUsersWidget(
                _scaffoldKey, financeID, branchName, subBranch),
          ],
        ),
      ),
      bottomNavigationBar: bottomBar(context),
    );
  }
}
