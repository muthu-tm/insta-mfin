import 'package:flutter/material.dart';
import 'package:instamfin/db/models/expense.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../app_localizations.dart';

class ExpenseStatisticsWidget extends StatelessWidget {
  ExpenseStatisticsWidget(this.type, this.mode, [this.fDate, this.tDate]);

  final User user = UserController().getCurrentUser();

  final int type;
  final int mode;
  final DateTime fDate;
  final DateTime tDate;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      child: FutureBuilder<List<Expense>>(
        future: Expense().getAllExpensesByDateRange(
            user.primary.financeID,
            user.primary.branchName,
            user.primary.subBranchName,
            DateUtils.getUTCDateEpoch(fDate),
            DateUtils.getUTCDateEpoch(tDate)),
        builder: (context, snapshot) {
          Widget widget;

          if (snapshot.hasData) {
            if (snapshot.data.isNotEmpty) {
              int max = 0;
              int interval = 10;
              List<EData> eData = [];
              Map<DateTime, EData> eGroup = new Map();

              Map<String, int> aDetails = new Map();
              DateFormat formatter = DateFormat('MMM-yyyy');
              if (mode == 0) formatter = DateFormat('dd-MMM-yyyy');

              snapshot.data.forEach((e) {
                DateTime _dt =
                    DateTime.fromMillisecondsSinceEpoch(e.expenseDate);

                eGroup.update(
                  _dt,
                  (value) => EData(_dt, value.amount + e.amount),
                  ifAbsent: () => EData(_dt, e.amount),
                );

                String format = formatter.format(_dt);
                aDetails.update(format, (value) => e.amount + value,
                    ifAbsent: () => e.amount);
              });

              eGroup.forEach((key, value) {
                if (value.amount > max) {
                  interval = (value.amount / 5).round();
                  max = value.amount + ((1000 < interval) ? 1000 : 100);
                }

                eData.add(value);
              });

              widget = Column(
                children: <Widget>[
                  Container(
                    child: SfCartesianChart(
                      title: ChartTitle(
                        text:
                            AppLocalizations.of(context).translate('expenses'),
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
                              LineSeries<EData, DateTime>(
                                dataSource: eData,
                                xValueMapper: (EData pay, _) => pay.date,
                                yValueMapper: (EData pay, _) => pay.amount,
                                dataLabelSettings: DataLabelSettings(
                                    isVisible: mode == 0 ? true : false),
                                width: 2,
                                color: CustomColors.mfinAlertRed,
                                animationDuration: 1500,
                                enableTooltip: true,
                                name: 'Expense',
                                markerSettings: MarkerSettings(
                                    isVisible: mode == 0 ? true : false),
                              ),
                            ]
                          : <ChartSeries>[
                              ColumnSeries<EData, DateTime>(
                                dataSource: eData,
                                xValueMapper: (EData e, _) => e.date,
                                yValueMapper: (EData e, _) => e.amount,
                                dataLabelSettings: DataLabelSettings(
                                    isVisible: mode == 0 ? true : false),
                                color: CustomColors.mfinAlertRed,
                                borderColor: CustomColors.mfinBlue,
                                borderWidth: 1.0,
                                animationDuration: 1500,
                                enableTooltip: true,
                                name: 'Expense',
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
                        AppLocalizations.of(context).translate('expenses'),
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

class EData {
  EData(this.date, this.amount);
  final DateTime date;
  final int amount;
}
