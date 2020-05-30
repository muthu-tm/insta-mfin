import 'package:flutter/material.dart';
import 'package:instamfin/db/models/sub_branch.dart';
import 'package:instamfin/screens/settings/FinanceViewUser.dart';
import 'package:instamfin/screens/settings/add/AddAdminPage.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/IconButton.dart';
import 'package:instamfin/services/controllers/finance/branch_controller.dart';
import 'package:instamfin/services/controllers/finance/sub_branch_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class SubBranchUsersWidget extends StatelessWidget {
  SubBranchUsersWidget(
      this._scaffoldKey, this.financeID, this.branchName, this.subBranch);

  final GlobalKey<ScaffoldState> _scaffoldKey;
  final String financeID;
  final String branchName;
  final SubBranch subBranch;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: CustomColors.mfinLightGrey,
      child: new Column(
        children: <Widget>[
          ListTile(
            leading: Icon(
              Icons.person,
              size: 35.0,
              color: CustomColors.mfinButtonGreen,
            ),
            title: new Text(
              "User Details",
              style: TextStyle(
                color: CustomColors.mfinBlue,
                fontSize: 18.0,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.add_box,
                size: 35.0,
                color: CustomColors.mfinBlue,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddAdminPage(
                        'Add Admin - ${subBranch.subBranchName}',
                        subBranch.subBranchName,
                        financeID,
                        branchName,
                        subBranch.subBranchName),
                    settings: RouteSettings(
                        name: '/settings/finance/branch/subbranch/admin/add'),
                  ),
                );
              },
            ),
          ),
          new Divider(
            color: CustomColors.mfinBlue,
            thickness: 1,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: subBranch.admins.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: TextFormField(
                        keyboardType: TextInputType.text,
                        initialValue: subBranch.admins[index].toString(),
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                FinanceUser(subBranch.admins[index].toString()),
                            settings: RouteSettings(
                                name:
                                    '/settings/finance/branch/subbranch/admin'),
                          ),
                        );
                      },
                      trailing: IconButton(
                        icon: Icon(
                          Icons.remove_circle,
                          size: 35.0,
                          color: CustomColors.mfinAlertRed,
                        ),
                        onPressed: () {
                          int userID = subBranch.admins[index];
                          UserController _uc = UserController();
                          if (userID == _uc.getCurrentUserID()) {
                            CustomDialogs.information(
                                context,
                                "Warning",
                                CustomColors.mfinAlertRed,
                                "You cannot remove yourself");
                          } else {
                            String subBranchName = subBranch.subBranchName;
                            CustomDialogs.confirm(
                              context,
                              "Confirm",
                              "Are you sure to remove $userID from $subBranchName",
                              () async {
                                SubBranchController _sbc =
                                    SubBranchController();
                                try {
                                  await _sbc.updateSubBranchAdmins(
                                    false,
                                    [userID],
                                    financeID,
                                    branchName,
                                    subBranchName,
                                  );

                                  List<SubBranch> sbList =
                                      await _sbc.getSubBranchesForUserID(
                                          financeID, branchName, userID);
                                  if (sbList != null && sbList.length == 0) {
                                    BranchController _bc = BranchController();
                                    await _bc.updateBranchUsers(
                                        false, [userID], financeID, branchName);
                                  }
                                } catch (err) {
                                  print(
                                    "Error while removing $userID from $subBranchName" +
                                        err.toString(),
                                  );
                                  _scaffoldKey.currentState.showSnackBar(
                                    CustomSnackBar.errorSnackBar(
                                        "Error while removing $userID from $subBranchName",
                                        3),
                                  );
                                }

                                Navigator.pop(context);
                              },
                              () {
                                Navigator.pop(context);
                              },
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
