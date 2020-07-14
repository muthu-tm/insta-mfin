import 'package:flutter/material.dart';
import 'package:instamfin/db/models/customer.dart';
import 'package:instamfin/screens/app/ProfilePictureUpload.dart';
import 'package:instamfin/screens/customer/ViewCustomerProfile.dart';
import 'package:instamfin/screens/customer/widgets/CustomerPaymentsListWidget.dart';
import 'package:instamfin/screens/home/UserFinanceSetup.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:instamfin/services/pdf/cust_report.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:instamfin/screens/customer/EditCustomer.dart';
import 'package:instamfin/screens/customer/AddPayment.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/url_launcher_utils.dart';
import 'package:instamfin/services/controllers/customer/cust_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewCustomer extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ViewCustomer(this.customer);

  final Customer customer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(customer.name),
        backgroundColor: CustomColors.mfinBlue,
        actions: <Widget>[
          IconButton(
            tooltip: "Generate Customer Report",
            icon: Icon(
              Icons.description,
              size: 30,
              color: CustomColors.mfinLightGrey,
            ),
            onPressed: () async {
              _scaffoldKey.currentState.showSnackBar(
                  CustomSnackBar.successSnackBar(
                      "Generating your Customers Report! Please wait...", 5));
              await CustReport()
                  .generateReport(UserController().getCurrentUser(), customer);
            },
          )
        ],
      ),
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
                        title: Text('Add Payment'),
                        leading: Icon(
                          Icons.monetization_on,
                          color: CustomColors.mfinBlue,
                        ),
                        onTap: () async {
                          SharedPreferences sPref =
                              await SharedPreferences.getInstance();

                          bool pEnabled = sPref.getBool('payment_enabled');
                          if (pEnabled != null && pEnabled == false) {
                            _scaffoldKey.currentState.showSnackBar(
                                CustomSnackBar.errorSnackBar(
                                    "ADD Payment disabled for sometime! Please contact support for more info. Thanks for your support!",
                                    3));
                            return;
                          }
                          Navigator.push(
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
                          title: Text('View Customer'),
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
                        title: Text('Edit Customer'),
                        leading: Icon(
                          Icons.edit,
                          color: CustomColors.mfinBlue,
                        ),
                        onTap: () {
                          Navigator.push(
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
                      ListTile(
                        title: Text('Call Customer'),
                        leading: Icon(
                          Icons.phone,
                          color: CustomColors.mfinBlue,
                        ),
                        onTap: () => UrlLauncherUtils.makePhoneCall(
                            customer.mobileNumber),
                      ),
                      ListTile(
                        title: Text('Text Customer'),
                        leading: Icon(
                          Icons.textsms,
                          color: CustomColors.mfinBlue,
                        ),
                        onTap: () =>
                            UrlLauncherUtils.makeSMS(customer.mobileNumber),
                      ),
                      ListTile(
                          title: Text('Delete Customer'),
                          leading: Icon(
                            Icons.delete_forever,
                            color: CustomColors.mfinAlertRed,
                          ),
                          onTap: () async {
                            CustomDialogs.confirm(
                              context,
                              "Confirm",
                              "Are you sure to remove ${customer.name} Customer?",
                              () async {
                                Navigator.pop(context);
                                CustomDialogs.actionWaiting(
                                    context, "Removing Customer");
                                CustController _cc = CustController();
                                var result = await _cc.removeCustomer(
                                    customer.mobileNumber, false);
                                if (result == null) {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  _scaffoldKey.currentState.showSnackBar(
                                      CustomSnackBar.errorSnackBar(
                                          "There are few Payments available for this Customer. Please remove the Payments first!",
                                          3));
                                } else {
                                  // ! Once customer deleted; need to route user to list page
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
                        title: Text('Home'),
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
                ));
              });
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
                                          customer.mobileNumber.toString(),
                                      customer.mobileNumber),
                                );
                              },
                            );
                          },
                          child: Stack(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topCenter,
                                child: Icon(
                                  Icons.person,
                                  size: 40.0,
                                  color: CustomColors.mfinBlue,
                                ),
                              ),
                              Positioned(
                                bottom: 15,
                                left: 3,
                                child: Text(
                                  "Upload",
                                  style: TextStyle(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w500,
                                    color: CustomColors.mfinBlue,
                                  ),
                                ),
                              )
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
                                                customer.mobileNumber
                                                    .toString(),
                                            customer.mobileNumber),
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
                customer.name,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: CustomColors.mfinButtonGreen,
                ),
              ),
              Text(
                customer.mobileNumber.toString(),
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: CustomColors.mfinBlue,
                ),
              ),
              CustomerPaymentsListWidget(customer.mobileNumber, _scaffoldKey),
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
