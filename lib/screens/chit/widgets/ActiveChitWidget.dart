import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/db/models/chit_fund.dart';
import 'package:instamfin/screens/chit/ViewChitFund.dart';
import 'package:instamfin/screens/chit/ViewChitRequesters.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/chit/chit_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class ActiveChitWidget extends StatelessWidget {
  TextEditingController _pController = TextEditingController();
  ActiveChitWidget(this._scaffoldKey);

  final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ChitFund().streamAllByStatus(false),
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
                  ChitFund chit =
                      ChitFund.fromJson(snapshot.data.documents[index].data);

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
                              chit.chitName,
                              style: TextStyle(
                                color: CustomColors.mfinLightGrey,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                              chit.chitID,
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
                          ListTile(
                            leading: Text(
                              'Published On:',
                              style: TextStyle(
                                color: CustomColors.mfinGrey,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                              DateUtils.formatDate(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      chit.datePublished)),
                              style: TextStyle(
                                color: CustomColors.mfinLightGrey,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ListTile(
                            leading: Text(
                              'Amount:',
                              style: TextStyle(
                                color: CustomColors.mfinGrey,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                              chit.chitAmount.toString(),
                              style: TextStyle(
                                color: CustomColors.mfinLightGrey,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ListTile(
                            leading: Text(
                              'Chit Day:',
                              style: TextStyle(
                                color: CustomColors.mfinGrey,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                              chit.collectionDate.toString(),
                              style: TextStyle(
                                color: CustomColors.mfinLightGrey,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Divider(
                            color: CustomColors.mfinAlertRed,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              FlatButton.icon(
                                onPressed: () {
                                  CustomDialogs.confirm(context, "Confirm!",
                                      "Are you sure to remove this ${chit.chitName} ChitFund?",
                                      () async {
                                    Navigator.pop(context);
                                    _scaffoldKey.currentState.showSnackBar(
                                        CustomSnackBar.successSnackBar(
                                            "Removing ${chit.chitName} ChitFund.. Please Wait...",
                                            4));
                                    ChitController _cc = ChitController();
                                    var result =
                                        await _cc.removeChitFund(chit.id);
                                    if (result == null) {
                                      await forceRemoveChit(
                                          context,
                                          "Few collections are done already\n\nPlease confirm with Secret KEY!",
                                          chit);
                                    } else {
                                      if (!result['is_success']) {
                                        _scaffoldKey.currentState.showSnackBar(
                                            CustomSnackBar.errorSnackBar(
                                                result['message'], 3));
                                      }
                                    }
                                  }, () {
                                    Navigator.pop(context);
                                  });
                                },
                                icon: Icon(Icons.payment),
                                label: Text("Remove"),
                              ),
                              FlatButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewChitFund(chit),
                                      settings: RouteSettings(
                                          name: '/chit/active/view'),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.payment),
                                label: Text("View"),
                              ),
                              FlatButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ViewChitRequesters(chit),
                                      settings:
                                          RouteSettings(name: '/chit/active/'),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.monetization_on),
                                label: Text("Requesters"),
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
                      "No Active Chits!",
                      style: TextStyle(
                        color: CustomColors.mfinAlertRed,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    new Spacer(
                      flex: 2,
                    ),
                    Text(
                      "Publish new chit from template!",
                      style: TextStyle(
                        color: CustomColors.mfinBlue,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
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

        return Card(
          color: CustomColors.mfinLightGrey,
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Text(
                  "Active Chits",
                  style: TextStyle(
                    fontFamily: "Georgia",
                    fontWeight: FontWeight.bold,
                    color: CustomColors.mfinPositiveGreen,
                    fontSize: 17.0,
                  ),
                ),
                trailing: RichText(
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
                              ? snapshot.data.documents.length.toString()
                              : "00",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinGrey,
                            fontSize: 18.0,
                          )),
                    ],
                  ),
                ),
              ),
              new Divider(
                color: CustomColors.mfinBlue,
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

  Future forceRemoveChit(
      BuildContext context, String text, ChitFund chit) async {
    await showDialog<bool>(
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
          content: Container(
            height: 175,
            child: Column(
              children: <Widget>[
                Text(text),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Card(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      obscureText: true,
                      autofocus: false,
                      controller: _pController,
                      decoration: InputDecoration(
                        hintText: 'Secret KEY',
                        fillColor: CustomColors.mfinLightGrey,
                        filled: true,
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
                bool isValid = UserController().authCheck(_pController.text);
                _pController.text = "";

                if (isValid) {
                  try {
                    Navigator.pop(context);
                    _scaffoldKey.currentState.showSnackBar(
                      CustomSnackBar.successSnackBar(
                        "Removing ${chit.chitName} ChitFund. It may take upto 10-30sec. Please Wait!",
                        3,
                      ),
                    );
                    await chit.forceRemoveChit();
                  } catch (err) {
                    _scaffoldKey.currentState.showSnackBar(
                      CustomSnackBar.errorSnackBar(
                        "Unable to remove the Chit now! Please try again later.",
                        3,
                      ),
                    );
                  }
                } else {
                  Navigator.pop(context);
                  _scaffoldKey.currentState.showSnackBar(
                    CustomSnackBar.errorSnackBar(
                      "Failed to Authenticate!",
                      3,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
