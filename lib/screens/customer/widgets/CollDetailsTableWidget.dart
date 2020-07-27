import 'package:flutter/material.dart';
import 'package:instamfin/db/models/collection.dart';
import 'package:instamfin/db/models/collection_details.dart';
import 'package:instamfin/screens/customer/AddCollectionDetails.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/transaction/collection_controller.dart';

import '../../../app_localizations.dart';

class CollDetailsTableWidget extends StatelessWidget {
  CollDetailsTableWidget(
      this.paySettled, this._scaffoldKey, this._collection, this.custName);

  final bool paySettled;
  final GlobalKey<ScaffoldState> _scaffoldKey;
  final Collection _collection;
  final String custName;

  @override
  Widget build(BuildContext context) {
    Widget widget;
    if (_collection.collections == null ||
        _collection.collections.length == 0) {
      widget = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              AppLocalizations.of(context).translate('no_collection_received'),
              style: TextStyle(
                color: CustomColors.mfinAlertRed,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10.0, top: 20.0),
              child: Text(
                AppLocalizations.of(context).translate('add_collection_sign'),
                style: TextStyle(
                  color: CustomColors.mfinBlue,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      );
    } else {
      widget = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(columns: <DataColumn>[
          DataColumn(
            label: Text(
              AppLocalizations.of(context).translate('chit_day_colon'),
              textAlign: TextAlign.center,
            ),
            numeric: false,
            tooltip:
                AppLocalizations.of(context).translate('remove_collection'),
          ),
          DataColumn(
            label: Text(
              AppLocalizations.of(context).translate('date_colon'),
              textAlign: TextAlign.center,
            ),
            numeric: false,
            tooltip: "Collected Date",
          ),
          DataColumn(
            label: Text(
              AppLocalizations.of(context).translate('amount'),
              textAlign: TextAlign.center,
            ),
            numeric: false,
            tooltip: "Collected Amount",
          ),
          DataColumn(
            label: Text(
              AppLocalizations.of(context).translate('pending'),
              textAlign: TextAlign.center,
            ),
            numeric: false,
            tooltip: "Pending Amount",
          ),
          DataColumn(
            label: Text(
              AppLocalizations.of(context).translate('late'),
              textAlign: TextAlign.center,
            ),
            numeric: false,
            tooltip: "Is Late Collection?",
          ),
          DataColumn(
            label: Text(
              AppLocalizations.of(context).translate('from'),
              textAlign: TextAlign.center,
            ),
            numeric: false,
            tooltip: "Collected From",
          ),
          DataColumn(
            label: Text(
              AppLocalizations.of(context).translate('notes'),
              textAlign: TextAlign.center,
            ),
            numeric: false,
            tooltip: "Short Notes",
          ),
        ], rows: getRows(context)),
      );
    }

    return Card(
      color: CustomColors.mfinLightGrey,
      child: new Column(
        children: <Widget>[
          ListTile(
            leading: Icon(
              Icons.collections_bookmark,
              size: 35.0,
              color: CustomColors.mfinButtonGreen,
            ),
            title: new Text(
              AppLocalizations.of(context).translate('collection_details'),
              style: TextStyle(
                color: CustomColors.mfinBlue,
                fontSize: 18.0,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.add_box,
                size: 35.0,
                color: CustomColors.mfinBlue,
              ),
              onPressed: () {
                if (paySettled) {
                  _scaffoldKey.currentState.showSnackBar(
                      CustomSnackBar.errorSnackBar(
                          AppLocalizations.of(context)
                              .translate('unable_edit_payment'),
                          2));
                } else {
                  if (_collection.getReceived() <
                      _collection.collectionAmount) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AddCollectionDetails(_collection, custName),
                        settings: RouteSettings(
                            name:
                                '/customers/payments/collections/collectiondetails/add'),
                      ),
                    );
                  } else {
                    _scaffoldKey.currentState.showSnackBar(
                        CustomSnackBar.errorSnackBar(
                            "Collection AMOUNT already collected Fully", 3));
                  }
                }
              },
            ),
          ),
          new Divider(
            color: CustomColors.mfinBlue,
            thickness: 1,
          ),
          widget,
        ],
      ),
    );
  }

  List<DataRow> getRows(BuildContext context) {
    List<DataRow> rows = [];
    int received = 0;
    for (int i = 0; i < _collection.collections.length; i++) {
      CollectionDetails coll = _collection.collections[i];
      received += coll.amount;
      rows.add(
        DataRow(
          cells: <DataCell>[
            DataCell(IconButton(
              color: CustomColors.mfinAlertRed,
              icon: Icon(Icons.check_box_outline_blank),
              onPressed: () async {
                if (paySettled) {
                  _scaffoldKey.currentState.showSnackBar(
                      CustomSnackBar.errorSnackBar(
                          AppLocalizations.of(context)
                              .translate('unable_edit_payment'),
                          2));
                } else {
                  await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: new Text(
                          AppLocalizations.of(context).translate('confirm'),
                          style: TextStyle(
                              color: CustomColors.mfinAlertRed,
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                        ),
                        content: Text(
                          "${AppLocalizations.of(context).translate('sure_remove')} ${coll.amount} ${AppLocalizations.of(context).translate('collection')}",
                        ),
                        actions: <Widget>[
                          FlatButton(
                            color: CustomColors.mfinButtonGreen,
                            child: Text(
                              AppLocalizations.of(context).translate('no'),
                              style: TextStyle(
                                  color: CustomColors.mfinBlue,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.start,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          FlatButton(
                            color: CustomColors.mfinAlertRed,
                            child: Text(
                              AppLocalizations.of(context).translate('yes'),
                              style: TextStyle(
                                  color: CustomColors.mfinLightGrey,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.start,
                            ),
                            onPressed: () async {
                              CollectionController _cc = CollectionController();
                              int id = _collection.collectionDate;
                              if (_collection.type == 3) id = _collection.collectionDate + 3;

                              var result = await _cc.updateCollectionDetails(
                                  _collection.financeID,
                                  _collection.branchName,
                                  _collection.subBranchName,
                                  _collection.paymentID,
                                  id,
                                  false,
                                  false,
                                  coll.toJson(),
                                  (coll.penaltyAmount > 0));
                              if (!result['is_success']) {
                                Navigator.pop(context);
                                _scaffoldKey.currentState.showSnackBar(
                                    CustomSnackBar.errorSnackBar(
                                        result['message'], 2));
                              } else {
                                _scaffoldKey.currentState.showSnackBar(
                                    CustomSnackBar.errorSnackBar(
                                        "Collection ${coll.amount} removed successfully",
                                        2));
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            )),
            DataCell(
              Text(
                DateUtils.getFormattedDateFromEpoch(coll.collectedOn),
                textAlign: TextAlign.center,
              ),
            ),
            DataCell(
              Text(
                coll.amount.toString(),
                textAlign: TextAlign.center,
              ),
            ),
            DataCell(
              Text(
                (_collection.collectionAmount - received).toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: (_collection.collectionAmount - received) > 0
                      ? CustomColors.mfinAlertRed
                      : CustomColors.mfinPositiveGreen,
                ),
              ),
            ),
            DataCell(
              Text(
                coll.isPaidLate
                    ? AppLocalizations.of(context).translate('yes')
                    : AppLocalizations.of(context).translate('no'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: coll.isPaidLate
                      ? CustomColors.mfinAlertRed
                      : CustomColors.mfinPositiveGreen,
                ),
              ),
            ),
            DataCell(
              Text(
                coll.collectedFrom,
                textAlign: TextAlign.center,
              ),
            ),
            DataCell(
              Text(
                coll.notes,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    return rows;
  }
}
