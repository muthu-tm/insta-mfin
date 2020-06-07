import 'package:flutter/material.dart';
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

class CollectionListTableWidget extends StatelessWidget {
  CollectionListTableWidget(this._payment, this.custName, this.title,
      this.emptyText, this.textColor, this.fetchAll, this.status);

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final Payment _payment;
  final String custName;
  final String title;
  final String emptyText;
  final Color textColor;
  final bool fetchAll;
  final List<int> status;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: CollectionController().streamCollectionsByStatus(
          _payment.financeID,
          _payment.branchName,
          _payment.subBranchName,
          _payment.customerNumber,
          _payment.createdAt,
          status,
          fetchAll),
      builder:
          (BuildContext context, AsyncSnapshot<List<Collection>> snapshot) {
        Widget widget;

        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            widget = SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                showCheckboxColumn: false,
                columns: <DataColumn>[
                  DataColumn(
                    label: Text(
                      "Action",
                      textAlign: TextAlign.center,
                    ),
                    numeric: false,
                    tooltip: "Mark As Collected",
                  ),
                  DataColumn(
                    label: Text(
                      "No.",
                      textAlign: TextAlign.center,
                    ),
                    numeric: false,
                    tooltip: "Collection Number",
                  ),
                  DataColumn(
                    label: Text(
                      "Date",
                      textAlign: TextAlign.center,
                    ),
                    numeric: false,
                    tooltip: "Collection Date",
                  ),
                  DataColumn(
                    label: Text(
                      "Type",
                      textAlign: TextAlign.center,
                    ),
                    numeric: false,
                    tooltip: "Collection Type",
                  ),
                  DataColumn(
                    label: Text(
                      "Amount",
                      textAlign: TextAlign.center,
                    ),
                    numeric: false,
                    tooltip: "Collection Amount",
                  ),
                  DataColumn(
                    label: Text(
                      "Total Received",
                      textAlign: TextAlign.center,
                    ),
                    numeric: false,
                    tooltip: "Received Amount",
                  ),
                  DataColumn(
                    label: Text(
                      "Received On Time",
                      textAlign: TextAlign.center,
                    ),
                    numeric: false,
                    tooltip: "Amount Received On Time",
                  ),
                  DataColumn(
                    label: Text(
                      "Received Late",
                      textAlign: TextAlign.center,
                    ),
                    numeric: false,
                    tooltip: "Amount Received Late",
                  ),
                  DataColumn(
                    label: Text(
                      "Pending",
                      textAlign: TextAlign.center,
                    ),
                    numeric: false,
                    tooltip: "Pending Amount",
                  ),
                ],
                rows: getRows(context, snapshot.data),
              ),
            );
          } else {
            // No Collections available for this filterred view
            widget = Center(
              child: Container(
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
            );
          }
        } else if (snapshot.hasError) {
          widget = Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: AsyncWidgets.asyncError(),
            ),
          );
        } else {
          widget = Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: AsyncWidgets.asyncWaiting(),
            ),
          );
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
                              ? snapshot.data.length.toString()
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
              widget,
            ],
          ),
        );
      },
    );
  }

  List<DataRow> getRows(BuildContext context, List<Collection> colls) {
    List<DataRow> rows = [];
    for (int i = 0; i < colls.length; i++) {
      Collection coll = colls[i];
      Color color = getCardColor(coll.getStatus());
      rows.add(
        DataRow(
          onSelectChanged: (bool val) {
            if (val) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ViewCollection(coll, custName, _payment.createdAt, color),
                  settings: RouteSettings(name: '/customers/payment/colection'),
                ),
              );
            }
          },
          cells: <DataCell>[
            DataCell(IconButton(
              color: CustomColors.mfinPositiveGreen,
              icon: (coll.getReceived() == coll.collectionAmount)
                  ? Icon(Icons.check_box)
                  : Icon(Icons.check_box_outline_blank),
              onPressed: () {
                markAsCollected(coll, context);
              },
            )),
            DataCell(
              Text(
                coll.collectionNumber.toString(),
                style: TextStyle(
                  color: color,
                ),
              ),
            ),
            DataCell(
              Text(
                DateUtils.formatDate(coll.collectionDate),
                style: TextStyle(
                  color: color,
                ),
              ),
            ),
            DataCell(
              Text(
                getType(coll.type),
                style: TextStyle(
                  color: color,
                ),
              ),
            ),
            DataCell(
              Text(
                coll.collectionAmount.toString(),
                style: TextStyle(
                  color: color,
                ),
              ),
            ),
            DataCell(
              Text(
                (coll.getReceived()).toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color,
                ),
              ),
            ),
            DataCell(
              Text(
                (coll.getPaidOnTime()).toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color,
                ),
              ),
            ),
            DataCell(
              Text(
                (coll.getPaidLate()).toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: CustomColors.mfinAlertRed,
                ),
              ),
            ),
            DataCell(
              Text(
                (coll.getPending()).toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return rows;
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

  Color getCardColor(int status) {
    switch (status) {
      case 0:
        return CustomColors.mfinBlack;
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
        return CustomColors.mfinBlack;
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
      Map<String, dynamic> collDetails = {'collected_on': DateTime.now()};
      collDetails['amount'] =
          collection.collectionAmount - collection.getReceived();
      collDetails['notes'] = "";
      collDetails['collected_by'] = _user.name;
      collDetails['collected_from'] = custName;
      collDetails['created_at'] = DateTime.now();
      collDetails['added_by'] = _user.mobileNumber;
      if (collection.collectionDate.isBefore(DateUtils.getCurrentISTDate()))
        collDetails['is_paid_late'] = true;
      else
        collDetails['is_paid_late'] = false;

      var result = await _cc.updateCollectionDetails(
          collection.financeID,
          collection.branchName,
          collection.subBranchName,
          collection.customerNumber,
          _payment.createdAt,
          collection.collectionDate,
          true,
          collDetails);

      if (!result['is_success']) {
        Navigator.pop(context);
        _scaffoldKey.currentState
            .showSnackBar(CustomSnackBar.errorSnackBar(result['message'], 5));
        print("Unable to Mark as Collectied: " + result['message']);
      } else {
        Navigator.pop(context);
      }
    }
  }
}
