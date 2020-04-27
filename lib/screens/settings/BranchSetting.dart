import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:instamfin/db/models/branch.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/settings/widgets/BranchProfileWidget.dart';
import 'package:instamfin/screens/settings/widgets/BranchUsersWidget.dart';
import 'package:instamfin/screens/settings/widgets/SubBranchesWidget.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class BranchSetting extends StatelessWidget {
  BranchSetting(this.financeID, this.branchName);

  final String financeID;
  final String branchName;

  @override
  Widget build(BuildContext context) {
    Branch branch = Branch();

    return StreamBuilder<DocumentSnapshot>(
      stream: branch.getDocumentReference(financeID, branchName).snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        Widget body;

        if (snapshot.hasData) {
          branch = Branch.fromJson(snapshot.data.data);
          body = new Center(
            child: new SingleChildScrollView(
              child: new Container(
                height: MediaQuery.of(context).size.height * 1.30,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    BranchProfileWidget(financeID, branch),
                    SubBranchesWidget(financeID, branch.branchName),
                    BranchUsersWidget(financeID, branch),
                  ],
                ),
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

        return new Scaffold(
          appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text(branchName),
            backgroundColor: CustomColors.mfinBlue,
          ),
          body: body,
          bottomSheet: bottomBar(context),
        );
      },
    );
  }
}
