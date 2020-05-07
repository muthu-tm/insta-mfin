import 'package:flutter/material.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/customer/EditCustomer.dart';
import 'package:instamfin/screens/customer/ViewCustomerProfile.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/url_launcher_utils.dart';
import 'package:instamfin/services/controllers/customer/cust_controller.dart';

class ViewCustomer extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  ViewCustomer(this.customer);

  final Map<String, dynamic> customer;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(customer['customer_name']),
        backgroundColor: CustomColors.mfinBlue,
      ),
      body: SingleChildScrollView(
        child: new Container(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(
                        Icons.account_box,
                        size: 45.0,
                        color: CustomColors.mfinButtonGreen,
                      ),
                      title: Text(
                        customer['customer_name'],
                        style: TextStyle(
                          fontSize: 18,
                          color: CustomColors.mfinBlue,
                        ),
                      ),
                      trailing: Text(
                        customer['mobile_number'].toString(),
                        style: TextStyle(
                          fontSize: 18,
                          color: CustomColors.mfinBlue,
                        ),
                      ),
                    ),
                    new Divider(
                      indent: 20,
                      endIndent: 20,
                      color: CustomColors.mfinBlue,
                      thickness: 1,
                    ),
                    Row(
                      children: <Widget>[
                        new Spacer(
                          flex: 2,
                        ),
                        InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ViewCustomerProfile(customer),
                            ),
                          ),
                          child: Container(
                            color: CustomColors.mfinButtonGreen,
                            width: MediaQuery.of(context).size.width * 0.18,
                            height: 60,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.contacts,
                                  size: 25.0,
                                  color: CustomColors.mfinBlack,
                                ),
                                Text(
                                  "View",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: CustomColors.mfinBlack,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditCustomerProfile(customer),
                            ),
                          ),
                          child: Container(
                            color: CustomColors.mfinBlue,
                            width: MediaQuery.of(context).size.width * 0.18,
                            height: 60,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.edit,
                                  size: 25.0,
                                  color: CustomColors.mfinLightGrey,
                                ),
                                Text(
                                  "Edit",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: CustomColors.mfinLightGrey,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            CustomDialogs.confirm(
                              context,
                              "Confirm",
                              "Are you sure to remove ${customer['customer_name']} Customer?",
                              () async {
                                Navigator.pop(context);
                                CustomDialogs.actionWaiting(
                                    context, "Removing Customer");
                                CustController _cc = CustController();
                                var result = await _cc.removeCustomer(
                                    customer['mobile_number'], false);
                                if (result == null) {
                                  Navigator.pop(context);
                                  _scaffoldKey.currentState.showSnackBar(
                                      CustomSnackBar.errorSnackBar(
                                          "There are few Payments available for this Customer. Please remove the Payments first!",
                                          3));
                                } else {
                                  Navigator.pop(context);
                                  print("Customer removed successfully");
                                  Navigator.pop(context);
                                }
                              },
                              () {
                                Navigator.pop(context);
                              },
                            );
                          },
                          child: Container(
                            color: CustomColors.mfinAlertRed,
                            width: MediaQuery.of(context).size.width * 0.18,
                            height: 60,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.delete_forever,
                                  size: 25.0,
                                  color: CustomColors.mfinLightGrey,
                                ),
                                Text(
                                  "Remove",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: CustomColors.mfinLightGrey,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => UrlLauncherUtils.makePhoneCall(
                              customer['mobile_number']),
                          child: Container(
                            color: CustomColors.mfinPositiveGreen,
                            width: MediaQuery.of(context).size.width * 0.18,
                            height: 60,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.phone,
                                  size: 25.0,
                                  color: CustomColors.mfinLightGrey,
                                ),
                                Text(
                                  "Phone",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: CustomColors.mfinLightGrey,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => UrlLauncherUtils.makeSMS(
                              customer['mobile_number']),
                          child: Container(
                            color: CustomColors.mfinGrey,
                            width: MediaQuery.of(context).size.width * 0.18,
                            height: 60,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.message,
                                  size: 25.0,
                                  color: CustomColors.mfinBlack,
                                ),
                                Text(
                                  "Text",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: CustomColors.mfinBlack,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        new Spacer(
                          flex: 2,
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomBar(context),
    );
  }
}
