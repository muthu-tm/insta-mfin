import 'package:flutter/material.dart';
import 'package:instamfin/db/models/chit_fund.dart';
import 'package:instamfin/db/models/chit_fund_details.dart';
import 'package:instamfin/screens/chit/ViewChitCollections.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/date_utils.dart';

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
        title: Text('Chit - ${widget.chit.chitID}'),
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
                              'Chit Amount',
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
                              'Allocation',
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
                              'Commission',
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
                          ListTile(
                            leading: Text(
                              'Collection Amount',
                              style: TextStyle(
                                color: CustomColors.mfinBlue,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                              'Rs.${_fund.collectionAmount}',
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
                                          widget.chit.chitID, _fund),
                                      settings: RouteSettings(
                                          name: '/chit/collections'),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.payment),
                                label: Text("Collections"),
                              ),
                              FlatButton.icon(
                                onPressed: () {
                                  print("Clicked Chit Allocation");
                                },
                                icon: Icon(Icons.monetization_on),
                                label: Text("Allocation"),
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
