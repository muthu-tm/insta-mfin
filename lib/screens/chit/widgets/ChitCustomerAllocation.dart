import 'package:flutter/material.dart';
import 'package:instamfin/db/models/chit_allocations.dart';
import 'package:instamfin/db/models/chit_fund.dart';
import 'package:instamfin/db/models/chit_fund_details.dart';
import 'package:instamfin/screens/chit/AddChitAllocation.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/services/controllers/chit/chit_allocation_controller.dart';

import '../../../app_localizations.dart';

Widget chitCustomerAllocationDialog(
    BuildContext context,
    GlobalKey<ScaffoldState> _scaffoldKey,
    ChitFund chit,
    ChitFundDetails fund,
    Map<int, int> allocMap) {
  return SingleChildScrollView(
    child: Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              AppLocalizations.of(context).translate('customer_list'),
              style: TextStyle(
                fontSize: 16.0,
                color: CustomColors.mfinBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(
              color: CustomColors.mfinButtonGreen,
            ),
            chit.customerDetails.length > 0
                ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    itemCount: chit.customerDetails.length,
                    itemBuilder: (BuildContext context, int index) {
                      int availableChits = 0;

                      allocMap.containsKey(chit.customerDetails[index].number)
                          ? availableChits = chit.customerDetails[index].chits -
                              allocMap[chit.customerDetails[index].number]
                          : availableChits = chit.customerDetails[index].chits;

                      return Padding(
                        padding: EdgeInsets.all(5),
                        child: Container(
                          color: CustomColors.mfinLightGrey,
                          child: ListTile(
                            leading: Text(
                              chit.customerDetails[index].number.toString(),
                              style: TextStyle(
                                fontSize: 16.0,
                                color: CustomColors.mfinButtonGreen,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            title: Text(
                              availableChits.toString(),
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                              if (availableChits <= 0) {
                                _scaffoldKey.currentState.showSnackBar(
                                  CustomSnackBar.errorSnackBar(
                                      "Already allocated all chits to this customer",
                                      2),
                                );
                                return;
                              }
                              CustomDialogs.confirm(context, "Confirm",
                                  "Are you sure to allocate to ${chit.customerDetails[index].number}",
                                  () async {
                                var result = await ChitAllocationController()
                                    .create(
                                        chit,
                                        fund,
                                        chit.customerDetails[index].number,
                                        false,
                                        "");
                                if (!result['is_success']) {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  _scaffoldKey.currentState.showSnackBar(
                                      CustomSnackBar.errorSnackBar(
                                          result['message'], 2));
                                } else {
                                  ChitAllocations chitAlloc = result['message'];
                                  Navigator.pop(context);

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AddChitAllocation(chitAlloc, fund),
                                      settings: RouteSettings(
                                          name: '/chit/publish/new'),
                                    ),
                                  );
                                }
                              }, () {
                                Navigator.pop(context);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  )
                : Container(
                    child: Text(
                      AppLocalizations.of(context).translate('no_customers'),
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mfinAlertRed,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    ),
  );
}
