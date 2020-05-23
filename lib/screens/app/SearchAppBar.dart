import 'package:flutter/material.dart';
import 'package:instamfin/screens/customer/widgets/CustomerListWidget.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/IconButton.dart';

class SearchAppBar extends StatefulWidget {
  @override
  _SearchAppBarState createState() => new _SearchAppBarState();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
}

class _SearchAppBarState extends State<SearchAppBar> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          backgroundColor: CustomColors.mfinBlue,
          centerTitle: true,
          title: new TextField(
            style: new TextStyle(
              color: CustomColors.mfinWhite,
            ),
            decoration: new InputDecoration(
                prefixIcon: customIconButton(
                    Icons.search, 35.0, CustomColors.mfinWhite, () {
                  CustomerListWidget(widget._scaffoldKey, "All", 0, false);
                }),
                hintText: "Customer Search...",
                hintStyle: new TextStyle(color: CustomColors.mfinWhite)),
          ),
          actions: <Widget>[
            customIconButton(Icons.close, 35.0, CustomColors.mfinWhite, () {}),
          ]),
    );
  }
}
