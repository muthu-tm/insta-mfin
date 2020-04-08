import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:instamfin/screens/app/appBar.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/app/sideDrawer.dart';
import 'package:instamfin/screens/home/Authenticate.dart';
import 'package:instamfin/screens/home/HomeOptions.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/services/controllers/auth/auth_controller.dart';
import 'package:instamfin/services/utils/users_utils.dart';

class UserHomeScreen extends StatefulWidget {
  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final AuthController _authController = AuthController();

  int _selectedOption = 0;

  get child => null;

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () => CustomDialogs.confirm(
                context, "Warning!", "Do you really want to exit?", () async {
              await _authController.signOut();
              userState.clear();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Authenticate()),
              );
            }, () => Navigator.pop(context, false)),
        child: Scaffold(
          backgroundColor: CustomColors.mfinBlue,
          appBar: topAppBar(context),
          drawer: openDrawer(context),
          body: ListView.builder(
            itemCount: options.length + 2,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return SizedBox(height: 5.0);
              } else if (index == options.length + 1) {
                return SizedBox(height: 100.0);
              }
              return Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(10.0),
                width: double.infinity,
                height: 70.0,
                decoration: BoxDecoration(
                  color: CustomColors.mfinGrey,
                  borderRadius: BorderRadius.circular(10.0),
                  border: _selectedOption == index - 1
                      ? Border.all(color: CustomColors.mfinWhite)
                      : null,
                ),
                child: ListTile(
                  trailing: Text(options[index - 1].value),
                  title: Text(
                    options[index - 1].title,
                    style: TextStyle(
                      color: _selectedOption == index - 1
                          ? CustomColors.mfinWhite
                          : CustomColors.mfinGrey,
                    ),
                  ),
                  selected: _selectedOption == index - 1,
                  onTap: () {
                    setState(() {
                      _selectedOption = index - 1;
                    });
                  },
                ),
              );
            },
          ),
          bottomSheet: bottomBar(context),
        ));
  }
}
