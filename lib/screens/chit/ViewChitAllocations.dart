import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/db/models/chit_allocation_details.dart';
import 'package:instamfin/db/models/chit_allocations.dart';
import 'package:instamfin/db/models/chit_fund_details.dart';
import 'package:instamfin/screens/chit/AddChitAllocation.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/chit/chit_allocation_controller.dart';

class ViewChitAllocations extends StatefulWidget {
  ViewChitAllocations(this.chitAlloc, this.fund);

  final ChitAllocations chitAlloc;
  final ChitFundDetails fund;

  @override
  _ViewChitAllocationsState createState() => _ViewChitAllocationsState();
}

class _ViewChitAllocationsState extends State<ViewChitAllocations> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Allocations - ${widget.fund.chitNumber}'),
        backgroundColor: CustomColors.mfinBlue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: CustomColors.mfinAlertRed.withOpacity(0.7),
        onPressed: () async {
          if (widget.chitAlloc.isPaid) {
            _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
                "Already allocated full amount", 2));
            return;
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AddChitAllocation(widget.chitAlloc, widget.fund),
                settings: RouteSettings(name: '/chits/allocations/add'),
              ),
            );
          }
        },
        label: Text("Add"),
        icon: Icon(
          Icons.add,
          color: CustomColors.mfinWhite,
        ),
      ),
      body: SingleChildScrollView(child: _getBody()),
    );
  }

  Widget _getBody() {
    return StreamBuilder(
      stream: ChitAllocations().streamAllocationsByNumber(
          widget.chitAlloc.financeID,
          widget.chitAlloc.branchName,
          widget.chitAlloc.subBranchName,
          widget.chitAlloc.chitID,
          widget.fund.chitNumber),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          if (snapshot.data.exists) {
            ChitAllocations chitAlloc =
                ChitAllocations.fromJson(snapshot.data.data);
            children = <Widget>[
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                itemCount: chitAlloc.allocations.length,
                itemBuilder: (BuildContext context, int index) {
                  ChitAllocationDetails allocDetails =
                      chitAlloc.allocations[index];

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
                              'Given on:',
                              style: TextStyle(
                                color: CustomColors.mfinGrey,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                              DateUtils.formatDate(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      allocDetails.givenOn)),
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
                              allocDetails.amount.toString(),
                              style: TextStyle(
                                color: CustomColors.mfinLightGrey,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ListTile(
                            leading: Text(
                              'Given By:',
                              style: TextStyle(
                                color: CustomColors.mfinGrey,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                              allocDetails.givenBy.toString(),
                              style: TextStyle(
                                color: CustomColors.mfinLightGrey,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ListTile(
                            leading: Text(
                              'Given To:',
                              style: TextStyle(
                                color: CustomColors.mfinGrey,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                              allocDetails.givenTo.toString(),
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
                                      context, "Removing...");
                                  try {
                                    await ChitAllocationController()
                                        .updateAllocationDetails(
                                            widget.chitAlloc.financeID,
                                            widget.chitAlloc.branchName,
                                            widget.chitAlloc.subBranchName,
                                            widget.chitAlloc.chitID,
                                            widget.fund.chitNumber,
                                            false,
                                            false,
                                            allocDetails.toJson());
                                    Navigator.pop(context);
                                    _scaffoldKey.currentState.showSnackBar(
                                        CustomSnackBar.successSnackBar(
                                            "Removed the Allocation successfully",
                                            2));
                                  } catch (err) {
                                    Navigator.pop(context);
                                    _scaffoldKey.currentState.showSnackBar(
                                        CustomSnackBar.errorSnackBar(
                                            "Error, Unable to remove now!", 2));
                                  }
                                },
                                icon: Icon(Icons.remove_circle),
                                label: Text("Remove Allocation"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              Padding(
                padding: EdgeInsets.all(35),
              ),
            ];
          } else {
            children = [
              Text(
                "No Allocations done for this Chit!",
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
            children: <Widget>[
              ListTile(
                leading: Text(
                  'Chit Date:',
                  style: TextStyle(
                    color: CustomColors.mfinBlue,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Text(
                  DateUtils.formatDate(DateTime.fromMillisecondsSinceEpoch(
                      widget.fund.chitDate)),
                  style: TextStyle(
                    color: CustomColors.mfinGrey,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: Text(
                  'Allocation Amount:',
                  style: TextStyle(
                    color: CustomColors.mfinBlue,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Text(
                  'Rs.${widget.fund.allocationAmount}',
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
