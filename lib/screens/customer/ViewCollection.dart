import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/db/models/collection.dart';
import 'package:instamfin/screens/customer/widgets/PaymentsCollectionWidget.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/date_utils.dart';

class ViewCollection extends StatelessWidget {
  ViewCollection(
      this._collection, this.custName, this.payCreatedAt, this.iconColor);

  final Collection _collection;
  final String custName;
  final DateTime payCreatedAt;
  final Color iconColor;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Collection().streamCollectionByID(
          _collection.financeID,
          _collection.branchName,
          _collection.subBranchName,
          _collection.customerNumber,
          payCreatedAt,
          _collection.collectionDate),
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
                  getType(collection.type),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: CustomColors.mfinBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Text(
                  collection.getTotalPaid().toString(),
                  style: TextStyle(
                    fontSize: 18,
                    color: CustomColors.mfinPositiveGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              new Divider(
                color: CustomColors.mfinButtonGreen,
              ),
              Card(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: SizedBox(
                        width: 100,
                        child: Text(
                          "CUSTOMER",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: "Georgia",
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinGrey,
                          ),
                        ),
                      ),
                      title: TextFormField(
                        initialValue: custName,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            color: CustomColors.mfinBlue,
                          ),
                          fillColor: CustomColors.mfinLightGrey,
                          filled: true,
                        ),
                        enabled: false,
                        autofocus: false,
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
                        enabled: false,
                        autofocus: false,
                      ),
                    ),
                    ListTile(
                      leading: SizedBox(
                        width: 100,
                        child: Text(
                          "AMOUNT",
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Georgia",
                              fontWeight: FontWeight.bold,
                              color: CustomColors.mfinGrey),
                        ),
                      ),
                      title: TextFormField(
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
                        enabled: false,
                        autofocus: false,
                      ),
                    ),
                    ListTile(
                      leading: SizedBox(
                        width: 100,
                        child: Text(
                          "RECEIVED",
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Georgia",
                              fontWeight: FontWeight.bold,
                              color: CustomColors.mfinGrey),
                        ),
                      ),
                      title: TextFormField(
                        textAlign: TextAlign.end,
                        initialValue: collection.getTotalPaid().toString(),
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
                        enabled: false,
                        autofocus: false,
                      ),
                    ),
                    ListTile(
                      leading: SizedBox(
                        width: 100,
                        child: Text(
                          "DATE",
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Georgia",
                              fontWeight: FontWeight.bold,
                              color: CustomColors.mfinGrey),
                        ),
                      ),
                      title: TextFormField(
                        textAlign: TextAlign.end,
                        initialValue:
                            DateUtils.formatDate(collection.collectionDate),
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
                        enabled: false,
                        autofocus: false,
                      ),
                    ),
                    ListTile(
                      leading: SizedBox(
                        width: 100,
                        child: Text(
                          "NOTIFY AT",
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Georgia",
                              fontWeight: FontWeight.bold,
                              color: CustomColors.mfinGrey),
                        ),
                      ),
                      title: TextFormField(
                        textAlign: TextAlign.end,
                        initialValue: DateUtils.formatDate(collection.notifyAt),
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
                        enabled: false,
                        autofocus: false,
                      ),
                    ),
                    PaymentsCollectionWidget(
                        _scaffoldKey, collection, custName, payCreatedAt),
                  ],
                ),
              ),
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
                      "Unable to find the collection Details",
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
            title: Text('Collection - ${_collection.customerNumber}'),
            backgroundColor: CustomColors.mfinBlue,
          ),
          key: _scaffoldKey,
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => AddPayment(customer),
              //     settings: RouteSettings(name: '/customers/payments/add'),
              //   ),
              // );
            },
            label: Text(
              "Edit",
              style: TextStyle(
                fontSize: 17,
                fontFamily: "Georgia",
                fontWeight: FontWeight.bold,
              ),
            ),
            splashColor: CustomColors.mfinWhite,
            icon: Icon(
              Icons.edit,
              size: 35,
              color: CustomColors.mfinFadedButtonGreen,
            ),
          ),
          body: SingleChildScrollView(
            child: new Container(
              child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: children),
            ),
          ),
        );
      },
    );
  }

  String getType(int type) {
    switch (type) {
      case 0:
        return "COLLECTION";
        break;
      case 1:
        return "DOC CHARGE";
        break;
      case 2:
        return "SURCHARGE";
        break;
      case 3:
        return "CLOSING";
        break;
      default:
        return "COLLECTION";
        break;
    }
  }
}
