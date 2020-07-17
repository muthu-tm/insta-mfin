import 'package:flutter/material.dart';
import 'package:instamfin/screens/app/appBar.dart';
import 'package:instamfin/screens/chit/widgets/ActiveChitWidget.dart';
import 'package:instamfin/screens/chit/widgets/ClosedChitWidget.dart';
import 'package:instamfin/screens/home/UserFinanceSetup.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class ChitHome extends StatefulWidget {
  @override
  _ChitHomeState createState() => _ChitHomeState();
}

class _ChitHomeState extends State<ChitHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await UserController().refreshUser(false);
        return Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) => UserFinanceSetup(),
          ),
          (Route<dynamic> route) => false,
        );
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: topAppBar(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showMaterialModalBottomSheet(
                expand: false,
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context, scrollController) {
                  return Material(
                      child: SafeArea(
                    top: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          title: Text('Publish New Chit'),
                          leading: Icon(
                            Icons.add_box,
                            color: CustomColors.mfinBlue,
                          ),
                          onTap: () async {},
                        ),
                        ListTile(
                            title: Text('Add Chit Template'),
                            leading: Icon(
                              Icons.add,
                              color: CustomColors.mfinBlue,
                            ),
                            onTap: () {}),
                        ListTile(
                          title: Text('View Chit Template'),
                          leading: Icon(
                            Icons.remove_red_eye,
                            color: CustomColors.mfinBlue,
                          ),
                          onTap: () {},
                        ),
                        ListTile(
                          title: Text('Home'),
                          leading: Icon(
                            Icons.home,
                            color: CustomColors.mfinBlue,
                          ),
                          onTap: () async {
                            await UserController().refreshUser(false);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserFinanceSetup(),
                                settings: RouteSettings(name: '/home'),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ));
                });
          },
          backgroundColor: CustomColors.mfinBlue,
          splashColor: CustomColors.mfinWhite,
          child: Icon(
            Icons.navigation,
            size: 30,
            color: CustomColors.mfinButtonGreen,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(padding: EdgeInsets.all(5)),
              ActiveChitWidget(),
              Padding(padding: EdgeInsets.all(5)),
              ClosedChitWidget(),
              Padding(padding: EdgeInsets.all(35)),
            ],
          ),
        ),
      ),
    );
  }
}
