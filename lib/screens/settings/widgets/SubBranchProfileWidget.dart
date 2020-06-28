import 'package:flutter/material.dart';
import 'package:instamfin/db/models/sub_branch.dart';
import 'package:instamfin/screens/settings/editors/EditSubBranchProfile.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/date_utils.dart';

class SubBranchProfileWidget extends StatelessWidget {
  SubBranchProfileWidget(this.financeID, this.branchName, this.subBranch);

  final String financeID;
  final String branchName;
  final SubBranch subBranch;

  @override
  Widget build(BuildContext context) {
    return new Card(
      color: CustomColors.mfinLightGrey,
      child: new Column(
        children: <Widget>[
          ListTile(
            leading: Icon(
              Icons.view_headline,
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
                Icons.edit,
                size: 35.0,
                color: CustomColors.mfinBlue,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditSubBranchProfile(financeID, branchName, subBranch),
                    settings: RouteSettings(
                        name: '/settings/finance/branch/subbranch/edit'),
                  ),
                );
              },
            ),
          ),
          new Divider(
            color: CustomColors.mfinBlue,
            thickness: 1,
          ),
          ListTile(
            title: TextFormField(
              initialValue: subBranch.subBranchName,
              decoration: InputDecoration(
                hintText: 'SubBranch Name',
                fillColor: CustomColors.mfinWhite,
                filled: true,
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: CustomColors.mfinGrey)),
              ),
              readOnly: true,
            ),
          ),
          ListTile(
            title: TextFormField(
              initialValue: subBranch.dateOfRegistration != null
                  ? DateUtils.formatDate(DateTime.fromMillisecondsSinceEpoch(
                      subBranch.dateOfRegistration))
                  : "",
              decoration: InputDecoration(
                hintText: 'Registered Date',
                fillColor: CustomColors.mfinWhite,
                filled: true,
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: CustomColors.mfinGrey)),
                suffixIcon: Icon(
                  Icons.date_range,
                  size: 35,
                  color: CustomColors.mfinBlue,
                ),
              ),
              readOnly: true,
            ),
          ),
          ListTile(
            title: TextFormField(
              initialValue: subBranch.contactNumber,
              decoration: InputDecoration(
                hintText: 'Contact Number',
                fillColor: CustomColors.mfinWhite,
                filled: true,
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: CustomColors.mfinGrey)),
              ),
              readOnly: true,
            ),
          ),
          ListTile(
            title: new TextFormField(
              initialValue: subBranch.emailID,
              decoration: InputDecoration(
                hintText: 'SubBranch EmailID',
                fillColor: CustomColors.mfinWhite,
                filled: true,
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: CustomColors.mfinWhite)),
              ),
              readOnly: true,
            ),
          ),
          ListTile(
            title: TextFormField(
              initialValue: subBranch.address.toString(),
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'SubBranch Address',
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                fillColor: CustomColors.mfinWhite,
                filled: true,
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: CustomColors.mfinGrey)),
              ),
              readOnly: true,
            ),
          ),
        ],
      ),
    );
  }
}
