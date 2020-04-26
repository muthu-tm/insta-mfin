import 'package:flutter/material.dart';
import 'package:instamfin/db/models/branch.dart';
import 'package:instamfin/db/models/sub_branch.dart';
import 'package:instamfin/screens/settings/FinanceViewUser.dart';
import 'package:instamfin/screens/settings/add/AddAdminPage.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/IconButton.dart';

class SubBranchUsersWidget extends StatelessWidget {
  SubBranchUsersWidget(this.financeID, this.branch, this.subBranch);

  final String financeID;
  final Branch branch;
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
              style: TextStyle(color: CustomColors.mfinBlue),
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
                        branch.branchName,
                        subBranch.subBranchName),
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
                          ),
                        );
                      },
                      trailing: IconButton(
                        icon: Icon(
                          Icons.remove_circle,
                          size: 35.0,
                          color: CustomColors.mfinAlertRed,
                        ),
                        onPressed: () {},
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
