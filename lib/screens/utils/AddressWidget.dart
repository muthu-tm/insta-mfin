import 'package:flutter/material.dart';
import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

import '../../app_localizations.dart';

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
    return Card(
      color: CustomColors.mfinLightGrey,
      elevation: 5.0,
      margin: EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 40,
            alignment: Alignment.center,
            child: Text(
              widget.addreesTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontFamily: "Georgia",
                fontWeight: FontWeight.bold,
                color: CustomColors.mfinBlue,
              ),
            ),
          ),
          Divider(
            color: CustomColors.mfinBlue,
          ),
          Padding(
            padding: EdgeInsets.all(5.0),
            child: Row(
              children: <Widget>[
                Flexible(
                  child: TextFormField(
                    initialValue: widget.address.street,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)
                                    .translate('building_and_street'),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelStyle: TextStyle(
                        fontSize: 10.0,
                        color: CustomColors.mfinBlue,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: CustomColors.mfinFadedButtonGreen)),
                      fillColor: CustomColors.mfinWhite,
                      filled: true,
                    ),
                    validator: (street) {
                      if (street.trim() != "") {
                        widget.updatedAddress.street = street.trim();
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5.0),
            child: Row(
              children: <Widget>[
                Flexible(
                  child: TextFormField(
                    initialValue: widget.address.city,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)
                                    .translate('city'),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelStyle: TextStyle(
                        fontSize: 10.0,
                        color: CustomColors.mfinBlue,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: CustomColors.mfinFadedButtonGreen)),
                      fillColor: CustomColors.mfinWhite,
                      filled: true,
                    ),
                    validator: (city) {
                      if (city.trim() != "") {
                        widget.updatedAddress.city = city.trim();
                      }
                      return null;
                    },
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 5)),
                Flexible(
                  child: TextFormField(
                    initialValue: widget.address.state,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)
                                    .translate('state'),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelStyle: TextStyle(
                        fontSize: 10.0,
                        color: CustomColors.mfinBlue,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: CustomColors.mfinFadedButtonGreen)),
                      fillColor: CustomColors.mfinWhite,
                      filled: true,
                    ),
                    validator: (state) {
                      if (state.trim() != "") {
                        widget.updatedAddress.state = state.trim();
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5.0),
            child: Row(
              children: <Widget>[
                Flexible(
                  child: TextFormField(
                    initialValue: widget.address.pincode,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)
                                    .translate('pincode'),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelStyle: TextStyle(
                        fontSize: 10.0,
                        color: CustomColors.mfinBlue,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: CustomColors.mfinFadedButtonGreen)),
                      fillColor: CustomColors.mfinWhite,
                      filled: true,
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
          ),
        ],
      ),
    );
  }
}
