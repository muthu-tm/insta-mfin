import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/db/enums/collection_type.dart';
import 'package:instamfin/db/models/collection.dart';
import 'package:instamfin/db/models/collection_details.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:instamfin/services/pdf/pay_transaction_receipt.dart';

import '../../../app_localizations.dart';

class TransactionListWidget extends StatelessWidget {
  TransactionListWidget(this._scaffoldKey, this._payment);

  final GlobalKey<ScaffoldState> _scaffoldKey;
  final Payment _payment;

  @override
  Widget build(BuildContext context) {
    Map<int, List<CollectionDetails>> collList = {};
    return StreamBuilder(
      stream: Collection().streamCollectionsForPayment(_payment.financeID,
          _payment.branchName, _payment.subBranchName, _payment.id),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          if (snapshot.data.documents.length > 0) {
            snapshot.data.documents.forEach((doc) {
              Collection _c = Collection.fromJson(doc.data);
              if (_c.type != CollectionType.Commission.name &&
                  _c.type != CollectionType.DocCharge.name &&
                  _c.type != CollectionType.Surcharge.name) {
                if (_c.getReceived() > 0) {
                  for (var item in _c.collectedOn) {
                    if (collList.containsKey(item)) {
                      collList[item].add(_c.collections.firstWhere(
                          (element) => element.collectedOn == item));
                    } else {
                      collList[item] = [
                        _c.collections.firstWhere(
                            (element) => element.collectedOn == item)
                      ];
                    }
                  }
                }
              }
            });

            if (collList.length > 0) {
              List<int> cKeys = collList.keys.toList();
              children = <Widget>[
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  itemCount: collList.length,
                  itemBuilder: (BuildContext context, int index) {
                    int date = cKeys[index];

                    List<CollectionDetails> collections = collList[date];
                    int tAmount = 0;
                    bool isLatPay = false;
                    for (var item in collections) {
                      tAmount += item.amount;
                      if (item.isPaidLate) isLatPay = true;
                    }

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
                            color: CustomColors.mfinBlue,
                            elevation: 10.0,
                            borderRadius: BorderRadius.circular(10.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.36,
                              height: 80,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Spacer(
                                    flex: 1,
                                  ),
                                  Text(
                                    DateUtils.getFormattedDateFromEpoch(date),
                                    style: TextStyle(
                                        color: CustomColors.mfinWhite,
                                        fontFamily: 'Georgia',
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(
                                    flex: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Material(
                            color: CustomColors.mfinLightGrey,
                            elevation: 10.0,
                            borderRadius: BorderRadius.circular(10.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.60,
                              height: 80,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: 35,
                                    child: ListTile(
                                      leading: Text(
                                        AppLocalizations.of(context)
                                            .translate('amount_colon'),
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: CustomColors.mfinBlue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      trailing: Text(
                                        tAmount.toString(),
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: CustomColors.mfinBlue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 35,
                                    child: ListTile(
                                      leading: Text(
                                        AppLocalizations.of(context)
                                            .translate('paid_late_ques'),
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: CustomColors.mfinBlue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      trailing: Text(
                                        isLatPay ? "YES" : "NO",
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: CustomColors.mfinBlue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ];
            } else {
              children = [
                Container(
                  height: 90,
                  child: Column(
                    children: <Widget>[
                      new Spacer(),
                      Text(
                        AppLocalizations.of(context)
                            .translate('no_collection_rec'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: CustomColors.mfinAlertRed,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      new Spacer(),
                    ],
                  ),
                ),
              ];
            }
          } else {
            // No Collections available for this filterred view
            children = [
              Container(
                height: 90,
                child: Column(
                  children: <Widget>[
                    new Spacer(),
                    Text(
                      "No collection received",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: CustomColors.mfinAlertRed,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ];
          }
        } else if (snapshot.hasError) {
          children = AsyncWidgets.asyncError();
        } else {
          children = AsyncWidgets.asyncWaiting();
        }

        return Card(
          color: CustomColors.mfinLightGrey,
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Text(
                  "RECEIVED",
                  style: TextStyle(
                    fontSize: 18,
                    color: CustomColors.mfinBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: IconButton(
                  tooltip: "Genearte Transaction Report",
                  icon: Icon(
                    Icons.print,
                    size: 30,
                    color: CustomColors.mfinPositiveGreen,
                  ),
                  onPressed: () async {
                    _scaffoldKey.currentState.showSnackBar(
                      CustomSnackBar.successSnackBar(
                          "Generating Payment's Transaction Report! Please wait...",
                          5),
                    );
                    await PayTransactionReceipt().generateInvoice(
                        UserController().getCurrentUser(), _payment, collList);
                  },
                ),
              ),
              Divider(
                color: CustomColors.mfinBlue,
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: children,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
