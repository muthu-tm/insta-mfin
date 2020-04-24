import 'package:flutter/material.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class BranchWidget extends StatefulWidget {
  @override
  _BranchWidgetState createState() => _BranchWidgetState();
}

class _BranchWidgetState extends State<BranchWidget> {
  @override
  Widget build(BuildContext context) {
    return new Column(
            children: <Widget>[
              ListTile(
                title: TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Branch_Name01',
                    fillColor: CustomColors.mfinWhite,
                    filled: true,
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 5.0),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.mfinGrey)),
                  ),
                ),
              ),
              ListTile(
                title: TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Registered Date',
                    fillColor: CustomColors.mfinWhite,
                    filled: true,
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 5.0),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.mfinGrey)),
                  ),
                ),
              ),
              new Text(""),
            ],
    );
  }
}
