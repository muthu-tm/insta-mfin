import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/screens/app/update_app.dart';
import 'package:instamfin/screens/home/PhoneAuthVerify.dart';
import 'package:instamfin/screens/home/UserFinanceSetup.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/services/controllers/auth/auth_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:instamfin/app_localizations.dart';

class MobileSignInPage extends StatefulWidget {
  @override
  _MobileSignInPageState createState() => _MobileSignInPageState();
}

class _MobileSignInPageState extends State<MobileSignInPage> {
  String number, _smsVerificationCode;
  bool _passwordVisible = false;
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
            padding: EdgeInsets.all(5.0),
            child: Material(
              elevation: 10.0,
              borderRadius: BorderRadius.circular(10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset(
                  "images/icons/logo.png",
                  height: 70,
                  width: 70,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5, right: 5, bottom: 5),
            child: Card(
              child: Row(
                children: <Widget>[
                  Text(
                    " +91 ",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: CustomColors.mfinBlue,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: TextFormField(
                      controller: _phoneNumberController,
                      autofocus: false,
                      keyboardType: TextInputType.phone,
                      key: Key('EnterPhone-TextFormField'),
                      decoration: InputDecoration(
                        fillColor: CustomColors.mfinWhite,
                        filled: true,
                        suffixIcon: Icon(
                          Icons.phone_android,
                          color: CustomColors.mfinFadedButtonGreen,
                          size: 35.0,
                        ),
                        hintText: AppLocalizations.of(context).translate('enter_phone_number'),
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
                decoration: InputDecoration(
                  hintText:  AppLocalizations.of(context).translate('name'),
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
                decoration: new InputDecoration(
                  hintText: AppLocalizations.of(context).translate('four_digit_secret'),
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
              SizedBox(width: 5),
              Icon(Icons.info, color: CustomColors.mfinAlertRed, size: 20.0),
              SizedBox(width: 10.0),
              Expanded(
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: AppLocalizations.of(context).translate('we_will_send'),
                      style: TextStyle(
                          color: CustomColors.mfinBlue,
                          fontWeight: FontWeight.w400)),
                  TextSpan(
                      text: AppLocalizations.of(context).translate('one_time_password'),
                      style: TextStyle(
                          color: CustomColors.mfinAlertRed,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700)),
                  TextSpan(
                      text: AppLocalizations.of(context).translate('to_mobile_no'),
                      style: TextStyle(
                          color: CustomColors.mfinBlue,
                          fontWeight: FontWeight.w400)),
                ])),
              ),
              SizedBox(width: 5),
            ],
          ),
          SizedBox(height: 10),
          RaisedButton(
            elevation: 16.0,
            onPressed: startPhoneAuth,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppLocalizations.of(context).translate('get_otp'),
                style: TextStyle(
                  color: CustomColors.mfinButtonGreen,
                  fontSize: 18.0,
                ),
              ),
            ),
            color: CustomColors.mfinBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          Padding(padding: EdgeInsets.all(25.0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                child: Text(
                  AppLocalizations.of(context).translate('alreay_account'),
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Georgia',
                    color: CustomColors.mfinPositiveGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  AppLocalizations.of(context).translate('login'),
                  style: TextStyle(
                    fontSize: 18,
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
      _scaffoldKey.currentState.showSnackBar(
          CustomSnackBar.errorSnackBar(AppLocalizations.of(context).translate('invalid_number'), 2));
      return;
    } else if (_nameController.text.length <= 2) {
      _scaffoldKey.currentState.showSnackBar(
          CustomSnackBar.errorSnackBar(AppLocalizations.of(context).translate('enter_your_name'), 2));
      return;
    } else if (_passKeyController.text.length != 4) {
      _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
          AppLocalizations.of(context).translate('secret_key_validation'), 2));
      return;
    } else {
      CustomDialogs.actionWaiting(context, AppLocalizations.of(context).translate('checking_user'));

      this.number = _phoneNumberController.text;
      await _verifyPhoneNumber();
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
          _passKeyController.text,
          _nameController.text,
          authResult.user.uid);
      if (!result['is_success']) {
        Navigator.pop(context);
        _scaffoldKey.currentState
            .showSnackBar(CustomSnackBar.errorSnackBar(result['message'], 5));
        print(AppLocalizations.of(context).translate('unable_to_register') + result['message']);
      } else {
        final SharedPreferences prefs = await _prefs;
        prefs.setString("mobile_number", number.toString());

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
        .showSnackBar(CustomSnackBar.successSnackBar(AppLocalizations.of(context).translate('otp_send'), 1));

    _smsVerificationCode = verificationId;
    Navigator.pop(context);
    CustomDialogs.actionWaiting(context, AppLocalizations.of(context).translate('verify_user'));
  }

  _verificationFailed(AuthException authException, BuildContext context) {
    Navigator.pop(context);
    _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
        "Verification Failed:" + authException.message.toString(), 2));
  }

  _codeAutoRetrievalTimeout(String verificationId) {
    _smsVerificationCode = verificationId;

    Navigator.pop(context);
    Navigator.of(context).push(
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
