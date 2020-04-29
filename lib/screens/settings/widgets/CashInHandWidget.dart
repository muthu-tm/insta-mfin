import 'package:flutter/material.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

Widget cashInHand() {
  return Container(
      height: 45.0,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          new Spacer(
            flex: 4,
          ),
          Text(
            "Cash In Hand: ",
            style: TextStyle(
              fontFamily: 'Georgia',
              color: CustomColors.mfinBlue,
              fontWeight: FontWeight.bold,
              fontSize: 22.0,
            ),
          ),
          new Spacer(
            flex: 1,
          ),
          Container(
            color: CustomColors.mfinPositiveGreen,
            height: 40.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  " Rs. 1,00,000 ",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    color: CustomColors.mfinLightGrey,
                  ),
                ),
              ],
            ),
          ),
          new Spacer(
            flex: 1,
          ),
        ],
      ));
}
