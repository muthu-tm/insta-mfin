import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/home/UserFinanceSetup.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/services/controllers/auth/auth_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhoneAuthVerify extends StatefulWidget {
  PhoneAuthVerify(this.isRegister, this.number, this.passKey, this.name,
      this.verificationID);

  final bool isRegister;
  final String number;
  final String passKey;
  final String name;
  final String verificationID;

  @override
  _PhoneAuthVerifyState createState() => _PhoneAuthVerifyState();
}

class _PhoneAuthVerifyState extends State<PhoneAuthVerify> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final AuthController _authController = AuthController();

  double _height, _width, _fixedPadding;

  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();
  FocusNode focusNode5 = FocusNode();
  FocusNode focusNode6 = FocusNode();
  List<String> code = [];

  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _fixedPadding = _height * 0.025;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white.withOpacity(0.95),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: _getBody(),
          ),
        ),
      ),
    );
  }

  Widget _getBody() => Card(
        color: CustomColors.mfinLightBlue,
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: SizedBox(
          height: _height * 0.6,
          width: _width * 0.8,
          child: _getColumnBody(),
        ),
      );

  Widget _getColumnBody() => Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(_fixedPadding),
            child: Material(
              elevation: 10.0,
              child:
                  Image.asset("images/icons/logo.png", height: _height * 0.1),
            ),
          ),
          Text('iFIN',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: CustomColors.mfinWhite,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700)),
          SizedBox(height: 20.0),
          Row(
            children: <Widget>[
              SizedBox(width: 16.0),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: 'Please enter the ',
                          style: TextStyle(
                              color: CustomColors.mfinWhite,
                              fontWeight: FontWeight.w400)),
                      TextSpan(
                          text: 'One Time Password',
                          style: TextStyle(
                              color: CustomColors.mfinWhite,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700)),
                      TextSpan(
                        text: ' sent to your mobile',
                        style: TextStyle(
                            color: CustomColors.mfinWhite,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 16.0),
            ],
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              getPinField(key: "1", focusNode: focusNode1),
              SizedBox(width: 5.0),
              getPinField(key: "2", focusNode: focusNode2),
              SizedBox(width: 5.0),
              getPinField(key: "3", focusNode: focusNode3),
              SizedBox(width: 5.0),
              getPinField(key: "4", focusNode: focusNode4),
              SizedBox(width: 5.0),
              getPinField(key: "5", focusNode: focusNode5),
              SizedBox(width: 5.0),
              getPinField(key: "6", focusNode: focusNode6),
              SizedBox(width: 5.0),
            ],
          ),
          SizedBox(height: 32.0),
          RaisedButton(
            elevation: 16.0,
            onPressed: signIn,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'VERIFY',
                style: TextStyle(
                  color: CustomColors.mfinButtonGreen,
                  fontSize: 18.0,
                ),
              ),
            ),
            color: CustomColors.mfinBlue,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          )
        ],
      );

  signIn() {
    if (code.length != 6) {
      _scaffoldKey.currentState
          .showSnackBar(CustomSnackBar.errorSnackBar("Invalid OTP", 2));
    } else {
      CustomDialogs.actionWaiting(context, "Verifying User");
      verifyOTPAndLogin(code.join());
    }
  }

  void verifyOTPAndLogin(String smsCode) async {
    AuthCredential _authCredential = PhoneAuthProvider.getCredential(
        verificationId: widget.verificationID, smsCode: smsCode);

    FirebaseAuth.instance
        .signInWithCredential(_authCredential)
        .then((AuthResult authResult) async {
      if (widget.isRegister) {
        dynamic result = await _authController.registerWithMobileNumber(
            int.parse(widget.number),
            widget.passKey,
            widget.name,
            authResult.user.uid);
        if (!result['is_success']) {
          Navigator.pop(context);
          _scaffoldKey.currentState
              .showSnackBar(CustomSnackBar.errorSnackBar(result['message'], 5));
        } else {
          await _success();
        }
      } else {
        Map<String, dynamic> _uJSON =
            await User(int.parse(widget.number)).getByID(widget.number);
        dynamic result =
            await _authController.signInWithMobileNumber(User.fromJson(_uJSON));
        if (!result['is_success']) {
          Navigator.pop(context);
          _scaffoldKey.currentState
              .showSnackBar(CustomSnackBar.errorSnackBar(result['message'], 5));
        } else {
          await _success();
        }
      }
    }).catchError((error) {
      Navigator.pop(context);
      _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
          "Something has gone wrong, please try later(signInWithPhoneNumber)",
          2));
      _scaffoldKey.currentState
          .showSnackBar(CustomSnackBar.errorSnackBar("${error.toString()}", 2));
    });
  }

  _success() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("mobile_number", widget.number.toString());

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (BuildContext context) => UserFinanceSetup()),
      (Route<dynamic> route) => false,
    );
  }

  Widget getPinField({String key, FocusNode focusNode}) => SizedBox(
        height: 40.0,
        width: 35.0,
        child: TextField(
          key: Key(key),
          expands: false,
          autofocus: false,
          focusNode: focusNode,
          onChanged: (String value) {
            if (value.length == 1) {
              code.insert(int.parse(key) - 1, value);
              switch (code.length) {
                case 1:
                  FocusScope.of(context).requestFocus(focusNode2);
                  break;
                case 2:
                  FocusScope.of(context).requestFocus(focusNode3);
                  break;
                case 3:
                  FocusScope.of(context).requestFocus(focusNode4);
                  break;
                case 4:
                  FocusScope.of(context).requestFocus(focusNode5);
                  break;
                case 5:
                  FocusScope.of(context).requestFocus(focusNode6);
                  break;
                default:
                  FocusScope.of(context).requestFocus(FocusNode());
                  break;
              }
            } else {
              code.removeAt(int.parse(key) - 1);
            }
          },
          maxLengthEnforced: false,
          textAlign: TextAlign.center,
          cursorColor: CustomColors.mfinWhite,
          keyboardType: TextInputType.number,
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              color: CustomColors.mfinWhite),
        ),
      );
}
