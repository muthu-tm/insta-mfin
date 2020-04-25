import 'package:flutter/material.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class RowHeaderText extends StatelessWidget {
  RowHeaderText({this.textName});

  final String textName;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: new EdgeInsets.only(left: 15.0, top: 10),
          child: new Text(
            textName,
            style: TextStyle(
                color: CustomColors.mfinGrey,
                fontWeight: FontWeight.bold,
                fontSize: 17),
          ),
        ),
      ],
    );
  }
}