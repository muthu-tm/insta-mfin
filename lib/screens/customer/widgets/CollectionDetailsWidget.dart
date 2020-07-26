import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:folding_cell/folding_cell/widget.dart';
import 'package:instamfin/db/models/collection.dart';
import 'package:instamfin/db/models/collection_details.dart';
import 'package:instamfin/screens/customer/AddCollectionDetails.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/transaction/collection_controller.dart';

class CollectionDetailsWidget extends StatelessWidget {
  CollectionDetailsWidget(
      this.paySettled, this._scaffoldKey, this._collection, this.custName);

  final bool paySettled;
  final GlobalKey<ScaffoldState> _scaffoldKey;
  final Collection _collection;
  final String custName;

  @override
  Widget build(BuildContext context) {
    List<Widget> widget;
    if (_collection.collections == null ||
        _collection.collections.length == 0) {
      widget = <Widget>[
        Text(
          "No Collection received yet!",
          style: TextStyle(
            color: CustomColors.mfinAlertRed,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 10.0, top: 20.0),
          child: Text(
            "Update collection using 'Update' button",
            style: TextStyle(
              color: CustomColors.mfinBlue,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ];
    } else {
      widget = <Widget>[
        ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          primary: false,
          itemCount: _collection.collections == null
              ? 0
              : _collection.collections.length,
          itemBuilder: (BuildContext context, int index) {
            CollectionDetails _collectionDetails =
                _collection.collections[index];

            Color cardColor = CustomColors.mfinGrey;
            Color textColor = CustomColors.mfinBlue;
            if (index % 2 == 0) {
              cardColor = CustomColors.mfinBlue;
              textColor = CustomColors.mfinGrey;
            }
            return SimpleFoldingCell(
              frontWidget: _buildFrontWidget(
                  context, _collectionDetails, cardColor, textColor),
              innerTopWidget: _buildInnerTopWidget(_collectionDetails),
              innerBottomWidget:
                  _buildInnerBottomWidget(context, _collectionDetails),
              cellSize: Size(MediaQuery.of(context).size.width, 170),
              padding: EdgeInsets.only(
                  left: 15.0, top: 5.0, right: 15.0, bottom: 5.0),
              animationDuration: Duration(milliseconds: 300),
              borderRadius: 10,
            );
          },
        ),
      ];
    }

    return Card(
      color: CustomColors.mfinLightGrey,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(
              Icons.collections_bookmark,
              size: 35.0,
              color: CustomColors.mfinButtonGreen,
            ),
            title: Text(
              "Collection Details",
              style: TextStyle(
                color: CustomColors.mfinBlue,
                fontSize: 18.0,
              ),
            ),
            // trailing: IconButton(
            //   icon: Icon(
            //     Icons.add_box,
            //     size: 35.0,
            //     color: CustomColors.mfinBlue,
            //   ),
            //   onPressed: () {
            //     if (paySettled) {
            //       _scaffoldKey.currentState.showSnackBar(
            //           CustomSnackBar.errorSnackBar(
            //               "You cannot edit already 'SETTLED' Payment", 2));
            //     } else {
            //       if (_collection.getReceived() <
            //           _collection.collectionAmount) {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) =>
            //                 AddCollectionDetails(_collection, custName),
            //             settings: RouteSettings(
            //                 name:
            //                     '/customers/payments/collections/collectiondetails/add'),
            //           ),
            //         );
            //       } else {
            //         _scaffoldKey.currentState.showSnackBar(
            //             CustomSnackBar.errorSnackBar(
            //                 "Collection AMOUNT already collected Fully", 2));
            //       }
            //     }
            //   },
            // ),
          ),
          Divider(
            color: CustomColors.mfinBlue,
            thickness: 1,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: widget,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrontWidget(BuildContext context,
      CollectionDetails _collectionDetails, Color cardColor, Color textColor) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.30,
      closeOnScroll: true,
      direction: Axis.horizontal,
      actions: <Widget>[
        IconSlideAction(
          caption: 'Remove',
          color: CustomColors.mfinAlertRed,
          icon: Icons.delete_forever,
          onTap: () async {
            if (paySettled) {
              _scaffoldKey.currentState.showSnackBar(
                  CustomSnackBar.errorSnackBar(
                      "You cannot edit already 'SETTLED' Payment", 2));
            } else {
              var state = Slidable.of(context);
              var dismiss = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                      "Confirm!",
                      style: TextStyle(
                          color: CustomColors.mfinAlertRed,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                    content: Text(
                      "Are you sure to remove this ${_collectionDetails.amount} collection",
                    ),
                    actions: <Widget>[
                      FlatButton(
                        color: CustomColors.mfinButtonGreen,
                        child: Text(
                          "NO",
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
                          "YES",
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
                              _collectionDetails.toJson(),
                              (_collectionDetails.penaltyAmount > 0));
                          if (!result['is_success']) {
                            Navigator.pop(context);
                            _scaffoldKey.currentState.showSnackBar(
                                CustomSnackBar.errorSnackBar(
                                    result['message'], 2));
                          } else {
                            _scaffoldKey.currentState.showSnackBar(
                                CustomSnackBar.successSnackBar(
                                    "Collection ${_collectionDetails.amount} removed successfully",
                                    2));
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ],
                  );
                },
              );

              if (dismiss != null && dismiss && state != null) {
                state.dismiss();
              }
            }
          },
        ),
      ],
      child: Builder(
        builder: (BuildContext context) {
          return InkWell(
            onTap: () {
              SimpleFoldingCellState foldingCellState =
                  context.findAncestorStateOfType();
              foldingCellState?.toggleFold();
            },
            child: Container(
              color: cardColor,
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Text(
                      'Date',
                      style: TextStyle(
                          color: textColor,
                          fontFamily: 'Georgia',
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      DateUtils.getFormattedDateFromEpoch(
                          _collectionDetails.collectedOn),
                      style: TextStyle(
                          color: CustomColors.mfinWhite,
                          fontFamily: 'Georgia',
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    leading: Text(
                      "AMOUNT",
                      style: TextStyle(
                          color: textColor,
                          fontFamily: 'Georgia',
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      _collectionDetails.amount.toString(),
                      style: TextStyle(
                          color: CustomColors.mfinPositiveGreen,
                          fontFamily: 'Georgia',
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    leading: Text(
                      "FROM",
                      style: TextStyle(
                          color: textColor,
                          fontFamily: 'Georgia',
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      _collectionDetails.collectedFrom,
                      style: TextStyle(
                          color: CustomColors.mfinWhite,
                          fontFamily: 'Georgia',
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInnerBottomWidget(
      BuildContext context, CollectionDetails _collectionDetails) {
    return Container(
      color: CustomColors.mfinBlue,
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Text(
              'By',
              style: TextStyle(
                  color: CustomColors.mfinGrey,
                  fontFamily: 'Georgia',
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              _collectionDetails.collectedBy,
              style: TextStyle(
                  color: CustomColors.mfinWhite,
                  fontFamily: 'Georgia',
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Text(
              'NOTES',
              style: TextStyle(
                  color: CustomColors.mfinGrey,
                  fontFamily: 'Georgia',
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
            trailing: SizedBox(
              width: MediaQuery.of(context).size.width * 0.65,
              child: Text(
                _collectionDetails.notes,
                textAlign: TextAlign.end,
                style: TextStyle(
                    color: CustomColors.mfinWhite,
                    fontFamily: 'Georgia',
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ListTile(
            leading: Text(
              'PAID LATE?',
              style: TextStyle(
                  color: CustomColors.mfinGrey,
                  fontFamily: 'Georgia',
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
            trailing: SizedBox(
              width: MediaQuery.of(context).size.width * 0.65,
              child: Text(
                _collectionDetails.isPaidLate ? "YES" : "NO",
                textAlign: TextAlign.end,
                style: TextStyle(
                    color: _collectionDetails.isPaidLate
                        ? CustomColors.mfinAlertRed
                        : CustomColors.mfinPositiveGreen,
                    fontFamily: 'Georgia',
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInnerTopWidget(CollectionDetails _collectionDetails) {
    return Builder(
      builder: (context) {
        return InkWell(
          onTap: () {
            SimpleFoldingCellState foldingCellState =
                context.findAncestorStateOfType();
            foldingCellState?.toggleFold();
          },
          child: Container(
            color: CustomColors.mfinGrey,
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Text(
                    'Date',
                    style: TextStyle(
                        color: CustomColors.mfinBlue,
                        fontFamily: 'Georgia',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    DateUtils.getFormattedDateFromEpoch(
                        _collectionDetails.collectedOn),
                    style: TextStyle(
                        color: CustomColors.mfinWhite,
                        fontFamily: 'Georgia',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  leading: Text(
                    "AMOUNT",
                    style: TextStyle(
                        color: CustomColors.mfinBlue,
                        fontFamily: 'Georgia',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    _collectionDetails.amount.toString(),
                    style: TextStyle(
                        color: CustomColors.mfinPositiveGreen,
                        fontFamily: 'Georgia',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  leading: Text(
                    "FROM",
                    style: TextStyle(
                        color: CustomColors.mfinBlue,
                        fontFamily: 'Georgia',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    _collectionDetails.collectedFrom,
                    style: TextStyle(
                        color: CustomColors.mfinWhite,
                        fontFamily: 'Georgia',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
