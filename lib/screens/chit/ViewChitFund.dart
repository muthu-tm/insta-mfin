import 'package:flutter/material.dart';
import 'package:instamfin/db/models/chit_allocations.dart';
import 'package:instamfin/db/models/chit_fund.dart';
import 'package:instamfin/db/models/chit_fund_details.dart';
import 'package:instamfin/screens/chit/ViewChitAllocations.dart';
import 'package:instamfin/screens/chit/ViewChitCollections.dart';
import 'package:instamfin/screens/chit/widgets/ChitCustomerAllocation.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

import '../../app_localizations.dart';

class ViewChitFund extends StatefulWidget {
  ViewChitFund(this.chit);

  final ChitFund chit;

  @override
  _ViewChitFundState createState() => _ViewChitFundState();
}

class _ViewChitFundState extends State<ViewChitFund> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _pController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
            '${AppLocalizations.of(context).translate('chit')} - ${widget.chit.chitID == "" ? widget.chit.chitName : widget.chit.chitID}'),
        backgroundColor: CustomColors.mfinBlue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (!widget.chit.isClosed) await closeChitFund(context);
        },
        backgroundColor: CustomColors.mfinAlertRed.withOpacity(0.7),
        splashColor: CustomColors.mfinWhite,
        icon: Icon(
          Icons.done_outline,
          size: 30,
          color: CustomColors.mfinWhite,
        ),
        label: Text(
          widget.chit.isClosed ? "CLOSED Chit" : "CLOSE",
          style: TextStyle(
            color: CustomColors.mfinWhite,
          ),
        ),
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
                                          widget.chit.id,
                                          widget.chit.isClosed,
                                          widget.chit.chitName,
                                          _fund),
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
                                  List<ChitAllocations> chitAllocs =
                                      await ChitAllocations()
                                          .getChitAllocations(
                                              widget.chit.financeID,
                                              widget.chit.branchName,
                                              widget.chit.subBranchName,
                                              widget.chit.id);
                                  bool isExist = false;
                                  ChitAllocations chitAlloc;
                                  Map<int, int> allocMap = {};
                                  for (var alloc in chitAllocs) {
                                    if (allocMap.containsKey(alloc.customer))
                                      allocMap[alloc.customer] =
                                          allocMap[alloc.customer] + 1;
                                    else
                                      allocMap[alloc.customer] = 1;
                                    if (alloc.chitNumber == _fund.chitNumber) {
                                      chitAlloc = alloc;
                                      isExist = true;
                                    }
                                  }
                                  if (!isExist) {
                                    if (widget.chit.isClosed) {
                                      _scaffoldKey.currentState.showSnackBar(
                                        CustomSnackBar.errorSnackBar(
                                          "No allocations found for this Chit",
                                          2,
                                        ),
                                      );
                                      return;
                                    } else {
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
                                                _fund,
                                                allocMap),
                                          );
                                        },
                                      );
                                    }
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
                                icon: Icon(Icons.gavel),
                                label: Text(AppLocalizations.of(context)
                                    .translate('allocation')),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              Padding(padding: EdgeInsets.all(35)),
            ],
          ),
        ),
      ),
    );
  }

  Future closeChitFund(BuildContext context) async {
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
                Text(
                    "Enter your Secret KEY! \n\nAfter closing the chit, you cannot do any more transaction. Please Confirm!"),
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
                    CustomDialogs.actionWaiting(context, "Closing...");

                    await widget.chit.update({
                      'is_closed': true,
                      'closed_date': DateUtils.getUTCDateEpoch(DateTime.now())
                    });
                    Navigator.pop(context);
                    Navigator.pop(context);
                  } catch (err) {
                    Navigator.pop(context);
                    _scaffoldKey.currentState.showSnackBar(
                      CustomSnackBar.errorSnackBar(
                        "Unable to close this Chit now! Please try again later.",
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
