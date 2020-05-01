import 'package:flutter/material.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

Widget homeContainerWidget(labelName, value) {
  return Container(
      height: 45.0,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Spacer(
            flex: 2,
          ),
          Text(
            labelName,
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
            height: 40.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  value,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    color: CustomColors.mfinBlue,
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
