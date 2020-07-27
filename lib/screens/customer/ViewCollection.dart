import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/db/models/collection.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/screens/customer/widgets/CollDetailsTableWidget.dart';
import 'package:instamfin/screens/customer/widgets/CollectionDetailsWidget.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:instamfin/services/pdf/collection_receipt.dart';

import '../../app_localizations.dart';

class ViewCollection extends StatelessWidget {
  ViewCollection(this.pay, this._collection, this.iconColor);

  final Payment pay;
  final Collection _collection;
  final Color iconColor;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Collection().streamCollectionByID(
          _collection.financeID,
          _collection.branchName,
          _collection.subBranchName,
          _collection.paymentID,
          (_collection.type != 1 &&
                  _collection.type != 2 &&
                  _collection.type != 4 &&
                  _collection.type != 5)
              ? _collection.collectionDate
              : (_collection.collectionDate + _collection.type)),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          if (snapshot.data.exists) {
            Collection collection = Collection.fromJson(snapshot.data.data);

            children = <Widget>[
              ListTile(
                leading: Icon(
                  Icons.drafts,
                  size: 35.0,
                  color: iconColor,
                ),
                title: Text(
                  collection.getType(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: CustomColors.mfinBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.print,
                    size: 35.0,
                    color: CustomColors.mfinBlack,
                  ),
                  onPressed: () async {
                    await CollectionReceipt().generateInvoice(
                        UserController().getCurrentUser(), pay, collection);
                  },
                ),
              ),
              new Divider(
                color: CustomColors.mfinButtonGreen,
              ),
              ListTile(
                leading: SizedBox(
                  width: 100,
                  child: Text(
                    AppLocalizations.of(context).translate('customer_caps'),
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Georgia",
                      fontWeight: FontWeight.bold,
                      color: CustomColors.mfinGrey,
                    ),
                  ),
                ),
                title: TextFormField(
                  readOnly: true,
                  initialValue: pay.custName,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                      color: CustomColors.mfinBlue,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: CustomColors.mfinGrey,
                      ),
                    ),
                    fillColor: CustomColors.mfinLightGrey,
                    filled: true,
                  ),
                ),
              ),
              ListTile(
                leading: SizedBox(
                  width: 100,
                  child: Text(
                    "COLL NO",
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Georgia",
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mfinGrey),
                  ),
                ),
                title: TextFormField(
                  readOnly: true,
                  textAlign: TextAlign.end,
                  initialValue: collection.collectionNumber.toString(),
                  decoration: InputDecoration(
                    fillColor: CustomColors.mfinWhite,
                    filled: true,
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 3.0, horizontal: 3.0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: CustomColors.mfinGrey,
                      ),
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: SizedBox(
                  width: 100,
                  child: Text(
                    AppLocalizations.of(context).translate('amount_caps'),
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Georgia",
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mfinGrey),
                  ),
                ),
                title: TextFormField(
                  readOnly: true,
                  textAlign: TextAlign.end,
                  initialValue: collection.collectionAmount.toString(),
                  decoration: InputDecoration(
                    fillColor: CustomColors.mfinWhite,
                    filled: true,
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 3.0, horizontal: 3.0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: CustomColors.mfinGrey,
                      ),
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: SizedBox(
                  width: 100,
                  child: Text(
                    AppLocalizations.of(context).translate('received_caps'),
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Georgia",
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mfinGrey),
                  ),
                ),
                title: TextFormField(
                  readOnly: true,
                  textAlign: TextAlign.end,
                  initialValue: collection.getReceived().toString(),
                  decoration: InputDecoration(
                    fillColor: CustomColors.mfinWhite,
                    filled: true,
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 3.0, horizontal: 3.0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: CustomColors.mfinGrey,
                      ),
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: SizedBox(
                  width: 100,
                  child: Text(
                    AppLocalizations.of(context).translate('date_caps'),
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Georgia",
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mfinGrey),
                  ),
                ),
                title: TextFormField(
                  readOnly: true,
                  textAlign: TextAlign.end,
                  initialValue: DateUtils.getFormattedDateFromEpoch(
                      collection.collectionDate),
                  decoration: InputDecoration(
                    fillColor: CustomColors.mfinWhite,
                    filled: true,
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 3.0, horizontal: 3.0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: CustomColors.mfinGrey,
                      ),
                    ),
                  ),
                ),
              ),
              (UserController().getCurrentUser().preferences.tableView)
                  ? CollDetailsTableWidget(
                      pay.isSettled, _scaffoldKey, collection, pay.custName)
                  : CollectionDetailsWidget(
                      pay.isSettled, _scaffoldKey, collection, pay.custName),
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
                      AppLocalizations.of(context)
                          .translate('unable_find_collection'),
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

        return new Scaffold(
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context).translate('view_collection'),
            ),
            backgroundColor: CustomColors.mfinBlue,
          ),
          key: _scaffoldKey,
          body: SingleChildScrollView(
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: children),
          ),
        );
      },
    );
  }
}
