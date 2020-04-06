import 'package:flutter/material.dart';
import 'package:instamfin/screens/app/appBar.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/app/sideDrawer.dart';
import 'package:instamfin/screens/utils/CustomTextFormField.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserProfileSetting extends StatefulWidget {
  const UserProfileSetting(this.profileURL);

  final String profileURL;

  @override
  _UserProfileSettingState createState() => _UserProfileSettingState();
}

class _UserProfileSettingState extends State<UserProfileSetting> {
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
                backgroundImage: CachedNetworkImageProvider(widget.profileURL),
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
              customTextFormField('Mobile Number', Colors.grey[350],
                  Icons.navigate_next, TextInputType.text),
              customTextFormField('Email', Colors.grey[350],
                  Icons.navigate_next, TextInputType.emailAddress),
              customTextFormField('Date of Birth', Colors.grey[350],
                  Icons.navigate_next, TextInputType.datetime),
              customTextFormField('Date of Join', Colors.grey[350],
                  Icons.navigate_next, TextInputType.datetime),
              customTextFormField('Office Address', Colors.grey[350],
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
