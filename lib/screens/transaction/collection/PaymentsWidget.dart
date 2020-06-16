import 'package:flutter/material.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/screens/customer/ViewPayment.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/date_utils.dart';

class PaymentsWidget extends StatelessWidget {
  PaymentsWidget(this.textColor, this.payments, this.cardColor);

  final Color textColor;
  final List<Payment> payments;
  final Color cardColor;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: payments.length,
      shrinkWrap: true,
      primary: false,
      itemBuilder: (BuildContext context, int index) {
        Payment pay = payments[index];
        return Padding(
          padding: EdgeInsets.only(
            left: 2.0,
            top: 5,
            right: 2.0,
            bottom: 5,
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewPayment(pay),
                  settings: RouteSettings(name: '/customers/payment'),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Material(
                  color: cardColor,
                  elevation: 10.0,
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: 120,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Spacer(
                          flex: 3,
                        ),
                        SizedBox(
                          height: 30,
                          child: Text(
                            DateUtils.getFormattedDateFromEpoch(
                                pay.dateOfPayment),
                            style: TextStyle(
                                color: textColor,
                                fontFamily: 'Georgia',
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        new Divider(
                          color: CustomColors.mfinButtonGreen,
                        ),
                        Spacer(
                          flex: 1,
                        ),
                        SizedBox(
                          height: 30,
                          child: Text(
                            pay.totalAmount.toString(),
                            style: TextStyle(
                                color: CustomColors.mfinAlertRed,
                                fontFamily: 'Georgia',
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Spacer(
                          flex: 1,
                        ),
                        SizedBox(
                          height: 30,
                          child: RichText(
                            text: TextSpan(
                              text: '${pay.tenure}',
                              style: TextStyle(
                                color: textColor,
                                fontFamily: 'Georgia',
                                fontSize: 18.0,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: ' x ',
                                  style: TextStyle(
                                    color: CustomColors.mfinBlack,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: '${pay.collectionAmount}',
                                  style: TextStyle(
                                    color: CustomColors.mfinFadedButtonGreen,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Spacer(
                          flex: 1,
                        ),
                      ],
                    ),
                  ),
                ),
                getPaymentsDetails(pay),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget getPaymentsDetails(Payment payment) {
    return FutureBuilder(
      future: payment.getAmountDetails(),
      builder: (BuildContext context, AsyncSnapshot<List<int>> paidSnap) {
        Widget child;

        if (paidSnap.hasData) {
          if (paidSnap.data.length > 0) {
            child = Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 30,
                  child: ListTile(
                    leading: Text(
                      "PAID",
                      style: TextStyle(
                        fontSize: 18,
                        color: CustomColors.mfinBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Text(
                      paidSnap.data[0].toString(),
                      style: TextStyle(
                        fontSize: 17,
                        color: CustomColors.mfinPositiveGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                  child: ListTile(
                    leading: Text(
                      'PENDING',
                      style: TextStyle(
                        fontSize: 17,
                        color: CustomColors.mfinBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Text(
                      '${paidSnap.data[1]}',
                      style: TextStyle(
                        fontSize: 17,
                        color: CustomColors.mfinAlertRed,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                  child: ListTile(
                    leading: Text(
                      'UPCOMING',
                      style: TextStyle(
                        fontSize: 17,
                        color: CustomColors.mfinBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Text(
                      '${paidSnap.data[3]}',
                      style: TextStyle(
                        fontSize: 17,
                        color: CustomColors.mfinGrey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        } else if (paidSnap.hasError) {
          child = Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: AsyncWidgets.asyncError());
        } else {
          child = Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: AsyncWidgets.asyncWaiting());
        }

        return Material(
          color: CustomColors.mfinLightGrey,
          elevation: 10.0,
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
              width: MediaQuery.of(context).size.width * 0.55,
              height: 120,
              child: child),
        );
      },
    );
  }
}
