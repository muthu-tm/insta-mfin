import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/db/enums/collection_type.dart';
import 'package:instamfin/db/models/collection.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/screens/customer/AddCustomCollection.dart';
import 'package:instamfin/screens/customer/ViewPayment.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/date_utils.dart';

Widget customerPaymentWidget(BuildContext context, int index, Payment payment) {
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
          children: <Widget>[
            Material(
              color: cColor,
              elevation: 10.0,
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.35,
                height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Spacer(
                      flex: 1,
                    ),
                    SizedBox(
                      height: 20,
                      child: Text(
                        DateUtils.getFormattedDateFromEpoch(
                            payment.dateOfPayment),
                        style: TextStyle(
                            color: CustomColors.mfinWhite,
                            fontFamily: 'Georgia',
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Divider(
                      color: CustomColors.mfinButtonGreen,
                    ),
                    Spacer(
                      flex: 1,
                    ),
                    SizedBox(
                      height: 20,
                      child: Text(
                        payment.totalAmount.toString(),
                        style: TextStyle(
                            color: CustomColors.mfinAlertRed,
                            fontFamily: 'Georgia',
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Spacer(
                      flex: 1,
                    ),
                    SizedBox(
                      height: 20,
                      child: RichText(
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
                    ),
                    Spacer(
                      flex: 1,
                    ),
                    Divider(),
                    Spacer(
                      flex: 1,
                    ),
                    FlatButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewPayment(payment),
                            settings: RouteSettings(name: '/customers/payment'),
                          ),
                        );
                      },
                      icon: Icon(Icons.remove_red_eye,
                          color: CustomColors.mfinButtonGreen),
                      label: Text(
                        "View",
                        style: TextStyle(
                          fontSize: 16,
                          color: CustomColors.mfinButtonGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Spacer(
                      flex: 1,
                    ),
                  ],
                ),
              ),
            ),
            payment.isSettled
                ? getSettledPaymentsDetails(payment)
                : getPaymentDetails(payment),
          ],
        ),
      );
    },
  );
}

Widget getPaymentDetails(Payment payment) {
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 5.0, left: 5.0, top: 5.0),
                    child: Text(
                      "RECEIVED",
                      style: TextStyle(
                        fontSize: 16,
                        color: CustomColors.mfinBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 5.0, top: 5.0),
                    child: Text(
                      '$_r',
                      style: TextStyle(
                        fontSize: 16,
                        color: CustomColors.mfinPositiveGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 5.0, left: 5.0, top: 2.0),
                    child: Text(
                      'PENDING',
                      style: TextStyle(
                        fontSize: 16,
                        color: CustomColors.mfinBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 5.0, top: 2.0),
                    child: Text(
                      '$_p',
                      style: TextStyle(
                        fontSize: 16,
                        color: CustomColors.mfinAlertRed,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 5.0, left: 5.0, top: 2.0),
                    child: Text(
                      'TODAY',
                      style: TextStyle(
                        fontSize: 16,
                        color: CustomColors.mfinBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 5.0, top: 2.0),
                    child: Text(
                      '$_c',
                      style: TextStyle(
                        fontSize: 16,
                        color: CustomColors.mfinBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 5.0, left: 5.0, top: 2.0),
                    child: Text(
                      'UPCOMING',
                      style: TextStyle(
                        fontSize: 16,
                        color: CustomColors.mfinBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 5.0, top: 2.0),
                    child: Text(
                      '$_u',
                      style: TextStyle(
                        fontSize: 16,
                        color: CustomColors.mfinGrey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Divider(),
              SizedBox(
                height: 25,
                child: FlatButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AddCustomCollection(payment, colls),
                        settings: RouteSettings(
                            name: '/customers/payment/collections/add'),
                      ),
                    );
                  },
                  icon: Icon(Icons.collections_bookmark),
                  label: Text("Add Collection"),
                ),
              ),
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
            width: MediaQuery.of(context).size.width * 0.60,
            height: 150,
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
        child = Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 30,
              child: ListTile(
                leading: Text(
                  "RECEIVED",
                  style: TextStyle(
                    fontSize: 18,
                    color: CustomColors.mfinBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Text(
                  paidSnap.data.toString(),
                  style: TextStyle(
                    fontSize: 17,
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
                  payment.isLoss ? 'LOSS' : 'PROFIT',
                  style: TextStyle(
                    fontSize: 17,
                    color: CustomColors.mfinBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Text(
                  payment.isLoss
                      ? payment.lossAmount.toString()
                      : payment.profitAmount.toString(),
                  style: TextStyle(
                    fontSize: 17,
                    color: payment.isLoss
                        ? CustomColors.mfinAlertRed
                        : CustomColors.mfinPositiveGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
              child: ListTile(
                leading: Text(
                  'SETTLED ON',
                  style: TextStyle(
                    fontSize: 16,
                    color: CustomColors.mfinBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Text(
                  DateUtils.formatDate(
                      DateTime.fromMillisecondsSinceEpoch(payment.settledDate)),
                  style: TextStyle(
                    fontSize: 15,
                    color: CustomColors.mfinGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
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
        elevation: 10.0,
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
            width: MediaQuery.of(context).size.width * 0.60,
            height: 120,
            child: child),
      );
    },
  );
}
