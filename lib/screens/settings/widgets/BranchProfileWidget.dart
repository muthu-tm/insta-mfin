import 'package:flutter/material.dart';
import 'package:instamfin/db/models/branch.dart';
import 'package:instamfin/screens/settings/editors/EditBranchProfile.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/app_localizations.dart';

class BranchProfileWidget extends StatelessWidget {
  BranchProfileWidget(this.financeID, this.branch);

  final String financeID;
  final Branch branch;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: CustomColors.mfinLightGrey,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(
              Icons.view_stream,
              size: 35.0,
              color: CustomColors.mfinButtonGreen,
            ),
            title: Text(
              AppLocalizations.of(context).translate('branch_details'),
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
                    builder: (context) => EditBranchProfile(financeID, branch),
                    settings:
                        RouteSettings(name: '/settings/finance/branch/edit'),
                  ),
                );
              },
            ),
          ),
          Divider(
            color: CustomColors.mfinBlue,
            thickness: 1,
          ),
          ListTile(
            title: TextFormField(
              initialValue: branch.branchName,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context).translate('branch_name'),
                fillColor: CustomColors.mfinLightGrey,
                filled: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: CustomColors.mfinGrey)),
              ),
              readOnly: true,
            ),
          ),
          ListTile(
            title: TextFormField(
              initialValue: branch.dateOfRegistration != null
                  ? DateUtils.formatDate(DateTime.fromMillisecondsSinceEpoch(
                      branch.dateOfRegistration))
                  : "",
              decoration: InputDecoration(
                hintText:
                    AppLocalizations.of(context).translate('registered_date'),
                fillColor: CustomColors.mfinWhite,
                filled: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
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
              initialValue: branch.contactNumber,
              decoration: InputDecoration(
                hintText:
                    AppLocalizations.of(context).translate('contact_number'),
                fillColor: CustomColors.mfinWhite,
                filled: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: CustomColors.mfinGrey)),
              ),
              readOnly: true,
            ),
          ),
          ListTile(
            title: TextFormField(
              initialValue: branch.emailID,
              decoration: InputDecoration(
                hintText:
                    AppLocalizations.of(context).translate('branch_emailid'),
                fillColor: CustomColors.mfinWhite,
                filled: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: CustomColors.mfinWhite)),
              ),
              readOnly: true,
            ),
          ),
          ListTile(
            title: TextFormField(
              initialValue: branch.address.toString(),
              maxLines: 4,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context).translate('address'),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
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
