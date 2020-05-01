import 'package:flutter/material.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

Widget viewCustomerWidget(title, Color color) {
  return Container(
    height: 200,
    color: color,
    child: Card(
      color: color,
      child: ListTile(
        leading: Icon(
          Icons.supervisor_account,
          size: 50.0,
          color: CustomColors.mfinLightGrey,
        ),
        title: new Text(
          title,
          style: TextStyle(
            color: CustomColors.mfinLightGrey,
            fontSize: 25.0,
          ),
        ),
      ),
    ),
  );
}
