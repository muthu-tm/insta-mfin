import 'package:flutter/material.dart';
import 'package:instamfin/db/models/customer.dart';
import 'package:instamfin/screens/customer/widgets/CustomerListTile.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/date_utils.dart';

class CustomerBookListWidget extends StatelessWidget {
  CustomerBookListWidget(this.isRange, this.startDate, this.endDate);

  final bool isRange;
  final DateTime startDate;
  final DateTime endDate;

  final Customer _cust = Customer();
  @override
  Widget build(BuildContext context) {

    return FutureBuilder<List<Customer>>(
      future: isRange
          ? _cust.getAllByDateRange(
              DateUtils.getUTCDateEpoch(startDate),
              DateUtils.getUTCDateEpoch(endDate))
          : _cust.getAllByDate(DateUtils.getUTCDateEpoch(startDate)),
      builder: (BuildContext context, AsyncSnapshot<List<Customer>> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          if (snapshot.data.isNotEmpty) {
            children = <Widget>[
              ListView.builder(
                itemCount: snapshot.data.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, index) {
                  return customerListTile(context, index, snapshot.data[index]);
                },
              ),
            ];
          } else {
            // No Payments available
            children = [
              Container(
                height: 90,
                child: Column(
                  children: <Widget>[
                    new Spacer(),
                    Text(
                      "No Customers Found!",
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
                      "Check for different Date!",
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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            ),
          ),
        );
      },
    );
  }
}
