import 'package:flutter/material.dart';
import 'package:instamfin/db/models/branch.dart';
import 'package:instamfin/screens/settings/FinanceViewUser.dart';
import 'package:instamfin/screens/settings/add/AddAdminPage.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/IconButton.dart';
import 'package:instamfin/services/controllers/finance/branch_controller.dart';
import 'package:instamfin/services/controllers/finance/finance_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class BranchUsersWidget extends StatelessWidget {
  BranchUsersWidget(this._scaffoldKey, this.financeID, this.branch);

  final GlobalKey<ScaffoldState> _scaffoldKey;
  final String financeID;
  final Branch branch;

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
                        'Add Admin - ${branch.branchName}',
                        branch.branchName,
                        financeID,
                        branch.branchName),
                    settings: RouteSettings(
                        name: '/settings/finance/branch/admin/add'),
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
                  itemCount: branch.admins.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: TextFormField(
                        keyboardType: TextInputType.text,
                        initialValue: branch.admins[index].toString(),
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
                                FinanceUser(branch.admins[index].toString()),
                            settings: RouteSettings(
                                name: '/settings/finance/branch/admin'),
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
                          int userID = branch.admins[index];
                          UserController _uc = UserController();
                          if (userID == _uc.getCurrentUserID()) {
                            CustomDialogs.information(
                                context,
                                "Warning",
                                CustomColors.mfinAlertRed,
                                "You cannot remove yourself");
                          } else {
                            CustomDialogs.confirm(
                              context,
                              "Confirm",
                              "Are you sure to remove $userID from ${branch.branchName}",
                              () async {
                                String branchName = branch.branchName;
                                BranchController _bc = BranchController();
                                try {
                                  await _bc.updateBranchAdmins(
                                      false, [userID], financeID, branchName);

                                  List<Branch> _bList = await _bc
                                      .getBranchesForUserID(financeID, userID);
                                  if (_bList != null && _bList.length == 0) {
                                    FinanceController _fc = FinanceController();
                                    await _fc.updateFinanceUsers(
                                        false, [userID], financeID);
                                  }
                                } catch (err) {
                                  print(
                                    "Error while removing $userID from $branchName" +
                                        err.toString(),
                                  );
                                  _scaffoldKey.currentState.showSnackBar(
                                    CustomSnackBar.errorSnackBar(
                                        "Error while removing $userID from $branchName",
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
