import 'package:flutter/material.dart';
import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class AddressWidget extends StatefulWidget {
  AddressWidget(this.addreesTitle, this.address, this.updatedAddress);

  final String addreesTitle;
  final Address address;
  final Address updatedAddress;

  @override
  _AddressWidgetState createState() => _AddressWidgetState();
}

class _AddressWidgetState extends State<AddressWidget> {
  @override
  Widget build(BuildContext context) {
    return new Card(
      color: CustomColors.mfinLightGrey,
      child: new Column(
        children: <Widget>[
          ListTile(
            leading: new Text(
              widget.addreesTitle,
              style: TextStyle(
                  color: CustomColors.mfinGrey,
                  fontWeight: FontWeight.bold,
                  fontSize: 17),
            ),
          ),
          ListTile(
            title: TextFormField(
              initialValue: widget.address.street,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: 'Building No. & Street',
                fillColor: CustomColors.mfinWhite,
                filled: true,
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
              ),
              validator: (street) {
                if (street.trim() != "") {
                  widget.updatedAddress.street = street.trim();
                }
                return null;
              },
            ),
          ),
          ListTile(
            title: TextFormField(
              keyboardType: TextInputType.text,
              initialValue: widget.address.city,
              decoration: InputDecoration(
                hintText: 'City',
                fillColor: CustomColors.mfinWhite,
                filled: true,
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
              ),
              validator: (city) {
                if (city.trim() != "") {
                  widget.updatedAddress.city = city.trim();
                }
                return null;
              },
            ),
          ),
          ListTile(
            title: TextFormField(
              keyboardType: TextInputType.text,
              initialValue: widget.address.state,
              decoration: InputDecoration(
                hintText: 'State',
                fillColor: CustomColors.mfinWhite,
                filled: true,
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
              ),
              validator: (state) {
                if (state.trim() != "") {
                  widget.updatedAddress.state = state.trim();
                }
                return null;
              },
            ),
          ),
          ListTile(
            title: TextFormField(
              keyboardType: TextInputType.text,
              initialValue: widget.address.pincode,
              decoration: InputDecoration(
                hintText: 'Pincode',
                fillColor: CustomColors.mfinWhite,
                filled: true,
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
              ),
              validator: (pinCode) {
                if (pinCode.trim() != "") {
                  widget.updatedAddress.pincode = pinCode.trim();
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
