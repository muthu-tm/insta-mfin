import 'package:flutter/material.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

Widget buildFinanceDetails(String title) {
  return new Card(
    color: CustomColors.mfinLightGrey,
    child: new Column(
      children: <Widget>[
        ListTile(
            leading: Icon(
              Icons.work,
              size: 30,
              color: CustomColors.mfinFadedButtonGreen,
            ),
            title: new Text(
              title,
              style: TextStyle(color: CustomColors.mfinBlue),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.edit,
                color: CustomColors.mfinBlue,
              ),
              onPressed: () {},
            )),
        ListTile(
          leading: Icon(Icons.account_balance,
              color: CustomColors.mfinBlue, size: 30.0),
          title: TextFormField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: 'Company_Name',
              fillColor: CustomColors.mfinWhite,
              filled: true,
              contentPadding:
                  new EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: CustomColors.mfinGrey)),
            ),
            enabled: false,
            autofocus: false,
          ),
        ),
        ListTile(
          leading:
              Icon(Icons.view_stream, color: CustomColors.mfinBlue, size: 30.0),
          title: TextFormField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: 'Branch_Name',
              fillColor: CustomColors.mfinWhite,
              filled: true,
              contentPadding:
                  new EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: CustomColors.mfinGrey)),
            ),
            enabled: false,
            autofocus: false,
          ),
        ),
        ListTile(
          leading: Icon(Icons.view_headline,
              color: CustomColors.mfinBlue, size: 30.0),
          title: TextFormField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: 'Sub_Branch',
              contentPadding:
                  new EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
              fillColor: CustomColors.mfinWhite,
              filled: true,
              enabled: false,
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: CustomColors.mfinGrey)),
            ),
            enabled: false,
            autofocus: false,
          ),
        ),
        new Text(""),
      ],
    ),
  );
}
