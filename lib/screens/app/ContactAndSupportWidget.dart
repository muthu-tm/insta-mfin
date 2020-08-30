import 'package:flutter/material.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/url_launcher_utils.dart';
import 'package:instamfin/services/utils/constants.dart';

import '../../app_localizations.dart';

Widget contactAndSupportDialog(context) {
  return Container(
    height: 400,
    width: MediaQuery.of(context).size.width * 0.9,
    child: Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.live_help,
                  size: 35.0,
                  color: CustomColors.mfinBlue,
                ),
                Padding(padding: EdgeInsets.all(5)),
                Text(
                  // AppLocalizations.of(context).translate('help_and_support'),
                  "mFIN - Help Desk",
                  style: TextStyle(
                      fontFamily: 'Georgia',
                      color: CustomColors.mfinPositiveGreen,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Divider(
            color: CustomColors.mfinButtonGreen,
            height: 0,
          ),
          SizedBox(height: 5),
          ClipRRect(
            child: Image.asset(
              "images/icons/logo.png",
              height: 60,
              width: 60,
            ),
          ),
          SizedBox(height: 15),
          Text(
            AppLocalizations.of(context).translate('lost_need_help'),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: CustomColors.mfinBlue,
                fontSize: 16.0,
                fontWeight: FontWeight.bold),
          ),
          Text(
            AppLocalizations.of(context).translate('happy_to_help'),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: CustomColors.mfinPositiveGreen,
                fontSize: 14.0,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 40),
          Text(
            AppLocalizations.of(context).translate('contact_us'),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Georgia',
                color: CustomColors.mfinBlue,
                fontSize: 18.0,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Spacer(
                flex: 2,
              ),
              RaisedButton.icon(
                icon: Icon(
                  Icons.contact_mail,
                  color: CustomColors.mfinLightGrey,
                ),
                elevation: 15.0,
                onPressed: () {
                  UrlLauncherUtils.sendEmail(
                      'hello.ifin@gmail.com',
                      'mFIN - Help %26 Support',
                      'Please type your query/issue here with your mobile number.. We will get back to you ASAP!');
                },
                label: Text(
                  AppLocalizations.of(context).translate('email'),
                  style: TextStyle(
                    color: CustomColors.mfinButtonGreen,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                color: CustomColors.mfinBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              Spacer(
                flex: 1,
              ),
              RaisedButton.icon(
                icon: Icon(
                  Icons.contact_phone,
                  color: CustomColors.mfinLightGrey,
                ),
                elevation: 15.0,
                onPressed: () {
                  UrlLauncherUtils.makePhoneCall(support_number);
                },
                label: Text(
                  AppLocalizations.of(context).translate('phone'),
                  style: TextStyle(
                    color: CustomColors.mfinButtonGreen,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                color: CustomColors.mfinBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              Spacer(
                flex: 2,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
