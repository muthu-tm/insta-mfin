import 'package:flutter/material.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/settings/EditUSerProfile.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class UserProfileWidget extends StatelessWidget {
  UserProfileWidget(this.user);

  final User user;

  @override
  Widget build(BuildContext context) {
  return Card(
      color: CustomColors.mfinLightGrey,
      child: new Column(children: <Widget>[
        ListTile(
            leading: Icon(
              Icons.menu,
              size: 30,
              color: CustomColors.mfinFadedButtonGreen,
            ),
            title: new Text(
              "Profile Settings",
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
                  MaterialPageRoute(builder: (context) => EditUserProfile()),
                );
              },
            )),
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