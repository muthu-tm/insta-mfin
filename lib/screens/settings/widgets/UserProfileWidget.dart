import 'package:flutter/material.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/settings/editors/ChangeSecret.dart';
import 'package:instamfin/screens/settings/editors/EditUSerProfile.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:instamfin/app_localizations.dart';

class UserProfileWidget extends StatelessWidget {
  final UserController _uc = UserController();

  UserProfileWidget(this.user, [this.title = "Profile Details"]);

  final User user;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: CustomColors.mfinLightGrey,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(
              Icons.assignment_ind,
              size: 35.0,
              color: CustomColors.mfinFadedButtonGreen,
            ),
            title: Text(
              title,
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
                if (user.mobileNumber != _uc.getCurrentUser().mobileNumber) {
                  CustomDialogs.information(
                      context,
                      "Warning",
                      CustomColors.mfinAlertRed,
                      "You are not allowed to edit this user data!");
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditUserProfile(),
                      settings: RouteSettings(name: '/settings/user/edit'),
                    ),
                  );
                }
              },
            ),
          ),
          Divider(
            color: CustomColors.mfinButtonGreen,
          ),
          ListTile(
            leading: SizedBox(
              width: 95,
              child: Text(
                AppLocalizations.of(context).translate('name'),
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Georgia",
                    fontWeight: FontWeight.bold,
                    color: CustomColors.mfinGrey),
              ),
            ),
            title: TextFormField(
              initialValue: user.name,
              decoration: InputDecoration(
                fillColor: CustomColors.mfinWhite,
                filled: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: CustomColors.mfinGrey,
                )),
              ),
              readOnly: true,
            ),
          ),
          ListTile(
            leading: SizedBox(
              width: 95,
              child: Text(
                AppLocalizations.of(context).translate('contact_number'),
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Georgia",
                    fontWeight: FontWeight.bold,
                    color: CustomColors.mfinGrey),
              ),
            ),
            title: TextFormField(
              initialValue: user.mobileNumber.toString(),
              decoration: InputDecoration(
                fillColor: CustomColors.mfinLightGrey,
                filled: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 1.0, horizontal: 5.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: CustomColors.mfinGrey)),
              ),
              enabled: false,
              autofocus: false,
            ),
          ),
          (user.mobileNumber == _uc.getCurrentUser().mobileNumber)
              ? ListTile(
                  leading: SizedBox(
                    width: 95,
                    child: Text(
                      AppLocalizations.of(context).translate('password'),
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Georgia",
                          fontWeight: FontWeight.bold,
                          color: CustomColors.mfinGrey),
                    ),
                  ),
                  title: TextFormField(
                    initialValue: "****",
                    textAlign: TextAlign.start,
                    obscureText: true,
                    decoration: InputDecoration(
                      fillColor: CustomColors.mfinWhite,
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 1.0, horizontal: 5.0),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: CustomColors.mfinGrey)),
                    ),
                    readOnly: true,
                  ),
                  trailing: IconButton(
                    highlightColor: CustomColors.mfinAlertRed.withOpacity(0.5),
                    tooltip: AppLocalizations.of(context).translate('change_password'),
                    icon: Icon(
                      Icons.edit,
                      size: 25.0,
                      color: CustomColors.mfinAlertRed.withOpacity(0.7),
                    ),
                    onPressed: () {
                      if (user.mobileNumber ==
                          _uc.getCurrentUser().mobileNumber) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangeSecret(),
                            settings: RouteSettings(
                                name: '/settings/user/secret/edit'),
                          ),
                        );
                      }
                    },
                  ),
                )
              : Container(),
          ListTile(
            leading: SizedBox(
              width: 95,
              child: Text(
                AppLocalizations.of(context).translate('gender'),
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Georgia",
                    fontWeight: FontWeight.bold,
                    color: CustomColors.mfinGrey),
              ),
            ),
            title: TextFormField(
              initialValue: user.gender,
              decoration: InputDecoration(
                fillColor: CustomColors.mfinWhite,
                filled: true,
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 1.0, horizontal: 5.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: CustomColors.mfinGrey)),
              ),
              readOnly: true,
            ),
          ),
          ListTile(
            leading: SizedBox(
              width: 95,
              child: Text(
                AppLocalizations.of(context).translate('email'),
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Georgia",
                    fontWeight: FontWeight.bold,
                    color: CustomColors.mfinGrey),
              ),
            ),
            title: new TextFormField(
              initialValue: user.emailID,
              decoration: InputDecoration(
                fillColor: CustomColors.mfinWhite,
                filled: true,
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 1.0, horizontal: 5.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: CustomColors.mfinWhite)),
              ),
              readOnly: true,
            ),
          ),
          ListTile(
            leading: SizedBox(
              width: 95,
              child: Text(
                AppLocalizations.of(context).translate('dob'),
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Georgia",
                    fontWeight: FontWeight.bold,
                    color: CustomColors.mfinGrey),
              ),
            ),
            title: TextFormField(
              initialValue: user.dateOfBirth == null
                  ? ''
                  : DateUtils.formatDate(
                      DateTime.fromMillisecondsSinceEpoch(user.dateOfBirth)),
              decoration: InputDecoration(
                fillColor: CustomColors.mfinWhite,
                filled: true,
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 1.0, horizontal: 5.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: CustomColors.mfinGrey)),
                suffixIcon: Icon(
                  Icons.perm_contact_calendar,
                  size: 35,
                  color: CustomColors.mfinBlue,
                ),
              ),
              readOnly: true,
            ),
          ),
          ListTile(
            leading: SizedBox(
              width: 95,
              child: Text(
                AppLocalizations.of(context).translate('address'),
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Georgia",
                    fontWeight: FontWeight.bold,
                    color: CustomColors.mfinGrey),
              ),
            ),
            title: TextFormField(
              initialValue: user.address.toString(),
              maxLines: 5,
              decoration: InputDecoration(
                fillColor: CustomColors.mfinWhite,
                filled: true,
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 1.0, horizontal: 5.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: CustomColors.mfinGrey)),
              ),
              readOnly: true,
            ),
          )
        ],
      ),
    );
  }
}
