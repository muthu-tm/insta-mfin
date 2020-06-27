import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:instamfin/db/models/collection.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/customer/ViewCollection.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/transaction/collection_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class CollectionListWidget extends StatelessWidget {
  CollectionListWidget(this._scaffoldKey, this._payment, this.title,
      this.emptyText, this.textColor, this.fetchAll, this.status);

  final GlobalKey<ScaffoldState> _scaffoldKey;

  final Payment _payment;
  final String title;
  final String emptyText;
  final Color textColor;
  final bool fetchAll;
  final int status;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: fetchAll
          ? Collection().streamCollectionsForPayment(_payment.financeID,
              _payment.branchName, _payment.subBranchName, _payment.paymentID)
          : status == 0
              ? Collection().streamUpcomingForPayment(
                  _payment.financeID,
                  _payment.branchName,
                  _payment.subBranchName,
                  _payment.paymentID)
              : status == 3
                  ? Collection().streamTodaysForPayment(
                      _payment.financeID,
                      _payment.branchName,
                      _payment.subBranchName,
                      _payment.paymentID)
                  : Collection().streamPastForPayment(
                      _payment.financeID,
                      _payment.branchName,
                      _payment.subBranchName,
                      _payment.paymentID),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          if (snapshot.data.documents.length > 0) {
            List<Collection> collList = [];
            if (fetchAll) {
              snapshot.data.documents.forEach((doc) {
                Collection _c = Collection.fromJson(doc.data);
                collList.add(_c);
              });
            } else if (status == 1) {
              snapshot.data.documents.forEach((doc) {
                Collection _c = Collection.fromJson(doc.data);
                if (_c.getReceived() == _c.collectionAmount) collList.add(_c);
              });
            } else if (status == 4) {
              snapshot.data.documents.forEach((doc) {
                Collection _c = Collection.fromJson(doc.data);
                if (_c.getReceived() < _c.collectionAmount) collList.add(_c);
              });
            } else {
              snapshot.data.documents.forEach((doc) {
                Collection _c = Collection.fromJson(doc.data);
                collList.add(_c);
              });
            }

            if (collList.length > 0) {
              children = <Widget>[
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  itemCount: collList.length,
                  itemBuilder: (BuildContext context, int index) {
                    Collection collection = collList[index];
                    List<String> textValue = setCardValue(collection);
                    Color cardColor = getCardColor(collection.getStatus());

                    return Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.40,
                      closeOnScroll: true,
                      direction: Axis.horizontal,
                      actions: <Widget>[
                        IconSlideAction(
                          caption: 'Mark As Collected',
                          color: CustomColors.mfinPositiveGreen,
                          icon: Icons.check_box,
                          onTap: () {
                            markAsCollected(collection, context);
                          },
                        ),
                      ],
                      child: Builder(
                        builder: (BuildContext context) {
                          return Padding(
                            padding: EdgeInsets.only(
                              left: 2.0,
                              top: 5,
                              right: 2.0,
                              bottom: 5,
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ViewCollection(
                                        _payment, collection, cardColor),
                                    settings: RouteSettings(
                                        name: '/customers/payment/colection'),
                                  ),
                                );
                              },
                              child: Row(
                                children: <Widget>[
                                  Material(
                                    color: cardColor,
                                    elevation: 10.0,
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.36,
                                      height: 80,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Spacer(
                                            flex: 3,
                                          ),
                                          SizedBox(
                                            height: 20,
                                            child: Text(
                                              collection.collectionNumber
                                                  .toString(),
                                              style: TextStyle(
                                                  color: CustomColors.mfinWhite,
                                                  fontFamily: 'Georgia',
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Spacer(
                                            flex: 1,
                                          ),
                                          new Divider(
                                            color: CustomColors.mfinWhite,
                                          ),
                                          Spacer(
                                            flex: 1,
                                          ),
                                          SizedBox(
                                            height: 30,
                                            child: Text(
                                              DateUtils
                                                  .getFormattedDateFromEpoch(
                                                      collection
                                                          .collectionDate),
                                              style: TextStyle(
                                                  color: CustomColors.mfinWhite,
                                                  fontFamily: 'Georgia',
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
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
                                      width: MediaQuery.of(context).size.width *
                                          0.60,
                                      height: 80,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 35,
                                            child: ListTile(
                                              leading: Text(
                                                textValue[0],
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: CustomColors.mfinBlue,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              trailing: Text(
                                                textValue[1],
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  color: textColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 35,
                                            child: ListTile(
                                              leading: Text(
                                                "TYPE:",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: CustomColors.mfinBlue,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              trailing: Text(
                                                collection.getType(),
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
                            ),
                          );
                        },
                      ),
                    );
                  },
                )
              ];
            } else {
              children = [
                Container(
                  height: 90,
                  child: Column(
                    children: <Widget>[
                      new Spacer(),
                      Text(
                        emptyText,
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
                      emptyText,
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
        } else if (snapshot.hasError) {
          children = AsyncWidgets.asyncError();
        } else {
          children = AsyncWidgets.asyncWaiting();
        }

        return Card(
          color: CustomColors.mfinLightGrey,
          child: new Column(
            children: <Widget>[
              ListTile(
                trailing: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              new Divider(
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

  List<String> setCardValue(Collection coll) {
    switch (coll.getStatus()) {
      case 0:
        return ["AMOUNT:", coll.collectionAmount.toString()];
        break;
      case 1:
      case 2:
        return ["RECEIVED:", coll.getReceived().toString()];
        break;
      case 3:
        return ["AMOUNT:", coll.collectionAmount.toString()];
        break;
      case 4:
        int pending = coll.collectionAmount - coll.getReceived();
        return ["PENDING:", pending.toString()];
        break;
      case 4:
        int pending = coll.collectionAmount - coll.getReceived();
        return ["PENDING:", pending.toString()];
        break;
      case 5:
        return ["AMOUNT:", coll.collectionAmount.toString()];
        break;
      default:
        return ["AMOUNT:", coll.collectionAmount.toString()];
        break;
    }
  }

  Color getCardColor(int status) {
    switch (status) {
      case 0:
        return CustomColors.mfinGrey;
        break;
      case 1:
      case 2:
        return CustomColors.mfinPositiveGreen;
        break;
      case 3:
        return CustomColors.mfinBlue;
        break;
      case 4:
        return CustomColors.mfinAlertRed;
        break;
      case 5:
        return CustomColors.mfinAlertRed.withOpacity(0.5);
        break;
      default:
        return CustomColors.mfinBlue;
        break;
    }
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
      User _user = UserController().getCurrentUser();
      Map<String, dynamic> collDetails = {
        'collected_on': DateUtils.getUTCDateEpoch(DateTime.now())
      };
      collDetails['amount'] =
          collection.collectionAmount - collection.getReceived();
      collDetails['transferred_mode'] = 0;
      collDetails['notes'] = "";
      collDetails['collected_by'] = _user.name;
      collDetails['collected_from'] = _payment.custName;
      collDetails['penalty_amount'] = 0;
      collDetails['created_at'] = DateTime.now();
      collDetails['added_by'] = _user.mobileNumber;
      if (collection.collectionDate <
          (DateUtils.getCurrentUTCDate().millisecondsSinceEpoch))
        collDetails['is_paid_late'] = true;
      else
        collDetails['is_paid_late'] = false;

      var result = await _cc.updateCollectionDetails(
          collection.financeID,
          collection.branchName,
          collection.subBranchName,
          collection.paymentID,
          collection.collectionDate,
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
        _scaffoldKey.currentState.setState(() {});
      }
    }
  }
}
