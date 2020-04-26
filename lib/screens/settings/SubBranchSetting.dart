import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:instamfin/db/models/sub_branch.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/settings/widgets/SubBranchProfileWidget.dart';
import 'package:instamfin/screens/settings/widgets/SubBranchUsersWidget.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class SubBranchSetting extends StatelessWidget {
  SubBranchSetting(this.financeID, this.branchName, this.subBranch);

  final String financeID;
  final String branchName;
  final SubBranch subBranch;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(subBranch.subBranchName),
        backgroundColor: CustomColors.mfinBlue,
      ),
      body: new Center(
        child: new SingleChildScrollView(
          child: new Container(
            height: MediaQuery.of(context).size.height * 1.30,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SubBranchProfileWidget(financeID, branchName, subBranch),
                SubBranchUsersWidget(financeID, branchName, subBranch),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: bottomBar(context),
    );
  }
}
