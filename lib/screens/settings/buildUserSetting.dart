import 'package:flutter/material.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/settings/UserProfileSetting.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

Future<Map<String, dynamic>> _user =
    User(userState.mobileNumber).getByID(userState.mobileNumber.toString());

Widget buildUserSettingsWidget(String title, BuildContext context) {
  return FutureBuilder<Map<String, dynamic>>(
    future: _user, // a previously-obtained Future<Map<String, dynamic>> or null
    builder:
        (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
      List<Widget> children;

      if (snapshot.hasData) {
        children = <Widget>[
          ListTile(
            title: TextFormField(
              keyboardType: TextInputType.text,
              initialValue: snapshot.data['user_name'],
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
              initialValue: snapshot.data['mobile_number'].toString(),
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
              initialValue: snapshot.data['password'],
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
              initialValue: snapshot.data['dateOfBirth'],
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
        ];
      } else if (snapshot.hasError) {
        children = <Widget>[
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text('Error: ${snapshot.error}'),
          )
        ];
      } else {
        children = <Widget>[
          SizedBox(
            child: CircularProgressIndicator(),
            width: 60,
            height: 60,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text('Awaiting result...'),
          )
        ];
      }

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
                        MaterialPageRoute(
                            builder: (context) =>
                                UserProfileSetting()),
                      );
                    },
                  )),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: children,
                ),
              ),
            ]));
        });
}
