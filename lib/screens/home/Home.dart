import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:instamfin/main.dart';
import 'package:instamfin/screens/app/appBar.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/utils/CustomTextFormField.dart';
import 'package:instamfin/screens/home/HomeOptions.dart';
import 'package:instamfin/screens/utils/colors.dart';
import 'package:instamfin/services/controllers/auth/auth_controller.dart';

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
        onWillPop: () => showDialog<bool>(
              context: context,
              builder: (c) => AlertDialog(
                backgroundColor: CustomColors.mfinGrey,
                titlePadding: EdgeInsets.all(10),
                title: Container(
                  // decoration: BoxDecoration(color: CustomColors.mfinAlertRed),
                  child: new Text(
                    'Warning!',
                    style: TextStyle(
                        color: CustomColors.mfinAlertRed, fontSize: 18.0),
                    textAlign: TextAlign.start,
                  ),
                ),
                content: new Container(
                  child: new Text(
                    'Do you really want to exit?',
                    style:
                        TextStyle(color: CustomColors.mfinBlue, fontSize: 18.0),
                    textAlign: TextAlign.center,
                  ),
                ),
                actions: <Widget>[
                  RaisedButton(
                    child: new Text(
                      'YES',
                      style: TextStyle(
                          color: CustomColors.mfinAlertRed, fontSize: 18.0),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () async {
                      await _authController.signOut();

                      // if (!result['is_signed_out']) {
                      //   print(
                      //       "Unable to SIGN OUT, Error: " + result['message']);
                      // } else {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => MyApp()),
                      //   );
                      // }
                    },
                  ),
                  RaisedButton(
                    child: new Text(
                      'NO',
                      style: TextStyle(
                          color: CustomColors.mfinButtonGreen, fontSize: 18.0),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () => Navigator.pop(c, false),
                  ),
                ],
              ),
            ),
        child: Scaffold(
          backgroundColor: Colors.blue[800],
          appBar: topAppBar(),
          drawer: Drawer(
              child: customTextFormField('Email', Colors.white, Icons.mail,
                  TextInputType.emailAddress)),
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
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10.0),
                  border: _selectedOption == index - 1
                      ? Border.all(color: Colors.white)
                      : null,
                ),
                child: ListTile(
                  trailing: Text(options[index - 1].value),
                  title: Text(
                    options[index - 1].title,
                    style: TextStyle(
                      color: _selectedOption == index - 1
                          ? Colors.black
                          : Colors.grey[600],
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
