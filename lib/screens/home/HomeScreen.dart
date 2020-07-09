import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/db/models/collection.dart';
import 'package:instamfin/db/models/finance.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/app/ProfilePictureUpload.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/settings/editors/EditPrimaryFinance.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HomeScreen extends StatelessWidget {
  final User _u = UserController().getCurrentUser();

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
            child: Column(
              children: <Widget>[
                SizedBox(height: 40.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        text: "Welcome Back, ",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: CustomColors.mfinLightGrey,
                          fontFamily: 'Georgia',
                          fontWeight: FontWeight.w600,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: '${_u.name}!',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: CustomColors.mfinLightGrey,
                              fontFamily: 'Georgia',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: "Edit Primary Finance",
                      alignment: Alignment.centerRight,
                      icon: Icon(
                        Icons.edit,
                        size: 25,
                        color: CustomColors.mfinButtonGreen,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditPrimaryFinance(
                              _u.mobileNumber,
                            ),
                            settings: RouteSettings(
                                name: '/settings/user/primary/edit'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                getFinanceDetails(context),
              ],
            ),
          ),
          Positioned(
            top: 270,
            bottom: 0,
            width: MediaQuery.of(context).size.width,
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: CustomColors.mfinLightGrey,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30.0),
                  topLeft: Radius.circular(30.0),
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
                          padding: EdgeInsets.only(right: 10.0, left: 10.0),
                          child: Stack(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 16, left: 8, right: 8, bottom: 16),
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
                                                fontFamily: "Georgia",
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
                                top: -5,
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
                                top: 10,
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
                          padding: EdgeInsets.only(right: 10.0, left: 10.0),
                          child: Stack(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 16, left: 8, right: 8, bottom: 16),
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
                                        padding: EdgeInsets.only(top: 70),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              "Outstanding",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 17.0,
                                                fontFamily: "Georgia",
                                                color: CustomColors.mfinWhite,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            getStockAmount(context),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: -5,
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
                                top: 10,
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
                    getPresentCard(context),
                    Padding(
                      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          getPastCard(context),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.03),
                          getUpcomingCard(context),
                        ],
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

  Widget getPresentCard(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.98,
      decoration: BoxDecoration(
        color: CustomColors.mfinBlue,
        borderRadius: const BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      height: 140,
      child: getTodayCollectionData(context),
    );
  }

  Widget getPastCard(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.475,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            CustomColors.mfinFadedButtonGreen,
            CustomColors.mfinLightBlue,
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(3.0),
          bottomLeft: Radius.circular(25.0),
          topLeft: Radius.circular(3.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      height: 150,
      child: getPastCollectionData(context),
    );
  }

  Widget getUpcomingCard(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.475,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            CustomColors.mfinFadedButtonGreen,
            CustomColors.mfinGrey,
          ],
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
        ),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(25.0),
          bottomLeft: Radius.circular(3.0),
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(3.0),
        ),
      ),
      height: 150,
      child: getUpcomingCollectionData(context),
    );
  }

  Widget getCIHAmount(BuildContext context) {
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
              'Rs.$amount',
              style: TextStyle(
                fontSize: 17.0,
                fontFamily: "Georgia",
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
    return FutureBuilder<DocumentSnapshot>(
      future: _u.getFinanceDocReference().get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          Map<String, dynamic> finDoc = snapshot.data.data;
          int tPay = finDoc['accounts_data']['total_payments'];
          int pAmount = finDoc['accounts_data']['payments_amount'];
          int cAmount = finDoc['accounts_data']['collections_amount'];

          children = <Widget>[
            Text(
              '$tPay',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: "Georgia",
                color: CustomColors.mfinLightGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Rs.${pAmount - cAmount}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17.0,
                fontFamily: "Georgia",
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

  Widget getTodayCollectionData(BuildContext context) {
    return FutureBuilder<List<Collection>>(
      future: Collection().getAllCollectionByDate(
          _u.primary.financeID,
          _u.primary.branchName,
          _u.primary.subBranchName,
          [0],
          false,
          DateUtils.getUTCDateEpoch(DateTime.now())),
      builder:
          (BuildContext context, AsyncSnapshot<List<Collection>> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          int amount = 0;
          int rAmount = 0;
          int total = snapshot.data.length;

          snapshot.data.forEach((coll) {
            amount += coll.collectionAmount;
            rAmount += coll.getReceived();
          });

          children = <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Todays Collection',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontFamily: "Georgia",
                        color: CustomColors.mfinLightGrey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Total: $total',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: "Georgia",
                        color: CustomColors.mfinGrey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Amount: Rs.$amount',
                      style: TextStyle(
                        fontSize: 17.0,
                        fontFamily: "Georgia",
                        color: CustomColors.mfinGrey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: CircularPercentIndicator(
                    radius: 80.0,
                    lineWidth: 10.0,
                    animation: true,
                    percent: rAmount == 0 ? 0.00 : (rAmount / amount),
                    center: Icon(
                      Icons.collections_bookmark,
                      size: 30.0,
                      color: CustomColors.mfinFadedButtonGreen.withOpacity(0.9),
                    ),
                    footer: new Text(
                      "Rs.$rAmount",
                      style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Georgia",
                          fontSize: 17.0),
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    backgroundColor: amount == 0
                        ? CustomColors.mfinGrey
                        : CustomColors.mfinAlertRed.withOpacity(0.7),
                    progressColor:
                        CustomColors.mfinFadedButtonGreen.withOpacity(0.9),
                  ),
                ),
              ],
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

  Widget getPastCollectionData(BuildContext context) {
    return FutureBuilder<List<Collection>>(
      future: Collection().allCollectionByDate(
          _u.primary.financeID,
          _u.primary.branchName,
          _u.primary.subBranchName,
          [0],
          DateUtils.getUTCDateEpoch(
              DateTime.now().subtract(Duration(days: 1)))),
      builder:
          (BuildContext context, AsyncSnapshot<List<Collection>> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          int amount = 0;
          int rAmount = 0;
          int total = snapshot.data.length;

          snapshot.data.forEach((coll) {
            amount += coll.collectionAmount;
            rAmount += coll.getReceived();
          });

          children = <Widget>[
            Text(
              'Yesterday',
              style: TextStyle(
                fontSize: 22.0,
                fontFamily: "Georgia",
                color: CustomColors.mfinLightGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Total: $total',
              style: TextStyle(
                fontSize: 14.0,
                fontFamily: "Georgia",
                color: CustomColors.mfinBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Amount:  Rs.$amount',
              style: TextStyle(
                fontSize: 14.0,
                fontFamily: "Georgia",
                color: CustomColors.mfinBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Received: Rs.$rAmount',
              style: TextStyle(
                fontSize: 14.0,
                fontFamily: "Georgia",
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        );
      },
    );
  }

  Widget getUpcomingCollectionData(BuildContext context) {
    return FutureBuilder<List<Collection>>(
      future: Collection().getAllCollectionByDate(
          _u.primary.financeID,
          _u.primary.branchName,
          _u.primary.subBranchName,
          [0],
          false,
          DateUtils.getUTCDateEpoch(DateTime.now().add(Duration(days: 1)))),
      builder:
          (BuildContext context, AsyncSnapshot<List<Collection>> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          int amount = 0;
          int rAmount = 0;
          int total = snapshot.data.length;

          snapshot.data.forEach((coll) {
            amount += coll.collectionAmount;
            rAmount += coll.getReceived();
          });

          children = <Widget>[
            Text(
              'Tomorrow',
              style: TextStyle(
                fontSize: 22.0,
                fontFamily: "Georgia",
                color: CustomColors.mfinLightGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Total: $total',
              style: TextStyle(
                fontSize: 14.0,
                fontFamily: "Georgia",
                color: CustomColors.mfinBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Amount:  Rs.$amount',
              style: TextStyle(
                fontSize: 14.0,
                fontFamily: "Georgia",
                color: CustomColors.mfinBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Received: Rs.$rAmount',
              style: TextStyle(
                fontSize: 14.0,
                fontFamily: "Georgia",
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        );
      },
    );
  }

  Widget getFinanceDetails(BuildContext context) {
    return FutureBuilder<Finance>(
      future: UserController().getPrimaryFinance(),
      builder: (BuildContext context, AsyncSnapshot<Finance> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          if (snapshot.data != null) {
            Finance fin = snapshot.data;

            children = <Widget>[
              fin.getProfilePicPath() == ""
                  ? Padding(
                      padding: EdgeInsets.all(5),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: CustomColors.mfinFadedButtonGreen,
                          border: Border.all(
                            style: BorderStyle.solid,
                            width: 2.0,
                          ),
                        ),
                        child: FlatButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              routeSettings:
                                  RouteSettings(name: "/profile/upload"),
                              builder: (context) {
                                return Center(
                                  child: ProfilePictureUpload(
                                      2,
                                      fin.getProfilePicPath(),
                                      fin.getID(),
                                      _u.mobileNumber),
                                );
                              },
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Icon(
                                Icons.account_balance,
                                size: 50.0,
                                color: CustomColors.mfinBlue,
                              ),
                              Text(
                                "Upload",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                  color: CustomColors.mfinBlue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Container(
                      width: 100,
                      height: 100,
                      child: Stack(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 50.0,
                            backgroundImage:
                                NetworkImage(snapshot.data.getProfilePicPath()),
                            backgroundColor: Colors.transparent,
                          ),
                          Positioned(
                            bottom: -12,
                            left: 40,
                            child: FlatButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  routeSettings:
                                      RouteSettings(name: "/profile/upload"),
                                  builder: (context) {
                                    return Center(
                                      child: ProfilePictureUpload(
                                          2,
                                          fin.getProfilePicPath(),
                                          fin.getID(),
                                          _u.mobileNumber),
                                    );
                                  },
                                );
                              },
                              child: CircleAvatar(
                                backgroundColor: CustomColors.mfinButtonGreen,
                                radius: 10,
                                child: Icon(
                                  Icons.edit,
                                  color: CustomColors.mfinBlue,
                                  size: 15.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              Text(
                fin.financeName,
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'Georgia',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _u.primary.branchName,
                style: TextStyle(
                  fontSize: 17.0,
                  fontFamily: 'Georgia',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _u.primary.subBranchName,
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Georgia',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5.0),
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
      },
    );
  }
}
