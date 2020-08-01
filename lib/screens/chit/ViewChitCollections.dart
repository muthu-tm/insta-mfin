import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/db/models/chit_collection.dart';
import 'package:instamfin/db/models/chit_fund_details.dart';
import 'package:instamfin/db/models/user_primary.dart';
import 'package:instamfin/screens/chit/AddChitCollectionDetails.dart';
import 'package:instamfin/screens/chit/ViewChitCollectionDetails.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

import '../../app_localizations.dart';

class ViewChitCollections extends StatefulWidget {
  ViewChitCollections(
      this.chitID, this.isClosed, this.chitName, this.fundDetails);

  final int chitID;
  final bool isClosed;
  final String chitName;
  final ChitFundDetails fundDetails;

  @override
  _ViewChitCollectionsState createState() => _ViewChitCollectionsState();
}

class _ViewChitCollectionsState extends State<ViewChitCollections> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final UserPrimary _primary = UserController().getUserPrimary();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('${widget.chitName} - ${widget.fundDetails.chitNumber}'),
        backgroundColor: CustomColors.mfinBlue,
      ),
      body: SingleChildScrollView(child: _getBody()),
    );
  }

  Widget _getBody() {
    return StreamBuilder(
      stream: ChitCollection().streamCollectionsForChit(
          _primary.financeID,
          _primary.branchName,
          _primary.subBranchName,
          widget.chitID,
          widget.fundDetails.chitNumber),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          if (snapshot.data.documents.isNotEmpty) {
            children = <Widget>[
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  ChitCollection chitColl = ChitCollection.fromJson(
                      snapshot.data.documents[index].data);

                  return Padding(
                    padding: EdgeInsets.all(5),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        color: CustomColors.mfinBlue,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: Text(
                              chitColl.collectionAmount.toString(),
                              style: TextStyle(
                                color: CustomColors.mfinLightGrey,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                              chitColl.customerNumber.toString(),
                              style: TextStyle(
                                color: CustomColors.mfinLightGrey,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ListTile(
                            leading: Text(
                              AppLocalizations.of(context)
                                  .translate('received'),
                              style: TextStyle(
                                color: CustomColors.mfinGrey,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                              chitColl.getReceived().toString(),
                              style: TextStyle(
                                color: CustomColors.mfinLightGrey,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Divider(
                            color: CustomColors.mfinButtonGreen,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              FlatButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ViewChitCollectionDetails(chitColl),
                                      settings: RouteSettings(
                                          name:
                                              '/chit/collections/collectionDetails'),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.remove_red_eye),
                                label: Text(AppLocalizations.of(context)
                                    .translate('view')),
                              ),
                              FlatButton.icon(
                                onPressed: () {
                                  if (widget.isClosed) {
                                    _scaffoldKey.currentState.showSnackBar(
                                      CustomSnackBar.errorSnackBar(
                                          "Cannot Add collection for CLOSED Chit Fund!",
                                          2),
                                    );
                                    return;
                                  }
                                  
                                  if (chitColl.isPaid) {
                                    _scaffoldKey.currentState.showSnackBar(
                                      CustomSnackBar.errorSnackBar(
                                          AppLocalizations.of(context)
                                              .translate('chit_full'),
                                          2),
                                    );
                                    return;
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AddChitCollectionDetails(chitColl),
                                        settings: RouteSettings(
                                            name:
                                                '/chit/collections/collectionDetails/add'),
                                      ),
                                    );
                                  }
                                },
                                icon: Icon(Icons.monetization_on),
                                label: Text(
                                  AppLocalizations.of(context)
                                      .translate('add_collection'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            ];
          } else {
            children = [
              Container(
                height: 90,
                child: Column(
                  children: <Widget>[
                    new Spacer(),
                    Text(
                      AppLocalizations.of(context)
                          .translate('no_collection_chit'),
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

        return Container(
          color: CustomColors.mfinLightGrey,
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Text(
                  AppLocalizations.of(context).translate('chit_date_colon'),
                  style: TextStyle(
                    color: CustomColors.mfinBlue,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Text(
                  DateUtils.formatDate(DateTime.fromMillisecondsSinceEpoch(
                      widget.fundDetails.chitDate)),
                  style: TextStyle(
                    color: CustomColors.mfinGrey,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: Text(
                  AppLocalizations.of(context).translate('total_amount_colon'),
                  style: TextStyle(
                    color: CustomColors.mfinBlue,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Text(
                  'Rs.${widget.fundDetails.totalAmount}',
                  style: TextStyle(
                    color: CustomColors.mfinGrey,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                child: Column(children: children),
              ),
            ],
          ),
        );
      },
    );
  }
}
