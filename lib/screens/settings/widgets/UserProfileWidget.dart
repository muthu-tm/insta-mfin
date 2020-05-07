import 'package:flutter/material.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/settings/editors/EditUSerProfile.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class UserProfileWidget extends StatelessWidget {
  final UserController _uc = UserController();

  UserProfileWidget(this.user, [this.title = "Profile Settings"]);

  final User user;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: CustomColors.mfinLightGrey,
      child: new Column(
        children: <Widget>[
          ListTile(
            leading: Icon(
              Icons.assignment_ind,
              size: 35.0,
              color: CustomColors.mfinFadedButtonGreen,
            ),
            title: new Text(
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
                  CustomDialogs.information(context, "Warning",
                      "You are not allowed to edit this user data!");
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditUserProfile()),
                  );
                }
              },
            ),
          ),
          new Divider(
            color: CustomColors.mfinButtonGreen,
          ),
          ListTile(
            leading: SizedBox(
              width: 90,
              child: Text(
                "NAME",
                style: TextStyle(
                    fontSize: 15,
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
                    new EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: CustomColors.mfinGrey,
                )),
              ),
              enabled: false,
              autofocus: false,
            ),
          ),
          ListTile(
            leading: SizedBox(
              width: 90,
              child: Text(
                "CONTACT",
                style: TextStyle(
                    fontSize: 15,
                    fontFamily: "Georgia",
                    fontWeight: FontWeight.bold,
                    color: CustomColors.mfinGrey),
              ),
            ),
            title: TextFormField(
              initialValue: user.mobileNumber.toString(),
              decoration: InputDecoration(
                fillColor: CustomColors.mfinWhite,
                filled: true,
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: CustomColors.mfinGrey)),
              ),
              enabled: false,
              autofocus: false,
            ),
          ),
          ListTile(
            leading: SizedBox(
              width: 90,
              child: Text(
                "PASSWORD",
                style: TextStyle(
                    fontSize: 15,
                    fontFamily: "Georgia",
                    fontWeight: FontWeight.bold,
                    color: CustomColors.mfinGrey),
              ),
            ),
            title: TextFormField(
              initialValue: user.password,
              obscureText: true,
              decoration: InputDecoration(
                fillColor: CustomColors.mfinWhite,
                filled: true,
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: CustomColors.mfinGrey)),
              ),
              enabled: false,
              autofocus: false,
            ),
          ),
          ListTile(
            leading: SizedBox(
              width: 90,
              child: Text(
                "GENDER",
                style: TextStyle(
                    fontSize: 15,
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
                    new EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: CustomColors.mfinGrey)),
              ),
              enabled: false,
              autofocus: false,
            ),
          ),
          ListTile(
            leading: SizedBox(
              width: 90,
              child: Text(
                "EMAILID",
                style: TextStyle(
                    fontSize: 15,
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
                    new EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: CustomColors.mfinWhite)),
              ),
              enabled: false,
              autofocus: false,
            ),
          ),
          ListTile(
            leading: SizedBox(
              width: 90,
              child: Text(
                "DOB",
                style: TextStyle(
                    fontSize: 15,
                    fontFamily: "Georgia",
                    fontWeight: FontWeight.bold,
                    color: CustomColors.mfinGrey),
              ),
            ),
            title: TextFormField(
              initialValue: user.dateOfBirth,
              decoration: InputDecoration(
                fillColor: CustomColors.mfinWhite,
                filled: true,
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: CustomColors.mfinGrey)),
              ),
              enabled: false,
              autofocus: false,
            ),
          ),
          ListTile(
            leading: SizedBox(
              width: 90,
              child: Text(
                "ADDRESS",
                style: TextStyle(
                    fontSize: 15,
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
                    new EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: CustomColors.mfinGrey)),
              ),
              enabled: false,
              autofocus: false,
            ),
          )
        ],
      ),
    );
  }
}
