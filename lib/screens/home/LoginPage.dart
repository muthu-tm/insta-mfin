import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/home/MobileSigninPage.dart';
import 'package:instamfin/screens/home/PhoneAuthVerify.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/services/controllers/auth/auth_controller.dart';

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
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Material(
                      elevation: 10.0,
                      child: Image.asset("images/icons/logo.png", height: 50),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5, right: 5, bottom: 5),
                    child: Card(
                      child: TextFormField(
                        textAlign: TextAlign.center,
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
                          'GET OTP',
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
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => MobileSignInPage(),
                      ),
                    );
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
          ),
        ],
      ),
    );
  }

  void _submit() async {
    if (_nController.text.length != 10) {
      _scaffoldKey.currentState.showSnackBar(
          CustomSnackBar.errorSnackBar("Enter valid Mobile Number", 2));
      return;
    } else {
      number = _nController.text;
      Map<String, dynamic> _uJSON =
          await User(int.parse(number)).getByID(number);
      if (_uJSON == null) {
        _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
            "No USER found for this Number, please 'SIGN UP'", 2));
        return;
      } else {
        this._user = User.fromJson(_uJSON);
        dynamic result = await _authController.signInWithMobileNumber(_user);
        if (!result['is_success']) {
          _scaffoldKey.currentState
              .showSnackBar(CustomSnackBar.errorSnackBar(result['message'], 5));
          print("Unable to register USER: " + result['message']);
        } else {
          _verifyPhoneNumber();
        }
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
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) =>
            PhoneAuthVerify(_user, _smsVerificationCode),
      ),
    );
  }

  _smsCodeSent(String verificationId, List<int> code) {
    print("SENT" + code.join());
    _scaffoldKey.currentState
        .showSnackBar(CustomSnackBar.successSnackBar("OTP sent", 2));

    _smsVerificationCode = verificationId;
  }

  _verificationFailed(AuthException authException, BuildContext context) {
    _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
        "Verification Failed:" + authException.message.toString(), 2));
  }

  _codeAutoRetrievalTimeout(String verificationId) {
    _smsVerificationCode = verificationId;
  }
}
