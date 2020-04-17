import 'package:flutter/material.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

Widget buildAddressWidget(String addreesTitle) {
  return new Card(
    color: CustomColors.mfinLightGrey,
    child: new Column(
      children: <Widget>[
        ListTile(
          leading: new Text(
            addreesTitle,
            style: TextStyle(
                color: CustomColors.mfinGrey,
                fontWeight: FontWeight.bold,
                fontSize: 17),
          ),
        ),
        ListTile(
          title: TextFormField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: 'Building No. & Street',
              fillColor: CustomColors.mfinWhite,
              filled: true,
              contentPadding:
                  new EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            ),
          ),
        ),
        ListTile(
          title: TextFormField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: 'City',
              fillColor: CustomColors.mfinWhite,
              filled: true,
              contentPadding:
                  new EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            ),
          ),
        ),
        ListTile(
          title: TextFormField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: 'State',
              fillColor: CustomColors.mfinWhite,
              filled: true,
              contentPadding:
                  new EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            ),
          ),
        ),
        ListTile(
          title: TextFormField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: 'Pincode',
              fillColor: CustomColors.mfinWhite,
              filled: true,
              contentPadding:
                  new EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            ),
          ),
        ),
        new Text(""),
      ],
    ),
  );
}
