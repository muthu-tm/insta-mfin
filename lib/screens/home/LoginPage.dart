import 'package:flutter/material.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/home/Home.dart';
import 'package:instamfin/screens/home/MobileSigninPage.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/services/controllers/auth/auth_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController _nController = TextEditingController();
  TextEditingController _pController = TextEditingController();
  final AuthController _authController = AuthController();

  String url = "";

  @override
  void initState() {
    super.initState();

    getLocalUser();
  }

  getLocalUser() async {
    String number = await _prefs.then((SharedPreferences prefs) {
      return (prefs.getString('mobile_number') ?? '');
    });

    setState(() {
      this._nController.text = number;
    });
    if (this._nController.text != "") {
      await loadUser();
    }
  }

  loadUser() async {
    User _user = User.fromJson(
        await User(int.parse(_nController.text)).getByID(_nController.text));
    setState(() {
      this.url = _user.getProfilePicPath();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: CustomColors.mfinLightGrey,
      body: SafeArea(
        child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                url == ""
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
                          size: 50.0,
                          color: CustomColors.mfinBlue,
                        ),
                      )
                    : CircleAvatar(
                        radius: 45.0,
                        backgroundImage: NetworkImage(url),
                        backgroundColor: Colors.transparent,
                      ),
                Padding(
                  padding: EdgeInsets.only(left: 5, right: 5, bottom: 5),
                  child: Card(
                    child: TextFormField(
                      controller: _nController,
                      autofocus: false,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: 'Mobile Number',
                        fillColor: CustomColors.mfinWhite,
                        filled: true,
                        suffixIcon: Icon(
                          Icons.phone,
                          color: CustomColors.mfinFadedButtonGreen,
                          size: 35.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5, right: 5, bottom: 5),
                  child: Card(
                    child: TextFormField(
                      obscureText: true,
                      autofocus: false,
                      controller: _pController,
                      decoration: InputDecoration(
                        hintText: 'Secret KEY',
                        fillColor: CustomColors.mfinWhite,
                        filled: true,
                        suffixIcon: Icon(
                          Icons.visibility_off,
                          color: CustomColors.mfinFadedButtonGreen,
                          size: 35.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(20.0)),
                new InkWell(
                    onTap: _submit,
                    child: new Container(
                      width: 200.0,
                      height: 50.0,
                      decoration: new BoxDecoration(
                        color: CustomColors.mfinBlue,
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      child: new Center(
                        child: new Text(
                          'LOGIN',
                          style: new TextStyle(
                            fontSize: 20.0,
                            color: CustomColors.mfinButtonGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )),
                Padding(padding: EdgeInsets.all(25.0)),
                Container(
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Don't have an account? ",
                        style: new TextStyle(
                          fontSize: 22.0,
                          color: CustomColors.mfinAlertRed,
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          print("PRESSED");
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  MobileSignInPage()));
                        },
                        child: Text(
                          ' SIGN UP',
                          style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinBlue,
                            fontSize: 22.0,
                          ),
                        ),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.end,
                  ),
                )
              ],
            ),
          ),
        ),
    );
  }

  void _submit() async {
    if (_nController.text.length != 10) {
      _scaffoldKey.currentState.showSnackBar(
          CustomSnackBar.errorSnackBar("Enter valid Mobile Number", 2));
      return;
    } else if (_pController.text.length == 0) {
      _scaffoldKey.currentState.showSnackBar(
          CustomSnackBar.errorSnackBar("Enter Your Secret KEY", 2));
      return;
    } else {
      CustomDialogs.actionWaiting(context, "Logging In");
      var result = await _authController.signInWithMobileNumber(
          int.parse(_nController.text), _pController.text);

      if (!result['is_success']) {
        Navigator.pop(context);
        _scaffoldKey.currentState
            .showSnackBar(CustomSnackBar.errorSnackBar(result['message'], 5));
        print("Unable to Login: " + result['message']);
      } else {
        final SharedPreferences prefs = await _prefs;
        prefs.setString("mobile_number", _nController.text);

        Navigator.pop(context);
        print("User logged in successfully");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => UserHomeScreen(),
            settings: RouteSettings(name: '/home'),
          ),
          (Route<dynamic> route) => false,
        );
      }
    }
  }
}
