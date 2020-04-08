import 'package:flutter/material.dart';
import 'package:instamfin/screens/app/appBar.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/app/sideDrawer.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomTextFormField.dart';
import 'package:instamfin/screens/utils/utils.dart';

class UserProfileSetting extends StatefulWidget {
  @override
  _UserProfileSettingState createState() => _UserProfileSettingState();
}

class _UserProfileSettingState extends State<UserProfileSetting> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: topAppBar(context),
      drawer: openDrawer(context),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 30,
                backgroundImage: Utils.getUserDisplayImage(),
              ),
              Text(
                'Vale Muthu',
                style: TextStyle(
                  fontFamily: 'SourceSansPro',
                  fontSize: 25,
                ),
              ),
              Text(
                'A&E Specialties',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'SourceSansPro',
                  color: CustomColors.mfinAlertRed,
                  letterSpacing: 2.5,
                ),
              ),
              customTextFormField('Mobile Number', CustomColors.mfinGrey,
                  Icons.navigate_next, TextInputType.text),
              customTextFormField('Email', CustomColors.mfinGrey,
                  Icons.navigate_next, TextInputType.emailAddress),
              customTextFormField('Date of Birth', CustomColors.mfinGrey,
                  Icons.navigate_next, TextInputType.datetime),
              customTextFormField('Date of Join', CustomColors.mfinGrey,
                  Icons.navigate_next, TextInputType.datetime),
              customTextFormField('Office Address', CustomColors.mfinGrey,
                  Icons.navigate_next, TextInputType.text),
              customTextFormField('Refer & Earn', CustomColors.mfinGrey,
                  Icons.notifications, TextInputType.text),
            ],
          ),
        ),
      ),
      bottomSheet: bottomBar(context),
    );
  }
}
