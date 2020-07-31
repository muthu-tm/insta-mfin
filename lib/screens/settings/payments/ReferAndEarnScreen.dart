import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReferAndEarnScreen extends StatefulWidget {
  @override
  _ReferAndEarnScreenState createState() => _ReferAndEarnScreenState();
}

class _ReferAndEarnScreenState extends State<ReferAndEarnScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final User _user = UserController().getCurrentUser();

  TextEditingController _textEditingController = TextEditingController();
  bool isReadOnly = false;

  @override
  void initState() {
    super.initState();
    int expiredAt = DateUtils.getUTCDateEpoch(_user.createdAt) + (7 * 86400000);

    _textEditingController.text =
        _user.referrerNumber != null ? _user.referrerNumber.toString() : "";
    if (_user.referrerNumber != null ||
        (DateUtils.getUTCDateEpoch(DateTime.now()) >= expiredAt))
      isReadOnly = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: CustomColors.mfinWhite,
      appBar: AppBar(
        title: Text('Refer & Earn'),
        backgroundColor: CustomColors.mfinBlue,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(5),
              child: getReferredByWidget(),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: getReferralCode(),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: getOfferPanel(),
            ),
          ],
        ),
      ),
    );
  }

  Widget getReferralCode() {
    return Container(
      height: 150,
      color: CustomColors.mfinLightGrey,
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Your Referral Code",
            style: TextStyle(
              color: CustomColors.mfinBlue,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              "Refer iFIN with this code and get rewards in your iFIN Wallet!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: CustomColors.mfinBlack,
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextFormField(
              readOnly: true,
              initialValue: _user.mobileNumber.toString(),
              textAlign: TextAlign.start,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                fillColor: CustomColors.mfinWhite,
                filled: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: CustomColors.mfinWhite)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getOfferPanel() {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder:
          (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        Widget widget;

        if (snapshot.hasData) {
          int amount = snapshot.data.getInt('registration_bonus') ?? 25;
          widget = ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [
                CustomColors.mfinLightGrey,
                CustomColors.mfinAlertRed,
              ],
            ).createShader(
              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
            ),
            child: Text(
              "Refer 'iFIN' with your friends and Earn Rs.$amount instantly",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: CustomColors.mfinWhite,
                fontSize: 18,
                fontFamily: "Georgia"
              ),
            ),
          );
        } else if (snapshot.hasError) {
          widget = Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: AsyncWidgets.asyncError());
        } else {
          widget = Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: AsyncWidgets.asyncWaiting());
        }

        return Material(
          elevation: 10.0,
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
              height: 100,
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10.0),
                gradient: LinearGradient(
                  colors: <Color>[
                    CustomColors.mfinBlack,
                    CustomColors.mfinButtonGreen
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: EdgeInsets.all(5),
              child: widget),
        );
      },
    );
  }

  Widget getReferredByWidget() {
    return Container(
      height: isReadOnly ? 150 : 180,
      color: CustomColors.mfinLightGrey,
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Referred by",
            style: TextStyle(
              color: CustomColors.mfinBlue,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextFormField(
              controller: _textEditingController,
              readOnly: isReadOnly,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: isReadOnly ? "No Referral" : "Enter the code here",
                fillColor: CustomColors.mfinWhite,
                filled: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: CustomColors.mfinWhite)),
              ),
            ),
          ),
          !isReadOnly
              ? Padding(
                  padding: EdgeInsets.all(10),
                  child: RaisedButton.icon(
                    onPressed: () async {
                      if (_textEditingController.text.length == 10 &&
                          int.tryParse(_textEditingController.text) != null) {
                        try {
                          int number = int.parse(_textEditingController.text);
                          if (number == _user.mobileNumber) {
                            _scaffoldKey.currentState.showSnackBar(
                                CustomSnackBar.errorSnackBar(
                                    "Your own code cannot be applied!", 2));
                            return;
                          } else {
                            CustomDialogs.actionWaiting(
                                context, "Applying Code!");

                            SharedPreferences sPref =
                                await SharedPreferences.getInstance();

                            int rBonus = sPref.getInt('referral_bonus') ?? 25;
                            await _user.updateReferralCode(number, rBonus);
                            Navigator.pop(context);
                            _scaffoldKey.currentState.showSnackBar(
                                CustomSnackBar.successSnackBar(
                                    "Successfully applied referral code!", 2));
                            setState(() {
                              isReadOnly = true;
                            });
                          }
                        } catch (err) {
                          Navigator.pop(context);
                          _scaffoldKey.currentState.showSnackBar(
                              CustomSnackBar.errorSnackBar(err.toString(), 3));
                        }
                      } else {
                        _scaffoldKey.currentState.showSnackBar(
                            CustomSnackBar.errorSnackBar(
                                "Please Enter valid referral code!", 2));
                      }
                    },
                    label: Text("Apply Referral Code"),
                    icon: Icon(Icons.card_giftcard),
                  ),
                )
              : Padding(padding: EdgeInsets.all(2)),
        ],
      ),
    );
  }
}
