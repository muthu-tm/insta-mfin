import 'package:flutter/material.dart';
import 'package:instamfin/db/models/branch.dart';
import 'package:instamfin/db/models/sub_branch.dart';
import 'package:instamfin/screens/settings/editors/EditBranchProfile.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class SubBranchProfileWidget extends StatelessWidget {
  SubBranchProfileWidget(this.financeID, this.branch, this.subBranch);

  final String financeID;
  final Branch branch;
  final SubBranch subBranch;

  @override
  Widget build(BuildContext context) {
    return new Card(
      color: CustomColors.mfinLightGrey,
      child: new Column(
        children: <Widget>[
          ListTile(
              leading: Icon(
                Icons.view_list,
                size: 30,
              ),
              title: new Text(
                "Sub Branch Details",
                style: TextStyle(color: CustomColors.mfinBlue),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.edit,
                  color: CustomColors.mfinBlue,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditBranchProfile()),
                  );
                },
              )),
          ListTile(
            title: TextFormField(
              keyboardType: TextInputType.text,
              initialValue: subBranch.subBranchName,
              decoration: InputDecoration(
                hintText: 'Sub Branch Name',
                fillColor: CustomColors.mfinWhite,
                filled: true,
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: CustomColors.mfinGrey)),
              ),
              enabled: false,
              autofocus: false,
            ),
          ),
          ListTile(
            title: TextFormField(
              keyboardType: TextInputType.text,
              initialValue: subBranch.dateOfRegistration,
              decoration: InputDecoration(
                hintText: 'Registered Date',
                fillColor: CustomColors.mfinWhite,
                filled: true,
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: CustomColors.mfinGrey)),
              ),
              enabled: false,
              autofocus: false,
            ),
          ),
          ListTile(
            title: TextFormField(
              keyboardType: TextInputType.text,
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
              enabled: false,
              autofocus: false,
            ),
          ),
          ListTile(
            title: new TextFormField(
              keyboardType: TextInputType.text,
              initialValue: subBranch.emails.toString(),
              decoration: InputDecoration(
                hintText: 'SubBranch EmailID',
                fillColor: CustomColors.mfinWhite,
                filled: true,
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: CustomColors.mfinWhite)),
              ),
              enabled: false,
              autofocus: false,
            ),
          ),
          ListTile(
            title: TextFormField(
              keyboardType: TextInputType.text,
              initialValue: subBranch.address.toString(),
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'SubBranch Address',
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                fillColor: CustomColors.mfinWhite,
                filled: true,
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: CustomColors.mfinGrey)),
              ),
              enabled: false,
              autofocus: false,
            ),
          ),
        ],
      ),
    );
  }
}
