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
        title: Text('Requesters ${widget.chit.chitID}'),
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
        label: Text("Add"),
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
                              'Customer:',
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
                              'Requested At:',
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
                          Divider(
                            color: CustomColors.mfinButtonGreen,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              FlatButton.icon(
                                onPressed: () async {
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
                                            "'Marked As Allocated' successfully",
                                            2));
                                  } catch (err) {
                                    Navigator.pop(context);
                                    _scaffoldKey.currentState.showSnackBar(
                                        CustomSnackBar.errorSnackBar(
                                            "Error, Unable to update now!", 2));
                                  }
                                },
                                icon: Icon(Icons.edit),
                                label: Text("Mark As Allocated"),
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
                                          "Removed the request successfully",
                                          2),
                                    );
                                  } catch (err) {
                                    Navigator.pop(context);
                                    _scaffoldKey.currentState.showSnackBar(
                                      CustomSnackBar.errorSnackBar(
                                          "Error, Unable to remove request now!",
                                          2),
                                    );
                                  }
                                },
                                icon: Icon(Icons.remove_circle),
                                label: Text("Remove Request"),
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
                "No Requesters for this Chit!",
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
            children: children,
          ),
        );
      },
    );
  }
}
