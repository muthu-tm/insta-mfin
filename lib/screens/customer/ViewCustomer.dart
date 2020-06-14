import 'package:flutter/material.dart';
import 'package:instamfin/db/models/customer.dart';
import 'package:instamfin/screens/customer/ViewCustomerProfile.dart';
import 'package:instamfin/screens/home/Home.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:instamfin/screens/customer/EditCustomer.dart';
import 'package:instamfin/screens/customer/widgets/CustomerPaymentsWidget.dart';
import 'package:instamfin/screens/customer/AddPayment.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/url_launcher_utils.dart';
import 'package:instamfin/services/controllers/customer/cust_controller.dart';

class ViewCustomer extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ViewCustomer(this.customer);

  final Customer customer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(customer.name),
        backgroundColor: CustomColors.mfinBlue,
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
                        onTap: () {
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
                                  borderRadius:  BorderRadius.circular(8.0),
                                ),
                                context: context,
                                builder: (context, scrollController) {
                                  return ViewCustomerProfile(customer);
                                });
                          }
                      ),
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
                                  EditCustomerProfile(customer.toJson()),
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
                                  print("Customer removed successfully");
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
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserHomeScreen(),
                            settings: RouteSettings(name: '/home'),
                          ),
                        ),
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
              CustomerPaymentsWidget(
                  customer.mobileNumber, customer.name, _scaffoldKey),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 40, 0, 40),
              ),
            ],
          ),
        ),
      ),
      //bottomNavigationBar: bottomBar(context),
    );
  }
}
