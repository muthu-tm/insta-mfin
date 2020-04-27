import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/db/models/sub_branch.dart';
import 'package:instamfin/screens/settings/SubBranchSetting.dart';
import 'package:instamfin/screens/settings/add/AddNewSubBranch.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/IconButton.dart';

class SubBranchesWidget extends StatelessWidget {
  SubBranchesWidget(this.financeID, this.branchName);

  final String financeID;
  final String branchName;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: SubBranch()
          .getSubBranchCollectionRef(financeID, branchName)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          if (snapshot.data.documents.isNotEmpty) {
            children = <Widget>[
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: TextFormField(
                      keyboardType: TextInputType.text,
                      initialValue: snapshot
                          .data.documents[index].data['sub_branch_name'],
                      decoration: InputDecoration(
                        fillColor: CustomColors.mfinWhite,
                        filled: true,
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 5.0),
                        suffixIcon: customIconButton(Icons.navigate_next, 35.0,
                            CustomColors.mfinBlue, null),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: CustomColors.mfinGrey)),
                      ),
                      enabled: false,
                      autofocus: false,
                    ),
                    onTap: () {
                      SubBranch subBranch = SubBranch.fromJson(
                          snapshot.data.documents[index].data);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SubBranchSetting(
                            financeID,
                            branchName,
                            subBranch,
                          ),
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
            ];
          } else {
            // No branches available
            children = [
              Container(
                height: 60,
                child: Column(
                  children: <Widget>[
                    Text(
                      "No Branches yet!",
                      style: TextStyle(
                        color: CustomColors.mfinAlertRed,
                        fontSize: 18.0,
                      ),
                    ),
                    new Spacer(),
                    Text(
                      "Expand you Finance by creating new Branch!",
                      style: TextStyle(
                        color: CustomColors.mfinBlue,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ];
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
                          builder: (context) =>
                              AddSubBranch(financeID, branchName)),
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
                  children: children,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
