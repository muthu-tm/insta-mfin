import 'package:flutter/material.dart';
import 'package:instamfin/screens/app/appBar.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/app/sideDrawer.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomTextFormField.dart';

class CompanyProfileSetting extends StatefulWidget {
  const CompanyProfileSetting({this.toggleView});

  final Function toggleView;

  @override
  _CompanyProfileSettingState createState() => _CompanyProfileSettingState();
}

class _CompanyProfileSettingState extends State<CompanyProfileSetting> {
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
                backgroundImage: AssetImage('images/protocoder.png'),
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
              customTextFormField('Registered ID', CustomColors.mfinGrey,
                  Icons.navigate_next, TextInputType.text),
              customTextFormField('Contact Number', CustomColors.mfinGrey,
                  Icons.navigate_next, TextInputType.number),
              customTextFormField('Email', CustomColors.mfinGrey,
                  Icons.navigate_next, TextInputType.emailAddress),
              customTextFormField('Date of Registration', CustomColors.mfinGrey,
                  Icons.navigate_next, TextInputType.datetime),
              customTextFormField('Next Renewal Date', CustomColors.mfinGrey,
                  Icons.navigate_next, TextInputType.datetime),
              customTextFormField('Number of Lines/Area', CustomColors.mfinGrey,
                  Icons.navigate_next, TextInputType.text),
              customTextFormField('Office Address', CustomColors.mfinGrey,
                  Icons.navigate_next, TextInputType.text),
              customTextFormField('Customize App Appearence', CustomColors.mfinGrey,
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
