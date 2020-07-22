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

class CustomerListWidget extends StatelessWidget {
  CustomerListWidget(this._scaffoldKey, this.title, this.userStatus);

  final int userStatus;
  final String title;
  final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Customer>>(
      stream: CustController().streamPendingCustomers(),
      builder: (BuildContext context, AsyncSnapshot<List<Customer>> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          if (snapshot.data.isNotEmpty) {
            children = <Widget>[
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                itemCount: snapshot.data.length,
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
                        onTap: () {
                          if (snapshot.data[index].mobileNumber != null) {
                            UrlLauncherUtils.makePhoneCall(
                                snapshot.data[index].mobileNumber);
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
                            if (snapshot.data[index].mobileNumber != null) {
                              UrlLauncherUtils.makeSMS(
                                  snapshot.data[index].mobileNumber);
                            } else {
                              _scaffoldKey.currentState.showSnackBar(
                                CustomSnackBar.errorSnackBar(
                                    "Customer doesn't have valid mobile number!",
                                    3),
                              );
                            }
                          }),
                    ],
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: 'Edit',
                        color: CustomColors.mfinBlue,
                        icon: Icons.edit,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditCustomerProfile(snapshot.data[index]),
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
                                    'Are you sure to remove ${snapshot.data[index].firstName} ${snapshot.data[index].lastName} Customer?'),
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
                                      var result = await _cc.removeCustomer(
                                          snapshot.data[index].id);
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
                                        print("Customer removed successfully");
                                        _scaffoldKey.currentState.showSnackBar(
                                          CustomSnackBar.errorSnackBar(
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
                    child:
                        customerListTile(context, index, snapshot.data[index]),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
        );
      },
    );
  }
}
