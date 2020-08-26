import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:instamfin/db/models/collection.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/screens/customer/ViewCollection.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/transaction/collection_controller.dart';
import 'package:instamfin/app_localizations.dart';
import 'package:instamfin/services/controllers/user/user_service.dart';

class CollectionBookTab extends StatelessWidget {
  CollectionBookTab(this._scaffoldKey, this.isPending, this.epoch,
      this.cardColor, this.textColor);

  final GlobalKey<ScaffoldState> _scaffoldKey;
  final bool isPending;
  final int epoch;
  final Color cardColor, textColor;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: isPending
          ? Collection().streamAllPendingCollectionByDate(
              cachedLocalUser.primary.financeID,
              cachedLocalUser.primary.branchName,
              cachedLocalUser.primary.subBranchName,
              epoch)
          : Collection().streamAllCollectionByDate(
              cachedLocalUser.primary.financeID,
              cachedLocalUser.primary.branchName,
              cachedLocalUser.primary.subBranchName,
              [0],
              false,
              epoch),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> collSnap) {
        Widget child;

        if (collSnap.hasData) {
          if (collSnap.data.documents.length > 0) {
            child = ListView.builder(
              itemCount: collSnap.data.documents.length,
              shrinkWrap: true,
              primary: false,
              itemBuilder: (BuildContext context, int index) {
                Collection coll =
                    Collection.fromJson(collSnap.data.documents[index].data);

                return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.40,
                  closeOnScroll: true,
                  direction: Axis.horizontal,
                  actions: <Widget>[
                    IconSlideAction(
                      caption: AppLocalizations.of(context)
                          .translate("mark_resolved"),
                      color: CustomColors.mfinPositiveGreen,
                      icon: Icons.check_box,
                      onTap: () {
                        markAsCollected(coll, context);
                      },
                    ),
                  ],
                  child: Builder(builder: (BuildContext context) {
                    return getCollectionTile(context, coll);
                  }),
                );
              },
            );
          } else {
            child = Container(
              height: 90,
              child: Column(
                children: <Widget>[
                  new Spacer(
                    flex: 2,
                  ),
                  Text(
                    "No Collection Found!",
                    style: TextStyle(
                      color: CustomColors.mfinAlertRed,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  new Spacer(),
                  Text(
                    "Check for different Date!",
                    style: TextStyle(
                      color: CustomColors.mfinBlue,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  new Spacer(
                    flex: 2,
                  ),
                ],
              ),
            );
          }
        } else if (collSnap.hasError) {
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

        return child;
      },
    );
  }

  Widget getCollectionTile(BuildContext context, Collection coll) {
    return Padding(
      padding: EdgeInsets.only(
        left: 2.0,
        top: 5,
        right: 2.0,
        bottom: 5,
      ),
      child: InkWell(
        onTap: () async {
          List<Map<String, dynamic>> payList = await Payment().getByPaymentID(
              coll.financeID,
              coll.branchName,
              coll.subBranchName,
              coll.paymentID);
          Payment pay = Payment.fromJson(payList[0]);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ViewCollection(pay, coll, CustomColors.mfinAlertRed),
              settings: RouteSettings(name: '/customers/payments/collection'),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Material(
              color: cardColor,
              elevation: 10.0,
              borderRadius: BorderRadius.circular(5.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.35,
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                      child: Text(
                        coll.payID ?? " - ",
                        style: TextStyle(
                            color: textColor,
                            fontFamily: 'Georgia',
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Divider(
                      color: CustomColors.mfinButtonGreen,
                    ),
                    SizedBox(
                      height: 30,
                      child: Text(
                        coll.collectionAmount.toString(),
                        style: TextStyle(
                            color: textColor,
                            fontFamily: 'Georgia',
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Material(
              color: CustomColors.mfinLightGrey,
              elevation: 10.0,
              borderRadius: BorderRadius.circular(5.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.60,
                height: 100,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 25,
                      child: ListTile(
                        leading: Text(
                          "Collection",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Georgia',
                            color: CustomColors.mfinBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Text(
                          coll.collectionNumber.toString(),
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: 'Georgia',
                            color: CustomColors.mfinBlack,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                      child: ListTile(
                        leading: Text(
                          "Received",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Georgia',
                            color: CustomColors.mfinBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Text(
                          coll.getReceived().toString(),
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: 'Georgia',
                            color: CustomColors.mfinPositiveGreen,
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
      ),
    );
  }

  Future markAsCollected(Collection collection, BuildContext context) async {
    if (collection.getReceived() == collection.collectionAmount) {
      CustomDialogs.information(
          context,
          "Alert!",
          CustomColors.mfinPositiveGreen,
          "Collection amount ${collection.collectionAmount} already collected fully!");
    } else {
      CustomDialogs.actionWaiting(context, "Updating Collection");
      CollectionController _cc = CollectionController();
      Map<String, dynamic> collDetails = {
        'collected_on': DateUtils.getUTCDateEpoch(DateTime.now())
      };
      collDetails['amount'] =
          collection.collectionAmount - collection.getReceived();
      collDetails['transferred_mode'] = 0;
      collDetails['notes'] = "";
      collDetails['collected_by'] = cachedLocalUser.name;
      collDetails['collected_from'] = "";
      collDetails['penalty_amount'] = 0;
      collDetails['created_at'] = DateTime.now();
      collDetails['added_by'] = cachedLocalUser.getIntID();
      if (collection.collectionDate <
          (DateUtils.getCurrentUTCDate().millisecondsSinceEpoch))
        collDetails['is_paid_late'] = true;
      else
        collDetails['is_paid_late'] = false;

      int id = collection.collectionDate;
      if (collection.type == 3) id = collection.collectionDate + 3;

      var result = await _cc.updateCollectionDetails(
          collection.financeID,
          collection.branchName,
          collection.subBranchName,
          collection.paymentID,
          id,
          true,
          true,
          collDetails,
          false);

      if (!result['is_success']) {
        Navigator.pop(context);
        _scaffoldKey.currentState
            .showSnackBar(CustomSnackBar.errorSnackBar(result['message'], 5));
      } else {
        Navigator.pop(context);
      }
    }
  }
}
