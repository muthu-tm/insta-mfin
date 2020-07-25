import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/db/models/customer.dart';
import 'package:instamfin/screens/customer/EditCustomer.dart';
import 'package:instamfin/screens/customer/widgets/CustomerListTile.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/url_launcher_utils.dart';
import 'package:instamfin/services/controllers/customer/cust_controller.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CustomerTab extends StatefulWidget {
  CustomerTab(this.title, this.status);

  final String title;
  final int status;

  @override
  _CustomerTabState createState() => _CustomerTabState();
}

class _CustomerTabState extends State<CustomerTab> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int ascByName = 0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.status != 0
          ? Customer().streamCustomersByStatus(widget.status, ascByName)
          : Customer().streamAllCustomers(ascByName),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          if (snapshot.data.documents.isNotEmpty) {
            children = <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: RaisedButton.icon(
                      color: CustomColors.mfinWhite,
                      icon: Icon(
                        ascByName == 1
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: ascByName == 1
                            ? CustomColors.mfinBlue
                            : CustomColors.mfinGrey,
                        size: 25,
                      ),
                      label: Text(
                        ascByName == 0
                            ? "Created At"
                            : ascByName == 1 ? "Name Asc" : "Name Desc",
                        style: TextStyle(
                            color: ascByName == 1
                                ? CustomColors.mfinBlue
                                : CustomColors.mfinGrey,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        setState(() {
                          if (ascByName == 1)
                            ascByName = 2;
                          else
                            ascByName = 1;
                        });
                      }),
                ),
              ),
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  Customer cust =
                      Customer.fromJson(snapshot.data.documents[index].data);

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
                        onTap: () {
                          if (cust.mobileNumber != null) {
                            UrlLauncherUtils.makePhoneCall(cust.mobileNumber);
                          } else {
                            _scaffoldKey.currentState.showSnackBar(
                              CustomSnackBar.errorSnackBar(
                                  "Customer doesn't have valid mobile number!",
                                  3),
                            );
                          }
                        },
                      ),
                      IconSlideAction(
                        caption: 'Message',
                        color: CustomColors.mfinGrey,
                        icon: Icons.message,
                        onTap: () {
                          if (cust.mobileNumber != null) {
                            UrlLauncherUtils.makeSMS(cust.mobileNumber);
                          } else {
                            _scaffoldKey.currentState.showSnackBar(
                              CustomSnackBar.errorSnackBar(
                                  "Customer doesn't have valid mobile number!",
                                  3),
                            );
                          }
                        },
                      ),
                    ],
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: 'Edit',
                        color: CustomColors.mfinBlue,
                        icon: Icons.edit,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditCustomerProfile(cust),
                            settings:
                                RouteSettings(name: '/customers/profile/edit'),
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
                                    'Are you sure to remove ${cust.firstName} ${cust.lastName} Customer?'),
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
                                      CustController _cc = CustController();
                                      var result =
                                          await _cc.removeCustomer(cust.id);
                                      if (result == null) {
                                        Navigator.pop(context);
                                        _scaffoldKey.currentState.showSnackBar(
                                          CustomSnackBar.errorSnackBar(
                                            "There are few Payments available for this Customer. Please remove the Payments first!",
                                            3,
                                          ),
                                        );
                                      } else {
                                        Navigator.pop(context);
                                        _scaffoldKey.currentState.showSnackBar(
                                          CustomSnackBar.successSnackBar(
                                              "Customer removed successfully",
                                              2),
                                        );
                                      }
                                    },
                                  ),
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
                    child: customerListTile(context, index, cust),
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

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: children,
          ),
        );
      },
    );
  }
}
