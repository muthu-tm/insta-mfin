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
        child: new Column(children: <Widget>[
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
          ListTile(
            title: TextFormField(
              keyboardType: TextInputType.text,
              initialValue: user.name,
              decoration: InputDecoration(
                hintText: 'User_name',
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
            title: TextFormField(
              keyboardType: TextInputType.text,
              initialValue: user.mobileNumber.toString(),
              decoration: InputDecoration(
                hintText: 'Mobile_Number',
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
            title: TextFormField(
              keyboardType: TextInputType.text,
              initialValue: user.password,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
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
            title: TextFormField(
              keyboardType: TextInputType.text,
              initialValue: user.gender,
              decoration: InputDecoration(
                hintText: 'Gender',
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
            title: new TextFormField(
              keyboardType: TextInputType.text,
              initialValue: user.emailID,
              decoration: InputDecoration(
                hintText: 'Enter your EmailID',
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
            title: TextFormField(
              keyboardType: TextInputType.text,
              initialValue: user.dateOfBirth,
              decoration: InputDecoration(
                hintText: 'Date_Of_Birth',
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
            title: TextFormField(
              keyboardType: TextInputType.text,
              initialValue: user.address.toString(),
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Address',
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
        ]));
  }
}
