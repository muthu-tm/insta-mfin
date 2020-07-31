import 'package:flutter/material.dart';
import 'package:instamfin/db/models/chit_allocations.dart';
import 'package:instamfin/db/models/chit_fund.dart';
import 'package:instamfin/db/models/chit_fund_details.dart';
import 'package:instamfin/screens/chit/ViewChitAllocations.dart';
import 'package:instamfin/screens/chit/ViewChitCollections.dart';
import 'package:instamfin/screens/chit/widgets/ChitCustomerAllocation.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/date_utils.dart';

import '../../app_localizations.dart';

class ViewChitFund extends StatefulWidget {
  ViewChitFund(this.chit);

  final ChitFund chit;

  @override
  _ViewChitFundState createState() => _ViewChitFundState();
}

class _ViewChitFundState extends State<ViewChitFund> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
            '${AppLocalizations.of(context).translate('chit')} - ${widget.chit.chitID}'),
        backgroundColor: CustomColors.mfinBlue,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                itemCount: widget.chit.fundDetails.length,
                itemBuilder: (BuildContext context, int index) {
                  ChitFundDetails _fund = widget.chit.fundDetails[index];
                  return Padding(
                    padding: EdgeInsets.all(5),
                    child: Container(
                      color: CustomColors.mfinLightGrey,
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: Text(
                              '${_fund.chitNumber}',
                              style: TextStyle(
                                color: CustomColors.mfinButtonGreen,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                              DateUtils.formatDate(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      _fund.chitDate)),
                              style: TextStyle(
                                color: CustomColors.mfinAlertRed,
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
                                  .translate('chit_amount'),
                              style: TextStyle(
                                color: CustomColors.mfinBlue,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                              'Rs.${_fund.totalAmount}',
                              style: TextStyle(
                                color: CustomColors.mfinBlue,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ListTile(
                            leading: Text(
                              AppLocalizations.of(context)
                                  .translate('allocation'),
                              style: TextStyle(
                                color: CustomColors.mfinBlue,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                              'Rs.${_fund.allocationAmount}',
                              style: TextStyle(
                                color: CustomColors.mfinBlue,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ListTile(
                            leading: Text(
                              AppLocalizations.of(context)
                                  .translate('commission'),
                              style: TextStyle(
                                color: CustomColors.mfinBlue,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                              'Rs.${_fund.profit}',
                              style: TextStyle(
                                color: CustomColors.mfinBlue,
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewChitCollections(
                                          widget.chit.id, _fund),
                                      settings: RouteSettings(
                                          name: '/chit/collections'),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.payment),
                                label: Text(
                                  AppLocalizations.of(context)
                                      .translate('collections'),
                                ),
                              ),
                              FlatButton.icon(
                                onPressed: () async {
                                  ChitAllocations chitAlloc =
                                      await ChitAllocations()
                                          .getAllocationsByNumber(
                                              widget.chit.financeID,
                                              widget.chit.branchName,
                                              widget.chit.subBranchName,
                                              widget.chit.id,
                                              _fund.chitNumber);
                                  if (chitAlloc == null) {
                                    showDialog(
                                      context: context,
                                      routeSettings: RouteSettings(
                                          name: "/chit/allocations/customer"),
                                      builder: (context) {
                                        return Center(
                                          child: chitCustomerAllocationDialog(
                                              context,
                                              _scaffoldKey,
                                              widget.chit,
                                              _fund),
                                        );
                                      },
                                    );
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ViewChitAllocations(
                                                chitAlloc, _fund),
                                        settings: RouteSettings(
                                            name: '/chit/allocations/view'),
                                      ),
                                    );
                                  }
                                },
                                icon: Icon(Icons.monetization_on),
                                label: Text(
                                  AppLocalizations.of(context)
                                      .translate('allocation'),
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
            ],
          ),
        ),
      ),
    );
  }
}
