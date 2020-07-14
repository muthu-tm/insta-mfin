import 'package:flutter/material.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/app/update_app.dart';
import 'package:instamfin/screens/home/LoginPage.dart';
import 'package:instamfin/screens/home/MobileSigninPage.dart';
import 'package:instamfin/screens/home/UserFinanceSetup.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/services/controllers/auth/auth_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:instamfin/services/utils/hash_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController _pController = TextEditingController();
  final AuthController _authController = AuthController();

  String url = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: CustomColors.mfinLightGrey,
      body: Center(
        child: SingleChildScrollView(
          child: FutureBuilder<String>(
            future: _prefs.then(
              (SharedPreferences prefs) {
                return (prefs.getString('mobile_number') ?? '');
              },
            ),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data != '') {
                  return FutureBuilder<Map<String, dynamic>>(
                    future:
                        User(int.parse(snapshot.data)).getByID(snapshot.data),
                    builder: (BuildContext context,
                        AsyncSnapshot<Map<String, dynamic>> userSnapshot) {
                      if (userSnapshot.hasData) {
                        User _user = User.fromJson(userSnapshot.data);
                        return _getBody(snapshot.data, _user);
                      } else if (userSnapshot.hasError) {
                        return LoginPage(false, _scaffoldKey);
                      } else {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: AsyncWidgets.asyncWaiting(),
                          ),
                        );
                      }
                    },
                  );
                } else {
                  return LoginPage(false, _scaffoldKey);
                }
              } else if (snapshot.hasError) {
                return LoginPage(false, _scaffoldKey);
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: AsyncWidgets.asyncWaiting(),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _getBody(String number, User _user) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Card(
            color: CustomColors.mfinBlue,
            elevation: 2.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: _user.getProfilePicPath() == ""
                        ? Container(
                            width: 80,
                            height: 80,
                            margin: EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: CustomColors.mfinFadedButtonGreen,
                                  style: BorderStyle.solid,
                                  width: 2.0),
                              // image:
                            ),
                            child: Icon(
                              Icons.person,
                              size: 45.0,
                              color: CustomColors.mfinLightGrey,
                            ),
                          )
                        : CircleAvatar(
                            radius: 45.0,
                            backgroundImage:
                                NetworkImage(_user.getProfilePicPath()),
                            backgroundColor: Colors.transparent,
                          ),
                  ),
                  Text(
                    _user.name,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: CustomColors.mfinLightGrey,
                    ),
                  ),
                  Text(
                    _user.mobileNumber.toString(),
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: CustomColors.mfinLightGrey,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5, right: 5, bottom: 5),
                    child: Card(
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        obscureText: true,
                        autofocus: false,
                        controller: _pController,
                        decoration: InputDecoration(
                          hintText: 'Secret KEY',
                          fillColor: CustomColors.mfinWhite,
                          filled: true,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  LoginPage(true, _scaffoldKey),
                            ),
                          );
                        },
                        child: Text(
                          'Not You! or Forgot KEY?',
                          textAlign: TextAlign.end,
                          style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinAlertRed,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(20.0)),
                  new InkWell(
                    onTap: () {
                      _submit(_user);
                    },
                    child: new Container(
                      width: 150.0,
                      height: 50.0,
                      decoration: new BoxDecoration(
                        color: CustomColors.mfinFadedButtonGreen,
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      child: new Center(
                        child: new Text(
                          'LOGIN',
                          style: new TextStyle(
                            fontSize: 18.0,
                            fontFamily: 'Georgia',
                            color: CustomColors.mfinBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(padding: EdgeInsets.all(25.0)),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  "Don't have an account?",
                  style: new TextStyle(
                    fontSize: 13.0,
                    fontFamily: 'Georgia',
                    fontWeight: FontWeight.bold,
                    color: CustomColors.mfinAlertRed.withOpacity(0.7),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => MobileSignInPage(),
                      ),
                    );
                  },
                  child: Text(
                    'SIGN UP',
                    style: new TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: CustomColors.mfinPositiveGreen,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _submit(User _user) async {
    if (_pController.text.length == 0) {
      _scaffoldKey.currentState.showSnackBar(
          CustomSnackBar.errorSnackBar("Enter Your Secret KEY", 2));
      return;
    } else {
      String hashKey = HashGenerator.hmacGenerator(
          _pController.text, _user.mobileNumber.toString());
      if (hashKey != _user.password) {
        _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
            "Wrong Secret KEY. Please try again!", 2));
        return;
      } else {
        CustomDialogs.actionWaiting(context, "Logging In");

        var result = await _authController.signInWithMobileNumber(_user);

        if (!result['is_success']) {
          Navigator.pop(context);
          _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
              "Unable to Login, Something went wrong!", 2));
          _scaffoldKey.currentState
              .showSnackBar(CustomSnackBar.errorSnackBar(result['message'], 2));
        } else {
          await UserController().refreshUser(true);
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (BuildContext context) => UpdateApp(
                child: UserFinanceSetup(),
              ),
            ),
            (Route<dynamic> route) => false,
          );
        }
      }
    }
  }
}
