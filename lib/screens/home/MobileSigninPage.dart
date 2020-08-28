import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/app/update_app.dart';
import 'package:instamfin/screens/home/PhoneAuthVerify.dart';
import 'package:instamfin/screens/home/UserFinanceSetup.dart';
import 'package:instamfin/screens/support/SupportScreen.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/url_launcher_utils.dart';
import 'package:instamfin/services/analytics/analytics.dart';
import 'package:instamfin/services/controllers/auth/auth_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:instamfin/app_localizations.dart';

class MobileSignInPage extends StatefulWidget {
  @override
  _MobileSignInPageState createState() => _MobileSignInPageState();
}

class _MobileSignInPageState extends State<MobileSignInPage> {
  String number, _smsVerificationCode;
  int countryCode = 91;

  bool _passwordVisible = true;
  bool termsAgreed = true;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passKeyController = TextEditingController();
  final AuthController _authController = AuthController();

  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: CustomColors.mfinLightGrey,
      body: SingleChildScrollView(
        child: _getBody(),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: FlatButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SupportScreen(),
              settings: RouteSettings(name: '/settings/app/support'),
            ),
          );
        },
        icon: Icon(
          Icons.info,
          color: CustomColors.mfinBlue,
        ),
        label: Text(
          AppLocalizations.of(context).translate('help_support'),
          style: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
            color: CustomColors.mfinBlue,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  Widget _getBody() => SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: _getColumnBody(),
        ),
      );

  Widget _getColumnBody() => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: ClipRRect(
              child: Image.asset(
                "images/icons/logo.png",
                height: 80,
                width: 80,
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(width: 5),
              Icon(Icons.info, color: CustomColors.mfinAlertRed, size: 20.0),
              SizedBox(width: 10.0),
              Expanded(
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: AppLocalizations.of(context)
                          .translate('we_will_send'),
                      style: TextStyle(
                          color: CustomColors.mfinBlue,
                          fontWeight: FontWeight.w400)),
                  TextSpan(
                      text: AppLocalizations.of(context)
                          .translate('one_time_password'),
                      style: TextStyle(
                          color: CustomColors.mfinAlertRed,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700)),
                  TextSpan(
                      text: AppLocalizations.of(context)
                          .translate('to_mobile_no'),
                      style: TextStyle(
                          color: CustomColors.mfinBlue,
                          fontWeight: FontWeight.w400)),
                ])),
              ),
              SizedBox(width: 5),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 5, right: 5, bottom: 5),
            child: Card(
              child: Row(
                children: <Widget>[
                  Text(
                    " +91",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: CustomColors.mfinBlue,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      controller: _phoneNumberController,
                      autofocus: false,
                      keyboardType: TextInputType.number,
                      key: Key('EnterPhone-TextFormField'),
                      decoration: InputDecoration(
                        fillColor: CustomColors.mfinWhite,
                        filled: true,
                        suffixIcon: Icon(
                          Icons.phone_android,
                          color: CustomColors.mfinFadedButtonGreen,
                          size: 35.0,
                        ),
                        hintText: AppLocalizations.of(context)
                            .translate('enter_phone_number'),
                        border: InputBorder.none,
                        errorMaxLines: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5, right: 5, bottom: 5),
            child: Card(
              child: TextFormField(
                controller: _nameController,
                autofocus: false,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).translate('name'),
                  fillColor: CustomColors.mfinWhite,
                  filled: true,
                  suffixIcon: Icon(
                    Icons.sentiment_satisfied,
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
                controller: _passKeyController,
                obscureText: _passwordVisible,
                keyboardType: TextInputType.number,
                maxLength: 4,
                maxLengthEnforced: true,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)
                      .translate('four_digit_secret'),
                  fillColor: CustomColors.mfinWhite,
                  filled: true,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: CustomColors.mfinFadedButtonGreen,
                      size: 35.0,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Checkbox(
                value: termsAgreed,
                onChanged: (bool val) {
                  setState(() {
                    termsAgreed = val;
                  });
                },
              ),
              SizedBox(width: 5.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "I agree to the Fourcup Inc",
                      style: TextStyle(
                          fontFamily: 'Georgia', color: CustomColors.mfinBlack),
                    ),
                    Row(
                      children: [
                        FlatButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () => UrlLauncherUtils.launchURL(
                              "https://fourcup.com/terms-of-services/"),
                          child: Text(
                            "Terms of Services",
                            style: TextStyle(
                                fontFamily: 'Georgia',
                                color: CustomColors.mfinBlue,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          " & ",
                          style: TextStyle(
                              fontFamily: 'Georgia',
                              color: CustomColors.mfinBlack),
                        ),
                        FlatButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () => UrlLauncherUtils.launchURL(
                              "https://fourcup.com/privacy-policy/"),
                          child: Text(
                            "Privacy Policy",
                            style: TextStyle(
                                fontFamily: 'Georgia',
                                color: CustomColors.mfinBlue,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 5),
            ],
          ),
          SizedBox(height: 10),
          RaisedButton(
            padding: EdgeInsets.only(right: 25, left: 25, top: 5, bottom: 5),
            elevation: 10.0,
            disabledElevation: 5.0,
            textColor: CustomColors.mfinButtonGreen,
            onPressed: termsAgreed ? startPhoneAuth : null,
            disabledColor: CustomColors.mfinGrey,
            disabledTextColor: CustomColors.mfinBlack,
            child: Text(
              AppLocalizations.of(context).translate('get_otp'),
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 18.0,
              ),
            ),
            color: CustomColors.mfinBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          Padding(padding: EdgeInsets.all(25.0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                child: Text(
                  AppLocalizations.of(context).translate('already_account'),
                  style: TextStyle(
                    fontSize: 11,
                    fontFamily: 'Georgia',
                    color: CustomColors.mfinPositiveGreen,
                  ),
                ),
              ),
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  AppLocalizations.of(context).translate('login'),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.mfinBlue,
                  ),
                ),
              ),
            ],
          ),
        ],
      );

  startPhoneAuth() async {
    if (_phoneNumberController.text.length != 10) {
      _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
          AppLocalizations.of(context).translate('invalid_number'), 2));
      return;
    } else if (_nameController.text.length <= 2) {
      _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
          AppLocalizations.of(context).translate('enter_your_name'), 2));
      return;
    } else if (_passKeyController.text.length != 4) {
      _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
          AppLocalizations.of(context).translate('secret_key_validation'), 2));
      return;
    } else {
      CustomDialogs.actionWaiting(
          context, AppLocalizations.of(context).translate('checking_user'));
      this.number = _phoneNumberController.text;

      var data = await User().getByID(countryCode.toString() + number);
      if (data != null) {
        Analytics.reportError({
          "type": 'sign_up_error',
          "user_id": countryCode.toString() + number,
          'name': _nameController.text,
          'error': "Found an existing user for this mobile number"
        }, 'sign_up');
        Navigator.pop(context);
        _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
            "Found an existing user for this mobile number", 2));
      } else {
        await _verifyPhoneNumber();
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
      dynamic result = await _authController.registerWithMobileNumber(
          int.parse(number),
          countryCode,
          _passKeyController.text,
          _nameController.text,
          authResult.user.uid);
      if (!result['is_success']) {
        Navigator.pop(context);
        _scaffoldKey.currentState
            .showSnackBar(CustomSnackBar.errorSnackBar(result['message'], 5));
      } else {
        final SharedPreferences prefs = await _prefs;
        prefs.setString("mobile_number", number);

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
          AppLocalizations.of(context).translate('try_later'), 2));
      _scaffoldKey.currentState
          .showSnackBar(CustomSnackBar.errorSnackBar("${error.toString()}", 2));
    });
  }

  _smsCodeSent(String verificationId, List<int> code) {
    _scaffoldKey.currentState.showSnackBar(CustomSnackBar.successSnackBar(
        AppLocalizations.of(context).translate('otp_send'), 1));

    _smsVerificationCode = verificationId;
    Navigator.pop(context);
    CustomDialogs.actionWaiting(
        context, AppLocalizations.of(context).translate('verify_user'));
  }

  _verificationFailed(AuthException authException, BuildContext context) {
    Navigator.pop(context);
    _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
        "Verification Failed:" + authException.message.toString(), 2));
  }

  _codeAutoRetrievalTimeout(String verificationId) {
    _smsVerificationCode = verificationId;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) => PhoneAuthVerify(
            true,
            number,
            _passKeyController.text,
            _nameController.text,
            _smsVerificationCode),
      ),
    );
  }
}
