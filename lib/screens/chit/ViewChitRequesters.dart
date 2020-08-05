import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/db/models/chit_fund.dart';
import 'package:instamfin/db/models/chit_requesters.dart';
import 'package:instamfin/screens/chit/AddChitRequester.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';

import '../../app_localizations.dart';

class ViewChitRequesters extends StatefulWidget {
  ViewChitRequesters(this.chit);

  final ChitFund chit;

  @override
  _ViewChitRequestersState createState() => _ViewChitRequestersState();
}

class _ViewChitRequestersState extends State<ViewChitRequesters> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
            '${AppLocalizations.of(context).translate('requesters')} ${widget.chit.chitID}'),
        backgroundColor: CustomColors.mfinBlue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: CustomColors.mfinBlue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddChitRequester(widget.chit),
              settings: RouteSettings(name: '/chits/requesters/add'),
            ),
          );
        },
        label: Text(
          AppLocalizations.of(context).translate('add'),
        ),
        icon: Icon(
          Icons.add,
          color: CustomColors.mfinFadedButtonGreen,
        ),
      ),
      body: SingleChildScrollView(child: _getBody()),
    );
  }

  Widget _getBody() {
    return StreamBuilder(
      stream: ChitRequesters().streamRequesters(widget.chit.financeID,
          widget.chit.branchName, widget.chit.subBranchName, widget.chit.id),
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
                  ChitRequesters chitReq = ChitRequesters.fromJson(
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
                              AppLocalizations.of(context)
                                  .translate('customers_colon'),
                              style: TextStyle(
                                color: CustomColors.mfinGrey,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                              chitReq.custNumber.toString(),
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
                                  .translate('chit_number_colon'),
                              style: TextStyle(
                                color: CustomColors.mfinGrey,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                              chitReq.chitNumber.toString(),
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
                                  .translate('requested_at_colon'),
                              style: TextStyle(
                                color: CustomColors.mfinGrey,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                              DateUtils.formatDate(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      chitReq.requestedAt)),
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
                                  .translate('allocated_ques'),
                              style: TextStyle(
                                color: CustomColors.mfinGrey,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                              chitReq.isAllocated ? "YES" : "NO",
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
                                onPressed: () async {
                                  if (chitReq.isAllocated) {
                                    _scaffoldKey.currentState.showSnackBar(
                                      CustomSnackBar.errorSnackBar(
                                          "Already you marked this request as Allocated",
                                          2),
                                    );
                                    return;
                                  }
                                  CustomDialogs.actionWaiting(
                                      context, "Updating...");
                                  try {
                                    await ChitRequesters().update(
                                        widget.chit.financeID,
                                        widget.chit.branchName,
                                        widget.chit.subBranchName,
                                        widget.chit.id,
                                        chitReq.createdAt,
                                        {'is_allocated': true});
                                    Navigator.pop(context);
                                    _scaffoldKey.currentState.showSnackBar(
                                        CustomSnackBar.successSnackBar(
                                            AppLocalizations.of(context)
                                                .translate('marked_collected'),
                                            2));
                                  } catch (err) {
                                    Navigator.pop(context);
                                    _scaffoldKey.currentState.showSnackBar(
                                        CustomSnackBar.errorSnackBar(
                                            AppLocalizations.of(context)
                                                .translate('unable_to_update'),
                                            2));
                                  }
                                },
                                icon: Icon(Icons.edit),
                                label: Text(
                                  AppLocalizations.of(context)
                                      .translate('mark_as_allocated'),
                                ),
                              ),
                              FlatButton.icon(
                                onPressed: () async {
                                  CustomDialogs.actionWaiting(
                                      context, "Removing");
                                  try {
                                    await ChitRequesters().remove(
                                        widget.chit.financeID,
                                        widget.chit.branchName,
                                        widget.chit.subBranchName,
                                        widget.chit.id,
                                        chitReq.createdAt);
                                    Navigator.pop(context);
                                    _scaffoldKey.currentState.showSnackBar(
                                      CustomSnackBar.successSnackBar(
                                          AppLocalizations.of(context)
                                              .translate('removed_request'),
                                          2),
                                    );
                                  } catch (err) {
                                    Navigator.pop(context);
                                    _scaffoldKey.currentState.showSnackBar(
                                      CustomSnackBar.errorSnackBar(
                                          AppLocalizations.of(context)
                                              .translate(
                                                  'unable_remove_request'),
                                          2),
                                    );
                                  }
                                },
                                icon: Icon(Icons.remove_circle),
                                label: Text(
                                  AppLocalizations.of(context)
                                      .translate('remove_request'),
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
              Text(
                AppLocalizations.of(context).translate('no_requesters'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: CustomColors.mfinAlertRed,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          ),
        );
      },
    );
  }
}
