import 'package:flutter/material.dart';
import 'package:instamfin/db/models/chit_fund.dart';
import 'package:instamfin/screens/chit/ViewChitFund.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/date_utils.dart';

import '../../../app_localizations.dart';

class CustomerChitsWidget extends StatelessWidget {
  CustomerChitsWidget(this.number);

  final int number;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ChitFund().getAllChitsForCustomer(number),
      builder: (BuildContext context, AsyncSnapshot<List<ChitFund>> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            children = <Widget>[
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  ChitFund chit = snapshot.data[index];

                  return Padding(
                    padding: EdgeInsets.all(5),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewChitFund(chit),
                            settings: RouteSettings(name: '/chit/customer/'),
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
                                    .translate('published_on'),
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
                                    .translate('amount'),
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
                                    .translate('chit_day'),
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
            // No chits available for this customer
            children = [
              Container(
                height: 90,
                child: Column(
                  children: <Widget>[
                    new Spacer(),
                    Text(
                      AppLocalizations.of(context).translate('no_chits'),
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
                      AppLocalizations.of(context)
                          .translate('add_customer_chit'),
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
          child: new Column(
            children: <Widget>[
              ListTile(
                leading: Text(
                  AppLocalizations.of(context).translate('chits_cap'),
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
