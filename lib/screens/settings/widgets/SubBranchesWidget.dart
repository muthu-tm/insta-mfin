import 'package:flutter/material.dart';
import 'package:instamfin/db/models/branch.dart';
import 'package:instamfin/db/models/sub_branch.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/IconButton.dart';
import 'package:instamfin/services/controllers/finance/branch_controller.dart';

class SubBranchesWidget extends StatelessWidget {
  final BranchController _branchController = BranchController();

  SubBranchesWidget(this.financeID, this.branch);

  final String financeID;
  final Branch branch;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SubBranch>>(
        future:
            _branchController.getAllSubBranches(financeID, branch.branchName),
        builder:
            (BuildContext context, AsyncSnapshot<List<SubBranch>> snapshot) {
          List<Widget> children;

          if (snapshot.hasData) {
            if (snapshot.data.length != 0) {
              children = <Widget>[
                ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                          title: TextFormField(
                            keyboardType: TextInputType.text,
                            initialValue: snapshot.data[index].subBranchName,
                            decoration: InputDecoration(
                              fillColor: CustomColors.mfinWhite,
                              filled: true,
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 5.0),
                              suffixIcon: customIconButton(Icons.navigate_next,
                                  35.0, CustomColors.mfinBlue, null),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: CustomColors.mfinGrey)),
                            ),
                            enabled: false,
                            autofocus: false,
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.remove_circle,
                              size: 35.0,
                              color: CustomColors.mfinAlertRed,
                            ),
                            onPressed: () {},
                          ));
                    }),
              ];
            } else {
              // No sub branches for this branch
            }
          } else if (snapshot.hasError) {
            children = AsyncWidgets.asyncError();
          } else {
            children = AsyncWidgets.asyncWaiting();
          }

          return Card(
            color: CustomColors.mfinLightGrey,
            child: new Column(
              children: <Widget>[
                ListTile(
                    leading: Icon(
                      Icons.menu,
                      size: 35.0,
                      color: CustomColors.mfinButtonGreen,
                    ),
                    title: new Text(
                      "Sub Branch Details",
                      style: TextStyle(color: CustomColors.mfinBlue),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.add_box,
                        size: 35.0,
                        color: CustomColors.mfinBlue,
                      ),
                      onPressed: () {},
                    )),
                new Divider(
                  color: CustomColors.mfinBlue,
                  thickness: 1,
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: children,
                  ),
                ),
              ],
            ),
          );
        });
  }
}
