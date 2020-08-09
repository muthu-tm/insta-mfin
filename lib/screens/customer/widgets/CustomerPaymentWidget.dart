import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/db/enums/collection_type.dart';
import 'package:instamfin/db/models/collection.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/screens/customer/AddCustomCollection.dart';
import 'package:instamfin/screens/customer/ViewPayment.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';

import '../../../app_localizations.dart';

Widget customerPaymentWidget(BuildContext context,
    GlobalKey<ScaffoldState> _scaffoldKey, int index, Payment payment) {
  Color cColor = CustomColors.mfinBlue;
  if (payment.isSettled) cColor = CustomColors.mfinGrey;

  return Builder(
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 2.0,
          top: 5,
          right: 2.0,
          bottom: 5,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Material(
              color: cColor,
              elevation: 5.0,
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                width: 140,
                height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 120,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Spacer(),
                          Text(
                            DateUtils.getFormattedDateFromEpoch(
                                payment.dateOfPayment),
                            style: TextStyle(
                                color: CustomColors.mfinWhite,
                                fontFamily: 'Georgia',
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                          Divider(
                            color: CustomColors.mfinButtonGreen,
                          ),
                          Spacer(),
                          Text(
                            payment.totalAmount.toString(),
                            style: TextStyle(
                                color: CustomColors.mfinAlertRed,
                                fontFamily: 'Georgia',
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                          RichText(
                            text: TextSpan(
                              text: '${payment.tenure}',
                              style: TextStyle(
                                color: CustomColors.mfinWhite,
                                fontFamily: 'Georgia',
                                fontSize: 18.0,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: ' x ',
                                  style: TextStyle(
                                    color: CustomColors.mfinBlack,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: '${payment.collectionAmount}',
                                  style: TextStyle(
                                    color: CustomColors.mfinFadedButtonGreen,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Divider(
                            color: CustomColors.mfinWhite,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      child: FlatButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewPayment(payment),
                              settings:
                                  RouteSettings(name: '/customers/payment'),
                            ),
                          );
                        },
                        icon: Icon(Icons.remove_red_eye,
                            color: CustomColors.mfinFadedButtonGreen),
                        label: Text(
                          AppLocalizations.of(context).translate('view'),
                          style: TextStyle(
                            fontSize: 16,
                            color: CustomColors.mfinFadedButtonGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            payment.isSettled
                ? getSettledPaymentsDetails(payment)
                : getPaymentDetails(_scaffoldKey, payment),
          ],
        ),
      );
    },
  );
}

Widget getPaymentDetails(
    GlobalKey<ScaffoldState> _scaffoldKey, Payment payment) {
  return StreamBuilder(
    stream: Collection().streamCollectionsForPayment(payment.financeID,
        payment.branchName, payment.subBranchName, payment.id),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> paidSnap) {
      Widget child;

      if (paidSnap.hasData) {
        if (paidSnap.data.documents.length > 0) {
          List<Collection> colls = [];
          int _r = 0;
          int _p = 0;
          int _c = 0;
          int _u = 0;

          paidSnap.data.documents.forEach((doc) {
            Collection coll = Collection.fromJson(doc.data);
            if (coll.type != CollectionType.DocCharge.name &&
                coll.type != CollectionType.Surcharge.name &&
                coll.type != CollectionType.Penalty.name &&
                coll.type != CollectionType.Commission.name) {
              _r += coll.getReceived();
              _p += coll.getPending();
              _c += coll.getCurrent();
              _u += coll.getUpcoming();

              colls.add(coll);
            }
          });

          child = Column(
            children: <Widget>[
              SizedBox(
                height: 120,
                child: Column(
                  children: <Widget>[
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 2.0, top: 5.0),
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('received_caps'),
                            style: TextStyle(
                              fontSize: 14,
                              color: CustomColors.mfinBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 2.0, top: 5.0),
                          child: Text(
                            '$_r',
                            style: TextStyle(
                              fontSize: 14,
                              color: CustomColors.mfinPositiveGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 2.0, top: 2.0),
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('pending_caps'),
                            style: TextStyle(
                              fontSize: 14,
                              color: CustomColors.mfinBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 2.0, top: 2.0),
                          child: Text(
                            '$_p',
                            style: TextStyle(
                              fontSize: 14,
                              color: CustomColors.mfinAlertRed,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 2.0, top: 2.0),
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('today_caps'),
                            style: TextStyle(
                              fontSize: 14,
                              color: CustomColors.mfinBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 2.0, top: 2.0),
                          child: Text(
                            '$_c',
                            style: TextStyle(
                              fontSize: 14,
                              color: CustomColors.mfinBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 2.0, top: 2.0),
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('upcoming_caps'),
                            style: TextStyle(
                              fontSize: 14,
                              color: CustomColors.mfinBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 2.0, top: 2.0),
                          child: Text(
                            '$_u',
                            style: TextStyle(
                              fontSize: 14,
                              color: CustomColors.mfinGrey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Divider(
                      color: CustomColors.mfinButtonGreen,
                    ),
                    Spacer(),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
                child: FlatButton.icon(
                  onPressed: () {
                    if (payment.totalAmount == _r) {
                      _scaffoldKey.currentState.showSnackBar(
                        CustomSnackBar.errorSnackBar(
                            "You have collected total amount, Please Do Settlement!",
                            2),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AddCustomCollection(payment, colls, _r),
                          settings: RouteSettings(
                              name: '/customers/payment/collections/add'),
                        ),
                      );
                    }
                  },
                  icon: Icon(Icons.collections_bookmark),
                  label: Text(
                    AppLocalizations.of(context).translate('add_collection'),
                  ),
                ),
              ),
              Spacer(),
            ],
          );
        }
      } else if (paidSnap.hasError) {
        child = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: AsyncWidgets.asyncError());
      } else {
        child = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: AsyncWidgets.asyncWaiting());
      }

      return Material(
        color: CustomColors.mfinLightGrey,
        elevation: 5.0,
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
            height: 150,
            width: MediaQuery.of(context).size.width - 155,
            child: child),
      );
    },
  );
}

Widget getSettledPaymentsDetails(Payment payment) {
  return FutureBuilder(
    future: payment.getTotalReceived(),
    builder: (BuildContext context, AsyncSnapshot<int> paidSnap) {
      Widget child;

      if (paidSnap.hasData) {
        child = InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewPayment(payment),
                settings: RouteSettings(name: '/customers/payment'),
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 30,
                child: ListTile(
                  leading: Text(
                    AppLocalizations.of(context).translate("received_caps"),
                    style: TextStyle(
                      fontSize: 14,
                      color: CustomColors.mfinBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Text(
                    payment.principalAmount.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      color: CustomColors.mfinPositiveGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
                child: ListTile(
                  leading: Text(
                    AppLocalizations.of(context).translate('pending_caps'),
                    style: TextStyle(
                      fontSize: 14,
                      color: CustomColors.mfinBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Text(
                    paidSnap.data.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      color: CustomColors.mfinPositiveGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              payment.lossAmount > 0
                  ? SizedBox(
                      height: 30,
                      child: ListTile(
                        leading: Text(
                          AppLocalizations.of(context).translate('loss'),
                          style: TextStyle(
                            fontSize: 14,
                            color: CustomColors.mfinBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Text(
                          payment.lossAmount.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            color: CustomColors.mfinAlertRed,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : payment.profitAmount > 0
                      ? SizedBox(
                          height: 30,
                          child: ListTile(
                            leading: Text(
                              AppLocalizations.of(context).translate('profit'),
                              style: TextStyle(
                                fontSize: 14,
                                color: CustomColors.mfinBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                              payment.profitAmount.toString(),
                              style: TextStyle(
                                fontSize: 14,
                                color: CustomColors.mfinPositiveGreen,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      : Container(),
              SizedBox(
                height: 30,
                child: ListTile(
                  leading: Text(
                    AppLocalizations.of(context).translate('upcoming_caps'),
                    style: TextStyle(
                      fontSize: 14,
                      color: CustomColors.mfinBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Text(
                    DateUtils.formatDate(DateTime.fromMillisecondsSinceEpoch(
                        payment.settledDate)),
                    style: TextStyle(
                      fontSize: 14,
                      color: CustomColors.mfinGrey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      } else if (paidSnap.hasError) {
        child = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: AsyncWidgets.asyncError());
      } else {
        child = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: AsyncWidgets.asyncWaiting());
      }

      return Material(
        color: CustomColors.mfinLightGrey,
        elevation: 5.0,
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
            width: MediaQuery.of(context).size.width * 0.60,
            height: 150,
            child: child),
      );
    },
  );
}
