import 'package:flutter/material.dart';
import 'package:instamfin/db/models/customer.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/app/ProfilePictureUpload.dart';
import 'package:instamfin/screens/chit/widgets/CustomerChitWidget.dart';
import 'package:instamfin/screens/customer/ViewCustomerProfile.dart';
import 'package:instamfin/screens/customer/widgets/CustomerPaymentsListWidget.dart';
import 'package:instamfin/screens/home/UserFinanceSetup.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:instamfin/screens/customer/EditCustomer.dart';
import 'package:instamfin/screens/customer/AddPayment.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/url_launcher_utils.dart';
import 'package:instamfin/services/controllers/customer/cust_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_localizations.dart';

class ViewCustomer extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final User _user = UserController().getCurrentUser();

  ViewCustomer(this.customer);

  final Customer customer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: Text(customer.firstName),
          backgroundColor: CustomColors.mfinBlue),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showMaterialModalBottomSheet(
            expand: false,
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context, scrollController) {
              return Material(
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          AppLocalizations.of(context).translate('add_payment'),
                        ),
                        leading: Icon(
                          Icons.monetization_on,
                          color: CustomColors.mfinBlue,
                        ),
                        onTap: () async {
                          SharedPreferences sPref =
                              await SharedPreferences.getInstance();

                          bool pEnabled = sPref.getBool('payment_enabled');
                          if (pEnabled != null && pEnabled == false) {
                            Navigator.pop(context);
                            _scaffoldKey.currentState.showSnackBar(
                                CustomSnackBar.errorSnackBar(
                                    AppLocalizations.of(context)
                                        .translate('payment_disabled'),
                                    3));
                            return;
                          }

                          if (_user.financeSubscription <
                              DateUtils.getUTCDateEpoch(DateTime.now())) {
                            Navigator.pop(context);
                            _scaffoldKey.currentState.showSnackBar(
                                CustomSnackBar.errorSnackBar(
                                    AppLocalizations.of(context)
                                        .translate('sub_expired'),
                                    3));
                            return;
                          }
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddPayment(customer),
                              settings: RouteSettings(
                                  name: '/customers/payments/add'),
                            ),
                          );
                        },
                      ),
                      ListTile(
                          title: Text(
                            "View Customer",
                          ),
                          leading: Icon(
                            Icons.remove_red_eye,
                            color: CustomColors.mfinBlue,
                          ),
                          onTap: () {
                            showMaterialModalBottomSheet(
                                enableDrag: true,
                                isDismissible: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                context: context,
                                builder: (context, scrollController) {
                                  return ViewCustomerProfile(customer);
                                });
                          }),
                      ListTile(
                        title: Text(
                          AppLocalizations.of(context)
                              .translate('edit_customer'),
                        ),
                        leading: Icon(
                          Icons.edit,
                          color: CustomColors.mfinBlue,
                        ),
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditCustomerProfile(customer),
                              settings: RouteSettings(
                                  name: '/customers/profile/edit'),
                            ),
                          );
                        },
                      ),
                      customer.mobileNumber != null
                          ? ListTile(
                              title: Text('Call Customer'),
                              leading: Icon(
                                Icons.phone,
                                color: CustomColors.mfinBlue,
                              ),
                              onTap: () {
                                if (customer.mobileNumber != null) {
                                  UrlLauncherUtils.makePhoneCall(
                                      customer.mobileNumber);
                                } else {
                                  Navigator.pop(context);
                                  _scaffoldKey.currentState.showSnackBar(
                                    CustomSnackBar.errorSnackBar(
                                        "Customer doesn't have valid mobile number!",
                                        3),
                                  );
                                }
                              },
                            )
                          : Container(),
                      customer.mobileNumber != null
                          ? ListTile(
                              title: Text('Text Customer'),
                              leading: Icon(
                                Icons.textsms,
                                color: CustomColors.mfinBlue,
                              ),
                              onTap: () {
                                if (customer.mobileNumber != null) {
                                  UrlLauncherUtils.makeSMS(
                                      customer.mobileNumber);
                                } else {
                                  Navigator.pop(context);
                                  _scaffoldKey.currentState.showSnackBar(
                                    CustomSnackBar.errorSnackBar(
                                        "Customer doesn't have valid mobile number!",
                                        3),
                                  );
                                }
                              },
                            )
                          : Container(),
                      ListTile(
                          title: Text(
                            AppLocalizations.of(context)
                                .translate('delete_customer'),
                          ),
                          leading: Icon(
                            Icons.delete_forever,
                            color: CustomColors.mfinAlertRed,
                          ),
                          onTap: () async {
                            CustomDialogs.confirm(
                              context,
                              AppLocalizations.of(context).translate('confirm'),
                              "${AppLocalizations.of(context).translate('are_you_sure')} ${customer.firstName} ${customer.lastName} ${AppLocalizations.of(context).translate('customer')}?",
                              () async {
                                Navigator.pop(context);
                                CustomDialogs.actionWaiting(
                                    context, "Removing..");
                                CustController _cc = CustController();
                                var result =
                                    await _cc.removeCustomer(customer.id);
                                if (result == null) {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  _scaffoldKey.currentState.showSnackBar(
                                      CustomSnackBar.errorSnackBar(
                                          AppLocalizations.of(context)
                                              .translate('remove_payment'),
                                          3));
                                } else {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }
                              },
                              () {
                                Navigator.pop(context);
                              },
                            );
                          }),
                      ListTile(
                        title: Text(
                            AppLocalizations.of(context).translate('home')),
                        leading: Icon(
                          Icons.home,
                          color: CustomColors.mfinBlue,
                        ),
                        onTap: () async {
                          await UserController().refreshUser(false);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserFinanceSetup(),
                              settings: RouteSettings(name: '/home'),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
        backgroundColor: CustomColors.mfinBlue,
        splashColor: CustomColors.mfinWhite,
        child: Icon(
          Icons.navigation,
          size: 30,
          color: CustomColors.mfinButtonGreen,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: customer.getProfilePicPath() == ""
                    ? Container(
                        width: 80,
                        height: 80,
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: CustomColors.mfinFadedButtonGreen,
                            style: BorderStyle.solid,
                            width: 2.0,
                          ),
                        ),
                        child: FlatButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              routeSettings:
                                  RouteSettings(name: "/profile/upload"),
                              builder: (context) {
                                return Center(
                                  child: ProfilePictureUpload(
                                      1,
                                      customer.getProfilePicPath(),
                                      customer.financeID +
                                          '_' +
                                          customer.id.toString(),
                                      customer.id),
                                );
                              },
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(2),
                                child: Icon(
                                  Icons.person,
                                  size: 40.0,
                                  color: CustomColors.mfinBlue,
                                ),
                              ),
                              Text(
                                'UPLOAD',
                                style: TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontSize: 10.0,
                                  color: CustomColors.mfinBlue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        margin: EdgeInsets.all(5),
                        child: Stack(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 45.0,
                              backgroundImage:
                                  NetworkImage(customer.getProfilePicPath()),
                              backgroundColor: Colors.transparent,
                            ),
                            Positioned(
                              bottom: -5,
                              left: 30,
                              child: FlatButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    routeSettings:
                                        RouteSettings(name: "/profile/upload"),
                                    builder: (context) {
                                      return Center(
                                        child: ProfilePictureUpload(
                                            1,
                                            customer.getProfilePicPath(),
                                            customer.financeID +
                                                '_' +
                                                customer.id.toString(),
                                            customer.id),
                                      );
                                    },
                                  );
                                },
                                child: CircleAvatar(
                                  backgroundColor: CustomColors.mfinButtonGreen,
                                  radius: 15,
                                  child: Icon(
                                    Icons.edit,
                                    color: CustomColors.mfinBlue,
                                    size: 20.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              Text(
                '${customer.firstName} ${customer.lastName}',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: CustomColors.mfinButtonGreen,
                ),
              ),
              customer.mobileNumber != null
                  ? Text(
                      customer.mobileNumber != null
                          ? customer.mobileNumber.toString()
                          : "",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mfinBlue,
                      ),
                    )
                  : Text(
                      customer.address.street != null
                          ? customer.address.street
                          : "",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 12.0,
                          color: CustomColors.mfinAlertRed.withOpacity(0.5),
                          fontWeight: FontWeight.bold),
                    ),
              customer.mobileNumber != null
                  ? Text(
                      customer.address.street != null
                          ? customer.address.street
                          : "",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 12.0,
                          color: CustomColors.mfinAlertRed.withOpacity(0.5),
                          fontWeight: FontWeight.bold),
                    )
                  : Container(),
              CustomerPaymentsListWidget(customer.id, _scaffoldKey),
              if (_user.accPreferences.chitEnabled)
                CustomerChitsWidget(customer.mobileNumber),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 40, 0, 40),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
