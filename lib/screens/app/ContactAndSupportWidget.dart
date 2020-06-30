import 'package:flutter/material.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/url_launcher_utils.dart';

Widget contactAndSupportDialog() {
  return Container(
    height: 350,
    width: 300,
    child: Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: Icon(
              Icons.headset_mic,
              size: 35.0,
              color: CustomColors.mfinBlue,
            ),
            title: Text(
              "HELP & SUPPORT",
              style: TextStyle(
                  color: CustomColors.mfinPositiveGreen,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Divider(
            color: CustomColors.mfinButtonGreen,
          ),
          SizedBox(height: 10),
          ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.asset(
                "images/icons/logo.png",
                height: 50,
                width: 50,
              ),
            ),
          SizedBox(height: 15),
          Text(
            "Get Lost? Need Some Help?",
            style: TextStyle(
                color: CustomColors.mfinBlue,
                fontSize: 16.0,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "We are happy to help you!",
            style: TextStyle(
                color: CustomColors.mfinPositiveGreen,
                fontSize: 14.0,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 40),
          Text(
            "Contact Us",
            style: TextStyle(
                color: CustomColors.mfinBlue,
                fontSize: 20.0,
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
                  Icons.email,
                  color: CustomColors.mfinLightGrey,
                ),
                elevation: 15.0,
                onPressed: () {
                  UrlLauncherUtils.sendEmail(
                      'hello.ifin@gmail.com',
                      'iFIN - Help %26 Support',
                      'Please type your query/issue here with your mobile number.. We will get back to you ASAP!');
                },
                label: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    'Email',
                    style: TextStyle(
                      color: CustomColors.mfinButtonGreen,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                color: CustomColors.mfinBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              Spacer(
                flex: 1,
              ),
              RaisedButton.icon(
                icon: Icon(
                  Icons.phone,
                  color: CustomColors.mfinLightGrey,
                ),
                elevation: 15.0,
                onPressed: () {
                  UrlLauncherUtils.makePhoneCall(9361808580);
                },
                label: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    'Phone',
                    style: TextStyle(
                      color: CustomColors.mfinButtonGreen,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                color: CustomColors.mfinBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
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
