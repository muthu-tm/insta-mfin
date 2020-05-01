import 'package:flutter/material.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

Widget viewCustomerWidget(title, Color color, subtitle, int totalCount) {
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
            color: CustomColors.mfinWhite,
            fontSize: 25.0,
          ),
        ),
        subtitle: new Text(
          subtitle,
          style: TextStyle(
            color: CustomColors.mfinLightGrey,
            fontSize: 18.0,
          ),
        ),
        trailing: new Text(
          totalCount.toString(),
          style: TextStyle(
            color: CustomColors.mfinLightGrey,
            fontSize: 25.0,
          ),
        ),
      ),
    ),
  );
}
