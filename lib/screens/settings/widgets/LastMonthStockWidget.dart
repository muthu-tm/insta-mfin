import 'package:flutter/material.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

Widget lastMothStock() {
  return Container(
    // height: MediaQuery.of(context).size.height * 1.0,
    child:
        Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
      new Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            "Last Month stock: ",
            style: TextStyle(
              fontFamily: 'Georgia',
              color: CustomColors.mfinBlue,
              fontWeight: FontWeight.bold,
              fontSize: 17.0,
            ),
          ),
        ],
      )
    ]),
  );
}
