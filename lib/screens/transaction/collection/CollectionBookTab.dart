import 'package:flutter/material.dart';
import 'package:instamfin/db/models/collection.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/customer/ViewCollection.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class CollectionBookTab extends StatelessWidget {
  CollectionBookTab(this.epoch, this.cardColor, this.textColor);

  final int epoch;
  final Color cardColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final User _u = UserController().getCurrentUser();

    return FutureBuilder(
      future: Collection().getAllCollectionByDate(
          _u.primaryFinance, _u.primaryBranch, _u.primarySubBranch, 0, epoch),
      builder:
          (BuildContext context, AsyncSnapshot<List<Collection>> collSnap) {
        Widget child;

        if (collSnap.hasData) {
          if (collSnap.data.length > 0) {
            child = ListView.builder(
              itemCount: collSnap.data.length,
              shrinkWrap: true,
              primary: false,
              itemBuilder: (BuildContext context, int index) {
                Collection coll = collSnap.data[index];

                return Padding(
                  padding: EdgeInsets.only(
                    left: 2.0,
                    top: 5,
                    right: 2.0,
                    bottom: 5,
                  ),
                  child: InkWell(
                    onTap: () async {
                      List<Map<String, dynamic>> payList = await Payment()
                          .getByCustomerAndID(
                              coll.financeID,
                              coll.branchName,
                              coll.subBranchName,
                              coll.customerNumber,
                              coll.paymentID);
                      Payment pay = Payment.fromJson(payList[0]);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewCollection(
                              pay, coll, CustomColors.mfinAlertRed),
                          settings: RouteSettings(
                              name: '/customers/payments/collection'),
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
                            height: 80,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height: 30,
                                  child: Text(
                                    coll.paymentID ?? " - ",
                                    style: TextStyle(
                                        color: textColor,
                                        fontFamily: 'Georgia',
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                new Divider(
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
                            height: 80,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height: 30,
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
                                  height: 30,
                                  child: ListTile(
                                    leading: Text(
                                      "Number",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Georgia',
                                        color: CustomColors.mfinBlue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    trailing: Text(
                                      coll.customerNumber.toString(),
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontFamily: 'Georgia',
                                        color: CustomColors.mfinBlack,
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
}
