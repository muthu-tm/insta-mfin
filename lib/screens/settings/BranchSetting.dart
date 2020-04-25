import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:instamfin/db/models/branch.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/settings/widgets/BranchProfileWidget.dart';
import 'package:instamfin/screens/settings/widgets/BranchUsersWidget.dart';
import 'package:instamfin/screens/settings/widgets/SubBranchesWidget.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class BranchSetting extends StatelessWidget {
  BranchSetting(this.financeID, this.branch);

  final String financeID;
  final Branch branch;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: CustomColors.mfinGrey,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Branch Settings'),
        backgroundColor: CustomColors.mfinBlue,
      ),
      body: new Center(
        child: new SingleChildScrollView(
          child: new Container(
            height: MediaQuery.of(context).size.height * 1.30,
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  
                  BranchProfileWidget(branch),
                  SubBranchesWidget(financeID, branch.branchName),
                  BranchUsersWidget(financeID, branch),
                ]),
          ),
        ),
      ),
      bottomSheet: bottomBar(context),
    );
  }
}
