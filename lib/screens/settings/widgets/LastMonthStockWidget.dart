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
              fontSize: 15.0,
            ),
          ),
          new Spacer(
            flex: 1,
          ),
          Container(
            height: 25.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  value,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
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
