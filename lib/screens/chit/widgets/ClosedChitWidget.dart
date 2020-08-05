import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/db/models/chit_fund.dart';
import 'package:instamfin/screens/chit/ViewChitFund.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

import '../../../app_localizations.dart';

class ClosedChitWidget extends StatelessWidget {
  ClosedChitWidget(this._scaffoldKey);

  final GlobalKey<ScaffoldState> _scaffoldKey;

  TextEditingController _pController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ChitFund().streamAllByStatus(true),
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
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewChitFund(chit),
                            settings: RouteSettings(name: '/chit/closed/'),
                          ),
                        );
                      },
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
                                AppLocalizations.of(context)
                                    .translate('published_on_colon'),
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
                                AppLocalizations.of(context)
                                    .translate('amount_colon'),
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
                                AppLocalizations.of(context)
                                    .translate('chit_day_colon'),
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
                            )
                          ],
                        ),
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
                      AppLocalizations.of(context).translate('no_closed_chits'),
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

        return Card(
          color: CustomColors.mfinLightGrey,
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Text(
                  AppLocalizations.of(context).translate('closed_chits'),
                  style: TextStyle(
                    fontFamily: "Georgia",
                    fontWeight: FontWeight.bold,
                    color: CustomColors.mfinPositiveGreen,
                    fontSize: 17.0,
                  ),
                ),
                trailing: RichText(
                  text: TextSpan(
                    text: AppLocalizations.of(context).translate('total_colon'),
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

  Future forceRemoveChit(BuildContext context, String text, ChitFund chit) async {
    await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context).translate('confirm'),
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
