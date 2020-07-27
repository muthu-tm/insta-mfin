import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/db/models/chit_fund.dart';
import 'package:instamfin/screens/chit/ViewChitFund.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/date_utils.dart';

import '../../../app_localizations.dart';

class ClosedChitWidget extends StatelessWidget {
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
}
