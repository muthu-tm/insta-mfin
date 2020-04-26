import 'package:flutter/material.dart';
import 'package:instamfin/db/models/branch.dart';
import 'package:instamfin/screens/settings/editors/EditBranchProfile.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class BranchProfileWidget extends StatelessWidget {
  BranchProfileWidget(this.branch);

  final Branch branch;

  @override
  Widget build(BuildContext context) {
    return new Card(
      color: CustomColors.mfinLightGrey,
      child: new Column(
        children: <Widget>[
          ListTile(
            leading: Icon(
              Icons.view_stream,
              size: 35.0,
              color: CustomColors.mfinButtonGreen,
            ),
            title: new Text(
              "Branch Details",
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
                  MaterialPageRoute(builder: (context) => EditBranchProfile()),
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
              keyboardType: TextInputType.text,
              initialValue: branch.branchName,
              decoration: InputDecoration(
                hintText: 'Branch Name',
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
              initialValue: branch.dateOfRegistration,
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
              initialValue: branch.contactNumber,
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
              initialValue: branch.emailID,
              decoration: InputDecoration(
                hintText: 'Branch EmailID',
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
              initialValue: branch.address.toString(),
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Address',
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
