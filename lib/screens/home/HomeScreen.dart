import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/ColorLoader.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.mfinBlue,
      body: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
              color: CustomColors.mfinBlue,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(40.0),
                bottomLeft: Radius.circular(40.0),
              ),
            ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: getFinanceDetails(context),
          ),
          Positioned(
            top: 300,
            bottom: 0,
            width: MediaQuery.of(context).size.width,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: CustomColors.mfinLightGrey,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40.0),
                  topLeft: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Material(
                            elevation: 10.0,
                            color: CustomColors.mfinButtonGreen,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(60.0),
                              topLeft: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                            ),
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10.0),
                              padding: EdgeInsets.all(10.0),
                              height: 150,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    Icons.grade,
                                    size: 40,
                                    color: CustomColors.mfinBlue,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      getCIHAmount(context),
                                      SizedBox(height: 20),
                                      Text(
                                        "Cash In Hand",
                                        style: TextStyle(
                                          fontSize: 17.0,
                                          color: CustomColors.mfinWhite,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Material(
                            elevation: 10.0,
                            color: CustomColors.mfinAlertRed,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(60.0),
                              topLeft: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                            ),
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10.0),
                              padding: EdgeInsets.all(10.0),
                              height: 150,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    Icons.featured_play_list,
                                    size: 40,
                                    color: CustomColors.mfinGrey,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      getStockAmount(context),
                                      SizedBox(height: 20),
                                      Text(
                                        "OutStanding",
                                        style: TextStyle(
                                          fontSize: 17.0,
                                          color: CustomColors.mfinLightGrey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.0),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Material(
                        elevation: 10.0,
                        color: CustomColors.mfinBlue,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30.0),
                          topLeft: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                        ),
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                          padding: EdgeInsets.all(10.0),
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Icon(Icons.group)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  ColorLoader(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Material(
                        elevation: 10.0,
                        color: CustomColors.mfinAlertRed,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30.0),
                          topLeft: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                        ),
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                          padding: EdgeInsets.all(10.0),
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Icon(Icons.group)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Cash In Hand",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Material(
                        elevation: 10.0,
                        color: CustomColors.mfinGrey,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30.0),
                          topLeft: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                        ),
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                          padding: EdgeInsets.all(10.0),
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Icon(Icons.group)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Cash In Hand",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: bottomBar(context),
    );
  }

  Widget getCIHAmount(BuildContext context) {
    final User _u = UserController().getCurrentUser();

    return FutureBuilder<DocumentSnapshot>(
      future: _u.getFinanceDocReference().get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          Map<String, dynamic> finDoc = snapshot.data.data;
          int amount = finDoc['accounts_data']['cash_in_hand'];
          Color color = CustomColors.mfinLightGrey;
          if (amount < 0) color = CustomColors.mfinAlertRed;

          children = <Widget>[
            Text(
              amount.toString(),
              style: TextStyle(
                fontSize: 17.0,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ];
        } else if (snapshot.hasError) {
          children = AsyncWidgets.asyncError();
        } else {
          children = AsyncWidgets.asyncWaiting();
        }

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
        );
      },
    );
  }

  Widget getStockAmount(BuildContext context) {
    final User _u = UserController().getCurrentUser();

    return FutureBuilder<DocumentSnapshot>(
      future: _u.getFinanceDocReference().get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          Map<String, dynamic> finDoc = snapshot.data.data;
          int amount = finDoc['accounts_data']['payments_amount'];
          Color color = CustomColors.mfinLightGrey;
          if (amount == 0) color = CustomColors.mfinPositiveGreen;

          children = <Widget>[
            Text(
              amount.toString(),
              style: TextStyle(
                fontSize: 17.0,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ];
        } else if (snapshot.hasError) {
          children = AsyncWidgets.asyncError();
        } else {
          children = AsyncWidgets.asyncWaiting();
        }

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
        );
      },
    );
  }

  Widget getFinanceDetails(BuildContext context) {
    final UserController _userController = UserController();

    return FutureBuilder<Map<String, dynamic>>(
        future: _userController.getPrimaryFinanceDetails(),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          List<Widget> children;

          if (snapshot.hasData) {
            if (snapshot.data['finance_name'] != null) {
              children = <Widget>[
                SizedBox(height: 50.0),
                CircleAvatar(
                  radius: 40.0,
                  backgroundColor: CustomColors.mfinButtonGreen,
                  child: Icon(
                    Icons.account_balance,
                    size: 45.0,
                    color: CustomColors.mfinWhite,
                  ),
                ),
                SizedBox(height: 15.0),
                Text(
                  snapshot.data['finance_name'],
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'Georgia',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15.0),
                (snapshot.data['branch_name'] != "")
                    ? Text(
                        snapshot.data['branch_name'],
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'Georgia',
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Container(),
                SizedBox(height: 15.0),
                (snapshot.data['sub_branch_name'] != "")
                    ? Text(
                        snapshot.data['sub_branch_name'],
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'Georgia',
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Container(),
              ];
            }
          } else if (snapshot.hasError) {
            children = AsyncWidgets.asyncError();
          } else {
            children = AsyncWidgets.asyncWaiting();
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            ),
          );
        });
  }
}
