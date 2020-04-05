import 'package:flutter/material.dart';
import 'package:instamfin/screens/app/appBar.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/app/sideDrawer.dart';
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
      appBar: topAppBar(),
      drawer: openDrawer(context),
      //hit Ctrl+space in intellij to know what are the options you can use in flutter widgets
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
                  color: Colors.red[400],
                  letterSpacing: 2.5,
                ),
              ),
              customTextFormField('Registered ID', Colors.grey[350],
                  Icons.navigate_next, TextInputType.text),
              customTextFormField('Contact Number', Colors.grey[350],
                  Icons.navigate_next, TextInputType.number),
              customTextFormField('Email', Colors.grey[350],
                  Icons.navigate_next, TextInputType.emailAddress),
              customTextFormField('Date of Registration', Colors.grey[350],
                  Icons.navigate_next, TextInputType.datetime),
              customTextFormField('Next Renewal Date', Colors.grey[350],
                  Icons.navigate_next, TextInputType.datetime),
              customTextFormField('Number of Lines/Area', Colors.grey[350],
                  Icons.navigate_next, TextInputType.text),
              customTextFormField('Office Address', Colors.grey[350],
                  Icons.navigate_next, TextInputType.text),
              customTextFormField('Customize App Appearence', Colors.grey[350],
                  Icons.navigate_next, TextInputType.text),
              customTextFormField('Refer & Earn', Colors.grey[350],
                  Icons.notifications, TextInputType.text),
            ],
          ),
        ),
      ),
      bottomSheet: bottomBar(context),
    );
  }
}
