import 'package:flutter/material.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/settings/UserProfileSetting.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:provider/provider.dart';

Widget buildUserSettingsWidget(String title, BuildContext context) {
  return Card(
      color: CustomColors.mfinLightGrey,
      child: Consumer<User>(builder: (context, user, child) {
        return new Column(children: <Widget>[
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
                    MaterialPageRoute(
                        builder: (context) => UserProfileSetting(user: user)),
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
        ]);
      }));
}
