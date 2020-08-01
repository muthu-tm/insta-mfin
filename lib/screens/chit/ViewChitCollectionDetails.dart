import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:folding_cell/folding_cell/widget.dart';
import 'package:instamfin/db/models/chit_collection.dart';
import 'package:instamfin/db/models/collection_details.dart';
import 'package:instamfin/screens/chit/AddChitCollectionDetails.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/chit/chit_controller.dart';

import '../../app_localizations.dart';

class ViewChitCollectionDetails extends StatefulWidget {
  ViewChitCollectionDetails(this.collection);

  final ChitCollection collection;
  @override
  _ViewChitCollectionDetailsState createState() =>
      _ViewChitCollectionDetailsState();
}

class _ViewChitCollectionDetailsState extends State<ViewChitCollectionDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
            '${widget.collection.customerNumber}: ${AppLocalizations.of(context).translate('chit')} -  ${widget.collection.chitNumber}'),
        backgroundColor: CustomColors.mfinBlue,
      ),
      body: SingleChildScrollView(child: _getBody()),
    );
  }

  Widget _getBody() {
    return StreamBuilder(
      stream: ChitCollection().streamCollectionByID(
          widget.collection.financeID,
          widget.collection.branchName,
          widget.collection.subBranchName,
          widget.collection.chitID,
          widget.collection.customerNumber,
          widget.collection.chitNumber),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          if (snapshot.data.exists && snapshot.data.data.isNotEmpty) {
            ChitCollection _coll = ChitCollection.fromJson(snapshot.data.data);

            if (_coll.collections != null && _coll.collections.length != 0) {
              children = <Widget>[
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  itemCount: _coll.collections.length,
                  itemBuilder: (BuildContext context, int index) {
                    CollectionDetails _collectionDetails =
                        _coll.collections[index];

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
            } else {
              children = <Widget>[
                Text(
                  AppLocalizations.of(context)
                      .translate('no_collection_received'),
                  style: TextStyle(
                    color: CustomColors.mfinAlertRed,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0, top: 20.0),
                  child: Text(
                    AppLocalizations.of(context)
                        .translate('add_collection_sign'),
                    style: TextStyle(
                      color: CustomColors.mfinBlue,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ];
            }
          }
        } else if (snapshot.hasError) {
          children = AsyncWidgets.asyncError();
        } else {
          children = AsyncWidgets.asyncWaiting();
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
                    if (widget.collection.isClosed) {
                      _scaffoldKey.currentState.showSnackBar(
                        CustomSnackBar.errorSnackBar(
                            AppLocalizations.of(context)
                                .translate('cannot_edit_chit'),
                            2),
                      );
                    } else {
                      if (!widget.collection.isPaid) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AddChitCollectionDetails(widget.collection),
                            settings: RouteSettings(
                                name:
                                    '/chits/collections/collectiondetails/add'),
                          ),
                        );
                      } else {
                        _scaffoldKey.currentState.showSnackBar(
                          CustomSnackBar.errorSnackBar(
                              AppLocalizations.of(context)
                                  .translate('chit_collected_fully'),
                              2),
                        );
                      }
                    }
                  },
                ),
              ),
              Divider(
                color: CustomColors.mfinBlue,
                thickness: 1,
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
            if (widget.collection.isClosed) {
              _scaffoldKey.currentState.showSnackBar(
                CustomSnackBar.errorSnackBar(
                    AppLocalizations.of(context).translate('cannot_edit_chit'),
                    2),
              );
            } else {
              var state = Slidable.of(context);
              var dismiss = await showDialog<bool>(
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
                      "${AppLocalizations.of(context).translate('are_you_sure')} ${_collectionDetails.amount} ${AppLocalizations.of(context).translate('collection')}",
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
                          AppLocalizations.of(context).translate('yes'),
                          style: TextStyle(
                              color: CustomColors.mfinLightGrey,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                        ),
                        onPressed: () async {
                          ChitController _cc = ChitController();
                          var result = await _cc.updateCollectionDetails(
                              widget.collection.financeID,
                              widget.collection.branchName,
                              widget.collection.subBranchName,
                              widget.collection.chitID,
                              widget.collection.customerNumber,
                              widget.collection.chitNumber,
                              false,
                              false,
                              _collectionDetails.toJson());
                          if (!result['is_success']) {
                            Navigator.pop(context);
                            _scaffoldKey.currentState.showSnackBar(
                                CustomSnackBar.errorSnackBar(
                                    result['message'], 2));
                          } else {
                            _scaffoldKey.currentState.showSnackBar(
                                CustomSnackBar.successSnackBar(
                                    "Chit Collection ${_collectionDetails.amount} removed successfully",
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
                      AppLocalizations.of(context).translate('date'),
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
                      AppLocalizations.of(context).translate('amount_caps'),
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
                      AppLocalizations.of(context).translate('from'),
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
              AppLocalizations.of(context).translate('by'),
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
              AppLocalizations.of(context).translate('notes'),
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
              AppLocalizations.of(context).translate('paid_late'),
              style: TextStyle(
                  color: CustomColors.mfinGrey,
                  fontFamily: 'Georgia',
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
            trailing: SizedBox(
              width: MediaQuery.of(context).size.width * 0.65,
              child: Text(
                _collectionDetails.isPaidLate
                    ? AppLocalizations.of(context).translate('yes')
                    : AppLocalizations.of(context).translate('no'),
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
                    AppLocalizations.of(context).translate('date'),
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
                    AppLocalizations.of(context).translate('amount_caps'),
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
                    AppLocalizations.of(context).translate('from_caps'),
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
