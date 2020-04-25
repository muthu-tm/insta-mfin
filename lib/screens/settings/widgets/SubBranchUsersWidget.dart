import 'package:flutter/material.dart';
import 'package:instamfin/db/models/branch.dart';
import 'package:instamfin/db/models/sub_branch.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/IconButton.dart';

class BranchUsersWidget extends StatelessWidget {
  BranchUsersWidget(this.financeID, this.branch, this.subBranch);

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
                size: 30,
                color: CustomColors.mfinButtonGreen,
              ),
              title: new Text(
                "User Details",
                style: TextStyle(color: CustomColors.mfinBlue),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.add_box,
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
              children: <Widget>[
                ListView.builder(
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
                          trailing: IconButton(
                            icon: Icon(
                              Icons.remove_circle,
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
