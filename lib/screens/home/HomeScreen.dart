import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/db/models/customer.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
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
                          padding: EdgeInsets.all(10.0),
                          child: Stack(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 32, left: 8, right: 8, bottom: 16),
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 10.0),
                                  decoration: BoxDecoration(
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color: CustomColors.mfinButtonGreen
                                              .withOpacity(0.6),
                                          offset: const Offset(1.1, 4.0),
                                          blurRadius: 8.0),
                                    ],
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        CustomColors.mfinButtonGreen,
                                        CustomColors.mfinBlue,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(8.0),
                                      bottomLeft: Radius.circular(8.0),
                                      topLeft: Radius.circular(8.0),
                                      topRight: Radius.circular(54.0),
                                    ),
                                  ),
                                  height: 150,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 70, left: 5, right: 5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              "Cash In Hand",
                                              style: TextStyle(
                                                fontSize: 17.0,
                                                color: CustomColors.mfinWhite,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 20),
                                            getCIHAmount(context),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 15,
                                left: 0,
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: CustomColors.mfinLightGrey
                                        .withOpacity(0.3),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 30,
                                left: 16,
                                child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: CustomColors.mfinBlue,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Icon(
                                        Icons.grade,
                                        size: 35,
                                        color: CustomColors.mfinButtonGreen,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Stack(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 32, left: 8, right: 8, bottom: 16),
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 10.0),
                                  decoration: BoxDecoration(
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color: CustomColors.mfinAlertRed
                                              .withOpacity(0.6),
                                          offset: const Offset(1.1, 4.0),
                                          blurRadius: 8.0),
                                    ],
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        CustomColors.mfinAlertRed,
                                        CustomColors.mfinBlue,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(8.0),
                                      bottomLeft: Radius.circular(8.0),
                                      topLeft: Radius.circular(8.0),
                                      topRight: Radius.circular(54.0),
                                    ),
                                  ),
                                  height: 150,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 70, left: 5, right: 5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              "Outstanding",
                                              style: TextStyle(
                                                fontSize: 17.0,
                                                color: CustomColors.mfinWhite,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 20),
                                            getStockAmount(context),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 15,
                                left: 0,
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: CustomColors.mfinLightGrey
                                        .withOpacity(0.3),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 30,
                                left: 16,
                                child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: CustomColors.mfinGrey,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Icon(
                                        Icons.featured_play_list,
                                        size: 30,
                                        color: CustomColors.mfinAlertRed,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 10.0, right: 10.0, bottom: 10.0),
                      child: getCustomerCard(context),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 10.0, right: 10.0, bottom: 10.0),
                      child: getCustomerCard(context),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 10.0, right: 10.0, bottom: 10.0),
                      child: getCustomerCard(context),
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

  Widget getCustomerCard(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Color(0xffE8F2F7),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(0xff7AC1E7),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.group,
                      size: 30,
                      color: CustomColors.mfinWhite,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 20),
          getCustomerData(context),
        ],
      ),
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
          children = <Widget>[
            Text(
              amount.toString(),
              style: TextStyle(
                fontSize: 17.0,
                color: CustomColors.mfinLightGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ];
        } else if (snapshot.hasError) {
          children = AsyncWidgets.asyncError();
        } else {
          children = AsyncWidgets.asyncWaiting();
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children,
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
              '$amount',
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

  Widget getCustomerData(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: Customer().getAllCustomers(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          int tCount = snapshot.data.documents.length;

          children = <Widget>[
            Text(
              'Total Customers - $tCount',
              style: TextStyle(
                fontSize: 17.0,
                color: CustomColors.mfinBlue,
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
