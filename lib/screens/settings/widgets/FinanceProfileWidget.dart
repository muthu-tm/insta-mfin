import 'package:flutter/material.dart';
import 'package:instamfin/db/models/finance.dart';
import 'package:instamfin/screens/settings/editors/EditFinanceProfile.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class FinanceProfileWidget extends StatelessWidget {
  // FinanceProfileWidget(this.finance);

  // final Finance finance;

  @override
  Widget build(BuildContext context) {
    return new Card(
      color: CustomColors.mfinLightGrey,
      child: new Column(
        children: <Widget>[
          ListTile(
              leading: Icon(
                Icons.account_balance,
                size: 30,
                color: CustomColors.mfinButtonGreen,
              ),
              title: new Text(
                "Finance Details",
                style: TextStyle(color: CustomColors.mfinBlue),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.edit,
                  color: CustomColors.mfinBlue,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditFinanceProfile()),
                  );
                },
              )),
          ListTile(
            title: TextFormField(
              keyboardType: TextInputType.text,
              // initialValue: finance.financeName,
              decoration: InputDecoration(
                hintText: 'Finance Name',
                fillColor: CustomColors.mfinWhite,
                filled: true,
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: CustomColors.mfinGrey)),
              ),
              enabled: false,
              autofocus: false,
            ),
          ),
          ListTile(
            title: TextFormField(
              keyboardType: TextInputType.text,
              // initialValue: finance.registrationID,
              decoration: InputDecoration(
                hintText: 'Registered ID',
                fillColor: CustomColors.mfinWhite,
                filled: true,
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: CustomColors.mfinGrey)),
              ),
              enabled: false,
              autofocus: false,
            ),
          ),
          ListTile(
            title: TextFormField(
              keyboardType: TextInputType.text,
              // initialValue: finance.dateOfRegistration,
              decoration: InputDecoration(
                hintText: 'Registered Date',
                fillColor: CustomColors.mfinWhite,
                filled: true,
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: CustomColors.mfinGrey)),
              ),
              enabled: false,
              autofocus: false,
            ),
          ),
          ListTile(
            title: TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: 'Contact Number',
                fillColor: CustomColors.mfinWhite,
                filled: true,
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: CustomColors.mfinGrey)),
              ),
              enabled: false,
              autofocus: false,
            ),
          ),
          ListTile(
            title: new TextFormField(
              keyboardType: TextInputType.text,
              // initialValue: finance.emails.toString(),
              decoration: InputDecoration(
                hintText: 'Finance EmailID',
                fillColor: CustomColors.mfinWhite,
                filled: true,
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: CustomColors.mfinWhite)),
              ),
              enabled: false,
              autofocus: false,
            ),
          ),
          ListTile(
            title: TextFormField(
              keyboardType: TextInputType.text,
              // initialValue: finance.address.toString(),
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Finance Address',
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                fillColor: CustomColors.mfinWhite,
                filled: true,
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: CustomColors.mfinGrey)),
              ),
              enabled: false,
              autofocus: false,
            ),
          ),
        ],
      ),
    );
  }
}
