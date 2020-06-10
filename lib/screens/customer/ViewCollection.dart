import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/db/models/collection.dart';
import 'package:instamfin/screens/customer/widgets/CollDetailsTableWidget.dart';
import 'package:instamfin/screens/customer/widgets/CollectionDetailsWidget.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/transaction/collection_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class ViewCollection extends StatelessWidget {
  ViewCollection(this.paySettled, this._collection, this.custName,
      this.payCreatedAt, this.iconColor);

  final bool paySettled;
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
                  collection.getReceived().toString(),
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
                      title: GestureDetector(
                        onTap: () => _selectDate(context),
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: _date,
                            keyboardType: TextInputType.datetime,
                            decoration: InputDecoration(
                              hintText: 'Date of Payment',
                              labelStyle: TextStyle(
                                color: CustomColors.mfinBlue,
                              ),
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 3.0, horizontal: 3.0),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: CustomColors.mfinWhite)),
                              fillColor: CustomColors.mfinWhite,
                              filled: true,
                              suffixIcon: Icon(
                                Icons.date_range,
                                size: 35,
                                color: CustomColors.mfinBlue,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    (UserController().getCurrentUser().preferences.tableView)
                        ? CollDetailsTableWidget(paySettled, _scaffoldKey,
                            collection, custName, payCreatedAt)
                        : CollectionDetailsWidget(paySettled, _scaffoldKey,
                            collection, custName, payCreatedAt),
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
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: !paySettled
              ? FloatingActionButton.extended(
                  onPressed: () {
                    _submit(context);
                  },
                  label: Text(
                    "Update",
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
                )
              : FloatingActionButton.extended(
                  backgroundColor: CustomColors.mfinAlertRed,
                  onPressed: () {},
                  label: Text(
                    "Closed Payment",
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: "Georgia",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  icon: Icon(
                    Icons.close,
                    size: 35,
                    color: CustomColors.mfinWhite,
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

  TextEditingController _date = new TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.fromMillisecondsSinceEpoch(_collection.notifyAt),
      firstDate: DateTime(1990),
      lastDate: DateTime.now().add(Duration(days: 10)),
    );
    if (picked != null &&
        picked != DateTime.fromMillisecondsSinceEpoch(_collection.notifyAt))
      _collection.notifyAt = picked.millisecondsSinceEpoch;
    _date.value = TextEditingValue(
      text: DateUtils.formatDate(picked),
    );
  }

  Future<void> _submit(BuildContext context) async {
    CustomDialogs.actionWaiting(context, "Updating Profile");
    CollectionController _cc = CollectionController();
    var result = await _cc.updateCollection(
        _collection.financeID,
        _collection.branchName,
        _collection.subBranchName,
        _collection.customerNumber,
        payCreatedAt,
        _collection.getDocumentID(_collection.collectionDate),
        {'notify_at': _collection.notifyAt});

    if (!result['is_success']) {
      Navigator.pop(context);
      _scaffoldKey.currentState
          .showSnackBar(CustomSnackBar.errorSnackBar(result['message'], 2));
    } else {
      Navigator.pop(context);
      Navigator.pop(context);
    }
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
