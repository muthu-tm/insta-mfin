import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/app/ContactAndSupportWidget.dart';
import 'package:instamfin/screens/app/update_app.dart';
import 'package:instamfin/screens/home/MobileSigninPage.dart';
import 'package:instamfin/screens/home/PhoneAuthVerify.dart';
import 'package:instamfin/screens/home/UserFinanceSetup.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/services/controllers/auth/auth_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:instamfin/app_localizations.dart';

class LoginPage extends StatefulWidget {
  LoginPage(this.isNewScaffold, this._scaffoldKey);

  final bool isNewScaffold;
  final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<ScaffoldState> _scaffoldKey;
  TextEditingController _nController = TextEditingController();
  AuthController _authController = AuthController();

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  User _user;

  String number = "";
  String _smsVerificationCode;

  @override
  void initState() {
    super.initState();

    if (widget.isNewScaffold) {
      _scaffoldKey = GlobalKey<ScaffoldState>();
    } else {
      _scaffoldKey = widget._scaffoldKey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.isNewScaffold
        ? Scaffold(
            key: _scaffoldKey,
            backgroundColor: CustomColors.mfinLightGrey,
            body: Center(
              child: SingleChildScrollView(
                child: _getBody(),
              ),
            ),
          )
        : Center(
            child: SingleChildScrollView(
              child: _getBody(),
            ),
          );
  }

  Widget _getBody() {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Card(
            color: CustomColors.mfinBlue,
            elevation: 2.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            child: SizedBox(
              height: 350,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Material(
                      borderRadius: BorderRadius.circular(10.0),
                      elevation: 10.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.asset(
                          "images/icons/logo.png",
                          height: 60,
                          width: 60,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: 20, left: 5, right: 5, bottom: 10),
                    child: Card(
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        controller: _nController,
                        autofocus: false,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          prefixText: " +91 ",
                          prefixStyle: TextStyle(
                            fontSize: 16.0,
                            color: CustomColors.mfinBlue,
                          ),
                          hintText: AppLocalizations.of(context).translate('mobile_number'),
                          fillColor: CustomColors.mfinWhite,
                          filled: true,
                          suffixIcon: Icon(
                            Icons.phone_android,
                            color: CustomColors.mfinFadedButtonGreen,
                            size: 35.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.info,
                        color: CustomColors.mfinWhite,
                        size: 20.0,
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'We will send ',
                                style: TextStyle(
                                    color: CustomColors.mfinWhite,
                                    fontWeight: FontWeight.w400),
                              ),
                              TextSpan(
                                text: 'One Time Password',
                                style: TextStyle(
                                    color: CustomColors.mfinAlertRed,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w700),
                              ),
                              TextSpan(
                                text: ' to this mobile number',
                                style: TextStyle(
                                    color: CustomColors.mfinWhite,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(20.0)),
                  new InkWell(
                    onTap: () {
                      _submit();
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
                          AppLocalizations.of(context).translate('get_otp'),
                          style: new TextStyle(
                            fontSize: 20.0,
                            color: CustomColors.mfinBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(25.0)),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            child: Row(
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).translate('no_account'),
                  style: new TextStyle(
                    fontSize: 13.0,
                    fontFamily: 'Georgia',
                    color: CustomColors.mfinAlertRed,
                    fontWeight: FontWeight.bold,
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
                    AppLocalizations.of(context).translate('sign_up'),
                    style: new TextStyle(
                      fontWeight: FontWeight.bold,
                      color: CustomColors.mfinBlue,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.end,
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: FlatButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  routeSettings: RouteSettings(name: "/home/help"),
                  builder: (context) {
                    return Center(
                      child: contactAndSupportDialog(),
                    );
                  },
                );
              },
              icon: Icon(
                Icons.info,
                color: CustomColors.mfinBlue,
              ),
              label: Text(
                AppLocalizations.of(context).translate('help_support'),
                style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  color: CustomColors.mfinBlue,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submit() async {
    if (_nController.text.length != 10) {
      _scaffoldKey.currentState.showSnackBar(
          CustomSnackBar.errorSnackBar(AppLocalizations.of(context).translate('enter_valid_phone'), 2));
      return;
    } else {
      CustomDialogs.actionWaiting(context, AppLocalizations.of(context).translate('checking_user'));

      number = _nController.text;
      try {
        Map<String, dynamic> _uJSON =
            await User(int.parse(number)).getByID(number);
        if (_uJSON == null) {
          Navigator.pop(context);
          _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
              AppLocalizations.of(context).translate('invalid_user_signup'), 2));
          return;
        } else {
          this._user = User.fromJson(_uJSON);
          _verifyPhoneNumber();
        }
      } catch (err) {
        _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
            AppLocalizations.of(context).translate('login_error') + err.toString(), 2));
      }
    }
  }

  _verifyPhoneNumber() async {
    String phoneNumber = "+91" + number;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 5),
        verificationCompleted: (authCredential) =>
            _verificationComplete(authCredential, context),
        verificationFailed: (authException) =>
            _verificationFailed(authException, context),
        codeAutoRetrievalTimeout: (verificationId) =>
            _codeAutoRetrievalTimeout(verificationId),
        codeSent: (verificationId, [code]) =>
            _smsCodeSent(verificationId, [code]));
  }

  _verificationComplete(
      AuthCredential authCredential, BuildContext context) async {
    FirebaseAuth.instance
        .signInWithCredential(authCredential)
        .then((AuthResult authResult) async {
      final SharedPreferences prefs = await _prefs;
      prefs.setString("mobile_number", number);

      var result = await _authController.signInWithMobileNumber(_user);

      if (!result['is_success']) {
        Navigator.pop(context);
        _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
          AppLocalizations.of(context).translate('unable_to_login'),
            2));
        _scaffoldKey.currentState
            .showSnackBar(CustomSnackBar.errorSnackBar(result['message'], 2));
      } else {
        try {
          await UserController().refreshCacheSubscription();
          await UserController().refreshUser(true);
        } catch (err) {
          _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
              AppLocalizations.of(context).translate('unable_to_login'),
              2));
          return;
        }
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) => UpdateApp(
              child: UserFinanceSetup(),
            ),
          ),
          (Route<dynamic> route) => false,
        );
      }
    }).catchError((error) {
      Navigator.pop(context);
      _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
          AppLocalizations.of(context).translate('try_later'),
          2));
      _scaffoldKey.currentState
          .showSnackBar(CustomSnackBar.errorSnackBar("${error.toString()}", 2));
    });
  }

  _smsCodeSent(String verificationId, List<int> code) {
    _scaffoldKey.currentState
        .showSnackBar(CustomSnackBar.successSnackBar("OTP sent", 1));

    _smsVerificationCode = verificationId;
    Navigator.pop(context);
    CustomDialogs.actionWaiting(context, AppLocalizations.of(context).translate('verify_user'));
  }

  _verificationFailed(AuthException authException, BuildContext context) {
    Navigator.pop(context);
    _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
        AppLocalizations.of(context).translate('verification_failed') + authException.message.toString(), 2));
  }

  _codeAutoRetrievalTimeout(String verificationId) {
    _smsVerificationCode = verificationId;

    Navigator.pop(context);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => PhoneAuthVerify(
            false,
            _user.mobileNumber.toString(),
            _user.password,
            _user.name,
            _smsVerificationCode),
      ),
    );
  }
}
