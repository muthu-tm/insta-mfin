import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/db/models/customer.dart';
import 'package:instamfin/screens/customer/EditCustomer.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/IconButton.dart';
import 'package:instamfin/services/controllers/customer/cust_controller.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:flutter_slidable/flutter_slidable.dart';

class CustomerListWidget extends StatelessWidget {
  CustomerListWidget(this._scaffoldKey, this.title,
      [this.userStatus = 0, this.fetchAll = true]);
  final Customer _cust = Customer();

  final int userStatus;
  final bool fetchAll;
  final String title;
  final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _cust.getCustomerByStatus(userStatus, fetchAll),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          if (snapshot.data.documents.isNotEmpty) {
            children = <Widget>[
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  return Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.20,
                    closeOnScroll: true,
                    direction: Axis.horizontal,
                    actions: <Widget>[
                      IconSlideAction(
                        caption: 'Phone',
                        color: CustomColors.mfinPositiveGreen,
                        icon: Icons.call,
                        onTap: () => _makePhoneCall(snapshot
                            .data.documents[index].data['mobile_number']),
                      ),
                      IconSlideAction(
                        caption: 'Message',
                        color: CustomColors.mfinGrey,
                        icon: Icons.message,
                        onTap: () => _makeSMS(snapshot
                            .data.documents[index].data['mobile_number']),
                      ),
                    ],
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: 'Edit',
                        color: CustomColors.mfinPositiveGreen,
                        icon: Icons.edit,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditCustomerProfile(
                                snapshot.data.documents[index].data),
                          ),
                        ),
                      ),
                      IconSlideAction(
                        caption: 'Remove',
                        color: CustomColors.mfinAlertRed,
                        icon: Icons.delete_forever,
                        onTap: () async {
                          var state = Slidable.of(context);
                          var dismiss = await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: new Text(
                                  "Confirm!",
                                  style: TextStyle(
                                      color: CustomColors.mfinAlertRed,
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.start,
                                ),
                                content: Text(
                                    'Are you sure to remove ${snapshot.data.documents[index].data['customer_name']} Customer?'),
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
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _removeCustomer(
                                            snapshot.data.documents[index]
                                                .data['mobile_number']);
                                      }),
                                ],
                              );
                            },
                          );

                          if (dismiss != null && dismiss && state != null) {
                            state.dismiss();
                          }
                        },
                      ),
                    ],
                    child: Container(
                      color: CustomColors.mfinWhite,
                      height: 75,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          ListTile(
                            leading: Text(
                              snapshot
                                  .data.documents[index].data['customer_name'],
                              style: TextStyle(
                                color: CustomColors.mfinBlue,
                                fontSize: 18,
                              ),
                            ),
                            trailing: Text(
                              snapshot
                                  .data.documents[index].data['mobile_number']
                                  .toString(),
                              style: TextStyle(
                                color: CustomColors.mfinBlue,
                                fontSize: 18,
                              ),
                            ),
                            onTap: () {},
                          ),
                          new Divider(
                            thickness: 2,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ];
          } else {
            // No cistomers available
            children = [
              Container(
                height: 90,
                child: Column(
                  children: <Widget>[
                    new Spacer(),
                    Text(
                      "No Customers!",
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
                      "Search for different type!",
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
                leading: Icon(
                  Icons.supervisor_account,
                  size: 35.0,
                  color: CustomColors.mfinButtonGreen,
                ),
                title: new Text(
                  title,
                  style: TextStyle(
                    color: CustomColors.mfinBlue,
                    fontSize: 18.0,
                  ),
                ),
                trailing: RaisedButton.icon(
                  color: CustomColors.mfinLightGrey,
                  highlightColor: CustomColors.mfinLightGrey,
                  onPressed: null,
                  icon: customIconButton(
                    Icons.swap_vert,
                    35.0,
                    CustomColors.mfinBlue,
                    null,
                  ),
                  label: Text(
                    "Sort by",
                    style: TextStyle(
                      fontSize: 18,
                      color: CustomColors.mfinBlue,
                    ),
                  ),
                ),
              ),
              new Divider(
                color: CustomColors.mfinBlue,
                thickness: 1,
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

  Future<void> _makePhoneCall(int mobileNumber) async {
    String callURL = 'tel:+91$mobileNumber';
    if (await UrlLauncher.canLaunch(callURL)) {
      await UrlLauncher.launch(callURL);
    } else {
      throw 'Could not make Phone to $mobileNumber';
    }
  }

  Future<void> _makeSMS(int mobileNumber) async {
    String callURL = 'sms:+91$mobileNumber';
    if (await UrlLauncher.canLaunch(callURL)) {
      await UrlLauncher.launch(callURL);
    } else {
      throw 'Could not send SMS to $mobileNumber';
    }
  }

  _removeCustomer(int mobileNumber) async {
    // CustomDialogs.actionWaiting(context, "Removing Customer");
    CustController _cc = CustController();
    var result = await _cc.removeCustomer(mobileNumber, false);
    if (result == null) {
      // Navigator.pop(context);
      _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
          "There are few Payments available for this Customer. Please remove the Payments first!",
          3));
    } else {
      // Navigator.pop(context);
      _scaffoldKey.currentState.showSnackBar(
          CustomSnackBar.errorSnackBar("Customer removed successfully", 2));
    }
  }
}
