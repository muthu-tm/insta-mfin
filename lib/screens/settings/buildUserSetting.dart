import 'package:flutter/material.dart';
import 'package:instamfin/screens/settings/UserProfileSetting.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/services/controllers/user/user_service.dart';

UserService _userService = locator<UserService>();

Widget buildUserSettingsWidget(String title, BuildContext context) {
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
              title,
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
                  MaterialPageRoute(builder: (context) => UserProfileSetting()),
                );
              },
            )),
        ListTile(
          title: TextFormField(
            keyboardType: TextInputType.text,
            initialValue: _userService.cachedUser.name,
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
            initialValue: _userService.cachedUser.mobileNumber.toString(),
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
            initialValue: _userService.cachedUser.password,
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
          title: TextFormField(
            keyboardType: TextInputType.text,
            initialValue: _userService.cachedUser.dateOfBirth,
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
            maxLines: 4,
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
