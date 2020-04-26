import 'package:flutter/material.dart';
import 'package:instamfin/db/models/branch.dart';
import 'package:instamfin/screens/settings/FinanceViewUser.dart';
import 'package:instamfin/screens/settings/add/AddAdminPage.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/IconButton.dart';

class BranchUsersWidget extends StatelessWidget {
  BranchUsersWidget(this.financeID, this.branch);

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
                    ),
                  );
                },
              )),
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
                                  builder: (context) => FinanceUser(
                                      branch.admins[index].toString()),
                                ));
                          },
                          trailing: IconButton(
                            icon: Icon(
                              Icons.remove_circle,
                              size: 35.0,
                              color: CustomColors.mfinAlertRed,
                            ),
                            onPressed: () {},
                          ));
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
