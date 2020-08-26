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

import '../../../app_localizations.dart';

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
                  Customer _cust = snapshot.data[index];

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
                          if (_cust.mobileNumber != null) {
                            UrlLauncherUtils.makePhoneCall(_cust.mobileNumber);
                          } else {
                            _scaffoldKey.currentState.showSnackBar(
                              CustomSnackBar.errorSnackBar(
                                  AppLocalizations.of(context)
                                      .translate('customer_invalid_number'),
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
                          if (_cust.mobileNumber != null) {
                            UrlLauncherUtils.makeSMS(_cust.mobileNumber);
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
                            builder: (context) => EditCustomerProfile(_cust),
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
                                  AppLocalizations.of(context)
                                      .translate('confirm'),
                                  style: TextStyle(
                                      color: CustomColors.mfinAlertRed,
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.start,
                                ),
                                content: Text(
                                    '${AppLocalizations.of(context).translate('are_you_sure')} ${snapshot.data[index].firstName} ${snapshot.data[index].lastName} ${AppLocalizations.of(context).translate('customer')}'),
                                actions: <Widget>[
                                  FlatButton(
                                    color: CustomColors.mfinButtonGreen,
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .translate('no'),
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
                                      AppLocalizations.of(context)
                                          .translate('yes'),
                                      style: TextStyle(
                                          color: CustomColors.mfinLightGrey,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.start,
                                    ),
                                    onPressed: () async {
                                      CustController _cc = CustController();
                                      var result =
                                          await _cc.removeCustomer(_cust.id);
                                      if (result == null) {
                                        Navigator.pop(context);
                                        _scaffoldKey.currentState.showSnackBar(
                                          CustomSnackBar.errorSnackBar(
                                            AppLocalizations.of(context)
                                                .translate('remove_payment'),
                                            3,
                                          ),
                                        );
                                      } else {
                                        Navigator.pop(context);
                                        _scaffoldKey.currentState.showSnackBar(
                                          CustomSnackBar.errorSnackBar(
                                              AppLocalizations.of(context)
                                                  .translate(
                                                      'customer_removed'),
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
                    child: customerListTile(context, index, _cust),
                  );
                },
              ),
            ];
          } else {
            // No customers available
            children = [
              Container(
                height: 90,
                child: Column(
                  children: <Widget>[
                    Spacer(),
                    Text(
                      AppLocalizations.of(context).translate('no_customers'),
                      style: TextStyle(
                        color: CustomColors.mfinAlertRed,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(
                      flex: 2,
                    ),
                    Text(
                      AppLocalizations.of(context).translate('search_type'),
                      style: TextStyle(
                        color: CustomColors.mfinBlue,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Spacer(),
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
