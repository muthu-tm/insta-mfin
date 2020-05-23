import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:instamfin/db/models/collection.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/date_utils.dart';

class PaymentCollectionWidget extends StatelessWidget {
  PaymentCollectionWidget(this._payment, this.title, this.emptyText,
      this.textColor, this.fetchAll, this.status);

  final Payment _payment;
  final String title;
  final String emptyText;
  final Color textColor;
  final bool fetchAll;
  final List<int> status;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Collection().streamCollectionsByStatus(
            _payment.financeID,
            _payment.branchName,
            _payment.subBranchName,
            _payment.customerNumber,
            _payment.createdAt,
            status,
            fetchAll),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          List<Widget> children;

          if (snapshot.hasData) {
            if (snapshot.data.documents.isNotEmpty) {
              children = <Widget>[
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    Collection collection = Collection.fromJson(
                        snapshot.data.documents[index].data);
                    List<String> textValue = setCardValue(collection);

                    return Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,
                      closeOnScroll: true,
                      direction: Axis.horizontal,
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: 'Edit',
                          color: CustomColors.mfinGrey,
                          icon: Icons.edit,
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => EditPayment(
                            //         Payment.fromJson(
                            //             snapshot.data.documents[index].data)),
                            //     settings: RouteSettings(
                            //         name: '/customers/payment/edit'),
                            //   ),
                            // );
                          },
                        ),
                      ],
                      child: Builder(
                        builder: (BuildContext context) {
                          return Padding(
                            padding: EdgeInsets.only(
                              left: 2.0,
                              top: 2.5,
                              right: 2.0,
                              bottom: 2.5,
                            ),
                            child: InkWell(
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => ViewPayment(
                                //         Payment.fromJson(snapshot
                                //             .data.documents[index].data)),
                                //     settings: RouteSettings(
                                //         name: '/customers/payment'),
                                //   ),
                                // );
                              },
                              child: Row(
                                children: <Widget>[
                                  Material(
                                    color: getCardColor(collection.status),
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
                                              DateUtils.formatDate(
                                                  collection.collectionDate),
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
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          ListTile(
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
              // No Collections available for this filterred view
              children = [
                Container(
                  height: 90,
                  child: Column(
                    children: <Widget>[
                      new Spacer(),
                      Text(
                        emptyText,
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
                  leading: RichText(
                    text: TextSpan(
                      text: "Total: ",
                      style: TextStyle(
                        fontFamily: "Georgia",
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mfinGrey,
                        fontSize: 18.0,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: snapshot.hasData
                                ? snapshot.data.documents.length.toString()
                                : "00",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: CustomColors.mfinGrey,
                              fontSize: 18.0,
                            )),
                      ],
                    ),
                  ),
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
    switch (coll.status) {
      case 0:
        return ["AMOUNT", coll.collectionAmount.toString()];
        break;
      case 1:
      case 2:
        return ["RECEIVED", coll.totalPaid.toString()];
        break;
      case 3:
        return ["AMOUNT", coll.collectionAmount.toString()];
        break;
      case 4:
        int pending = coll.collectionAmount - coll.totalPaid;
        return ["PENDING", pending.toString()];
        break;
      default:
        return ["AMOUNT", coll.collectionAmount.toString()];
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
      default:
        return CustomColors.mfinBlue;
        break;
    }
  }
}
