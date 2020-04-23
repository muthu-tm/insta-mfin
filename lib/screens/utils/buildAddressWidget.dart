import 'package:flutter/material.dart';
import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

Widget buildAddressWidget(String addreesTitle, Address address) {
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
            initialValue: address.street,
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
            initialValue: address.city,
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
            initialValue: address.state,
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
            initialValue: address.pincode,
            decoration: InputDecoration(
              hintText: 'Pincode',
              fillColor: CustomColors.mfinWhite,
              filled: true,
              contentPadding:
                  new EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            ),
          ),
        ),
      ],
    ),
  );
}
