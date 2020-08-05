import 'package:flutter/material.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/app/SearchAppBar.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/app/notification_icon.dart';
import 'package:instamfin/screens/app/sideDrawer.dart';
import 'package:instamfin/screens/customer/AddCustomer.dart';
import 'package:instamfin/screens/customer/widgets/AllCustomerTab.dart';
import 'package:instamfin/screens/customer/widgets/CustomerListWidget.dart';
import 'package:instamfin/screens/home/UserFinanceSetup.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/IconButton.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

import '../../app_localizations.dart';

class CustomersHome extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final User _user = UserController().getCurrentUser();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await UserController().refreshUser(false);
        return Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) => UserFinanceSetup(),
          ),
          (Route<dynamic> route) => false,
        );
      },
      child: DefaultTabController(
        length: 4,
        initialIndex: 0,
        child: Scaffold(
          key: _scaffoldKey,
          drawer: openDrawer(context),
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              AppLocalizations.of(context).translate('customers'),
            ),
            backgroundColor: CustomColors.mfinBlue,
            automaticallyImplyLeading: false,
            leading: InkWell(
              onTap: () => _scaffoldKey.currentState.openDrawer(),
              child: Container(
                padding: EdgeInsets.only(left: 5.0),
                child: Icon(
                  Icons.menu,
                  size: 30.0,
                  color: CustomColors.mfinWhite,
                ),
              ),
            ),
            actions: <Widget>[
              customIconButton(
                Icons.search,
                30.0,
                CustomColors.mfinWhite,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchAppBar(),
                      settings: RouteSettings(name: '/Search'),
                    ),
                  );
                },
              ),
              PushNotification(),
            ],
            bottom: TabBar(
              isScrollable: true,
              labelColor: CustomColors.mfinWhite,
              indicatorWeight: 0,
              labelPadding: EdgeInsets.only(left: 10.0, right: 10.0),
              indicator: BoxDecoration(
                color: CustomColors.mfinLightBlue,
                borderRadius: BorderRadius.circular(3),
              ),
              tabs: [
                Tab(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      AppLocalizations.of(context).translate('all_caps'),
                      style: TextStyle(
                        color: CustomColors.mfinWhite,
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      AppLocalizations.of(context).translate('active'),
                      style: TextStyle(
                        color: CustomColors.mfinButtonGreen,
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      AppLocalizations.of(context).translate('pending'),
                      style: TextStyle(
                        color: CustomColors.mfinAlertRed,
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      AppLocalizations.of(context).translate('settled'),
                      style: TextStyle(
                        color: CustomColors.mfinGrey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: CustomColors.mfinAlertRed.withOpacity(0.7),
            tooltip: "Add Customer",
            onPressed: () {
              if (_user.financeSubscription <
                      DateUtils.getUTCDateEpoch(DateTime.now()) &&
                  _user.chitSubscription <
                      DateUtils.getUTCDateEpoch(DateTime.now())) {
                _scaffoldKey.currentState.showSnackBar(
                    CustomSnackBar.errorSnackBar(
                        AppLocalizations.of(context)
                            .translate('subscription_expired'),
                        3));
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddCustomer(),
                  settings: RouteSettings(name: '/customers/add'),
                ),
              );
            },
            elevation: 5.0,
            label: Text("ADD"),
            icon: Icon(
              Icons.add,
              size: 35,
            ),
          ),
          body: TabBarView(
            children: [
              SingleChildScrollView(
                child: CustomerTab('All Customers', 0),
              ),
              SingleChildScrollView(
                child: CustomerTab('Active Customers', 1),
              ),
              SingleChildScrollView(
                child: CustomerListWidget(_scaffoldKey, 'Pending Customers', 2),
              ),
              SingleChildScrollView(
                child: CustomerTab('Settled Customers', 3),
              )
            ],
          ),
          bottomNavigationBar: bottomBar(context),
        ),
      ),
    );
  }
}
