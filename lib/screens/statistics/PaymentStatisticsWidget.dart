import 'package:flutter/material.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../app_localizations.dart';

class PaymentStatisticsWidget extends StatelessWidget {
  PaymentStatisticsWidget(this.type, this.mode, [this.fDate, this.tDate]);

  final int type;
  final int mode;
  final DateTime fDate;
  final DateTime tDate;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      child: FutureBuilder<List<Payment>>(
        future: Payment().getAllPaymentsByDateRange(
            DateUtils.getUTCDateEpoch(fDate), DateUtils.getUTCDateEpoch(tDate)),
        builder: (context, snapshot) {
          Widget widget;

          if (snapshot.hasData) {
            if (snapshot.data.isNotEmpty) {
              int max = 0;
              int interval = 50;
              List<PayData> pData = [];
              Map<DateTime, PayData> pGroup = new Map();
              Map<String, int> aDetails = new Map();
              DateFormat formatter = DateFormat('MMM-yyyy');
              if (mode == 0) formatter = DateFormat('dd-MMM-yyyy');

              snapshot.data.forEach((p) {
                DateTime _dt =
                    DateTime.fromMillisecondsSinceEpoch(p.dateOfPayment);
                pGroup.update(_dt, (value) {
                  return PayData(_dt, value.amount + p.totalAmount);
                }, ifAbsent: () {
                  return PayData(_dt, p.totalAmount);
                });

                String format = formatter.format(_dt);
                aDetails.update(format, (value) => p.totalAmount + value,
                    ifAbsent: () => p.totalAmount);
              });

              pGroup.forEach((key, value) {
                if (value.amount > max) {
                  interval = (value.amount / 5).round();
                  max = value.amount + ((1000 < interval) ? 1000 : 100);
                }

                pData.add(value);
              });

              widget = Column(
                children: <Widget>[
                  Container(
                    child: SfCartesianChart(
                      title: ChartTitle(
                        text:
                            AppLocalizations.of(context).translate('payments'),
                        textStyle: TextStyle(
                          color: CustomColors.mfinAlertRed,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      tooltipBehavior: TooltipBehavior(enable: true),
                      borderColor: CustomColors.mfinAlertRed,
                      primaryXAxis: DateTimeAxis(
                        intervalType: mode == 0
                            ? DateTimeIntervalType.days
                            : mode == 1
                                ? DateTimeIntervalType.days
                                : DateTimeIntervalType.months,
                        dateFormat: mode == 0
                            ? DateFormat('MMM-dd')
                            : mode == 1
                                ? DateFormat('MMM-dd')
                                : DateFormat('MMM-yyyy'),
                        minimum: fDate,
                        maximum: tDate,
                        interval: mode == 0 ? 1 : mode == 1 ? 7 : 1,
                        majorGridLines: MajorGridLines(width: 0),
                        title: AxisTitle(
                          text: mode == 0
                              ? 'Days'
                              : mode == 1 ? 'Weeks' : 'Months',
                          textStyle: TextStyle(
                            color: CustomColors.mfinBlue,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      primaryYAxis: NumericAxis(
                        minimum: 0,
                        maximum: max.toDouble(),
                        interval: interval.toDouble(),
                        labelFormat: '{value}',
                        majorTickLines: MajorTickLines(size: 0),
                        title: AxisTitle(
                          text: 'Amount',
                          textStyle: TextStyle(
                            color: CustomColors.mfinAlertRed,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      trackballBehavior: TrackballBehavior(
                          enable: true,
                          shouldAlwaysShow: true,
                          lineType: TrackballLineType.vertical,
                          lineColor: CustomColors.mfinPositiveGreen,
                          lineWidth: 2,
                          tooltipSettings:
                              InteractiveTooltip(format: 'point.x : point.y')),
                      series: type == 0
                          ? <ChartSeries>[
                              LineSeries<PayData, DateTime>(
                                dataSource: pData,
                                xValueMapper: (PayData pay, _) => pay.date,
                                yValueMapper: (PayData pay, _) => pay.amount,
                                dataLabelSettings: DataLabelSettings(
                                    isVisible: mode == 0 ? true : false),
                                width: 2,
                                color:
                                    CustomColors.mfinAlertRed.withOpacity(0.7),
                                animationDuration: 1500,
                                enableTooltip: true,
                                name: 'Loan',
                                markerSettings: MarkerSettings(
                                    isVisible: mode == 0 ? true : false),
                              ),
                            ]
                          : <ChartSeries>[
                              ColumnSeries<PayData, DateTime>(
                                dataSource: pData,
                                xValueMapper: (PayData pay, _) => pay.date,
                                yValueMapper: (PayData pay, _) => pay.amount,
                                dataLabelSettings: DataLabelSettings(
                                    isVisible: mode == 0 ? true : false),
                                gradient: LinearGradient(
                                  colors: [
                                    CustomColors.mfinAlertRed.withOpacity(0.3),
                                    CustomColors.mfinAlertRed.withOpacity(0.5),
                                    CustomColors.mfinAlertRed.withOpacity(0.8),
                                  ],
                                  stops: <double>[0.0, 0.4, 1.0],
                                ),
                                borderColor: CustomColors.mfinButtonGreen,
                                borderWidth: 1.0,
                                animationDuration: 1500,
                                enableTooltip: true,
                                name: 'Loan',
                                markerSettings: MarkerSettings(
                                    isVisible: mode == 0 ? true : false),
                              )
                            ],
                    ),
                  ),
                  Container(
                    child: aDetails.length > 0
                        ? ListView.builder(
                            padding: EdgeInsets.all(5),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            primary: false,
                            itemCount: aDetails.length,
                            itemBuilder: (BuildContext context, int index) {
                              String key = aDetails.keys.elementAt(index);
                              return Padding(
                                padding: EdgeInsets.all(5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text(
                                      '$key: ',
                                      style: TextStyle(
                                        fontFamily: "Georgia",
                                        color: CustomColors.mfinBlue,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Rs.${aDetails[key]}',
                                      style: TextStyle(
                                        fontFamily: "Georgia",
                                        color: CustomColors.mfinAlertRed,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          )
                        : Text("No Data Found!"),
                  )
                ],
              );
            } else {
              widget = Container(
                alignment: Alignment.center,
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        AppLocalizations.of(context).translate('payments'),
                        style: TextStyle(
                          color: CustomColors.mfinBlue,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Divider(
                      color: CustomColors.mfinButtonGreen,
                    ),
                    Flexible(
                      child: Text(
                        AppLocalizations.of(context).translate('no_entries'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: CustomColors.mfinAlertRed,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          } else if (snapshot.hasError) {
            widget = Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: AsyncWidgets.asyncError(),
              ),
            );
          } else {
            widget = Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: AsyncWidgets.asyncWaiting(),
              ),
            );
          }
          return widget;
        },
      ),
    );
  }
}

class PayData {
  PayData(this.date, this.amount);
  final DateTime date;
  final int amount;
}
