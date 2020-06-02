import 'package:flutter/material.dart';
import 'package:instamfin/db/models/collection.dart';
import 'package:instamfin/db/models/collection_details.dart';
import 'package:instamfin/screens/customer/AddCollectionDetails.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';

class CollDetailsTableWidget extends StatelessWidget {
  CollDetailsTableWidget(
      this._scaffoldKey, this._collection, this.custName, this._createdAt);

  final GlobalKey<ScaffoldState> _scaffoldKey;
  final Collection _collection;
  final String custName;
  final DateTime _createdAt;

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
              "No Collection received yet!",
              style: TextStyle(
                color: CustomColors.mfinAlertRed,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0, top: 20.0),
              child: Text(
                "Add collection using '+' button",
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
              "Date",
              textAlign: TextAlign.center,
            ),
            numeric: false,
            tooltip: "Collected Date",
          ),
          DataColumn(
            label: Text(
              "Amount",
              textAlign: TextAlign.center,
            ),
            numeric: false,
            tooltip: "Collected Amount",
          ),
          DataColumn(
            label: Text(
              "Pending",
              textAlign: TextAlign.center,
            ),
            numeric: false,
            tooltip: "Pending Amount",
          ),
          DataColumn(
            label: Text(
              "Late",
              textAlign: TextAlign.center,
            ),
            numeric: false,
            tooltip: "Is Late Collection?",
          ),
          DataColumn(
            label: Text(
              "From",
              textAlign: TextAlign.center,
            ),
            numeric: false,
            tooltip: "Collected From",
          ),
          DataColumn(
            label: Text(
              "Notes",
              textAlign: TextAlign.center,
            ),
            numeric: false,
            tooltip: "Short Notes",
          ),
        ], rows: getRows()),
      );
    }

    return Card(
      color: CustomColors.mfinLightGrey,
      child: new Column(
        children: <Widget>[
          ListTile(
            leading: Icon(
              Icons.person,
              size: 35.0,
              color: CustomColors.mfinButtonGreen,
            ),
            title: new Text(
              "Collection Details",
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
                if (_collection.getReceived() < _collection.collectionAmount) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddCollectionDetails(
                          _collection, custName, _createdAt),
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

  List<DataRow> getRows() {
    List<DataRow> rows = [];
    int received = 0;
    for (int i = 0; i < _collection.collections.length; i++) {
      CollectionDetails coll = _collection.collections[i];
      received += coll.amount;
      rows.add(
        DataRow(
          cells: <DataCell>[
            DataCell(
              Text(
                DateUtils.formatDate(coll.collectedOn),
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
                coll.isPaidLate ? "YES" : "NO",
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
