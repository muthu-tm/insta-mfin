import 'package:flutter/material.dart';
import 'package:instamfin/db/models/journal_entry.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class JournalStatisticsWidget extends StatelessWidget {
  JournalStatisticsWidget(this.type, this.mode, [this.fDate, this.tDate]);

  final User user = UserController().getCurrentUser();

  final int type;
  final int mode;
  final DateTime fDate;
  final DateTime tDate;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      child: FutureBuilder<List<JournalEntry>>(
        future: JournalEntry().getAllJournalsByDateRage(user.primaryFinance,
            user.primaryBranch, user.primarySubBranch, fDate, tDate),
        builder: (context, snapshot) {
          Widget widget;

          if (snapshot.hasData) {
            if (snapshot.data.isNotEmpty) {
              int max = 0;
              int interval = 10;
              List<JData> jData = [];
              snapshot.data.forEach((e) {
                if (e.amount > max) {
                  max = e.amount + interval;
                  interval = (e.amount / 5).round();
                }

                jData.add(JData(e.journalDate, e.amount));
              });
              widget = Container(
                child: SfCartesianChart(
                  title: ChartTitle(
                    text: 'JOURNALS',
                    textStyle: ChartTextStyle(
                      color: CustomColors.mfinBlue,
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
                      text: mode == 0 ? 'Days' : mode == 1 ? 'Weeks' : 'Months',
                      textStyle: ChartTextStyle(
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
                    labelFormat: 'Rs.{value}',
                    majorTickLines: MajorTickLines(size: 0),
                    title: AxisTitle(
                      text: 'Amount',
                      textStyle: ChartTextStyle(
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
                          AreaSeries<JData, DateTime>(
                            dataSource: jData,
                            xValueMapper: (JData pay, _) => pay.date,
                            yValueMapper: (JData pay, _) => pay.amount,
                            dataLabelSettings:
                                DataLabelSettings(isVisible: true),
                            gradient: LinearGradient(
                              colors: [
                                CustomColors.mfinLightGrey,
                                CustomColors.mfinLightBlue,
                                CustomColors.mfinBlue
                              ],
                              stops: <double>[0.0, 0.5, 1.0],
                            ),
                          ),
                        ]
                      : type == 1
                          ? <CartesianSeries>[
                              BubbleSeries<JData, DateTime>(
                                dataSource: jData,
                                xValueMapper: (JData j, _) => j.date,
                                yValueMapper: (JData j, _) => j.amount,
                                dataLabelSettings:
                                    DataLabelSettings(isVisible: true),
                                sizeValueMapper: (JData j, _) =>
                                    (j.amount.toString().length * 0.5),
                                gradient: LinearGradient(
                                  colors: [
                                    CustomColors.mfinLightGrey,
                                    CustomColors.mfinLightBlue,
                                    CustomColors.mfinBlue
                                  ],
                                  stops: <double>[0.0, 0.5, 1.0],
                                ),
                              ),
                            ]
                          : <ChartSeries>[
                              ColumnSeries<JData, DateTime>(
                                dataSource: jData,
                                xValueMapper: (JData j, _) => j.date,
                                yValueMapper: (JData j, _) => j.amount,
                                dataLabelSettings:
                                    DataLabelSettings(isVisible: true),
                                gradient: LinearGradient(
                                  colors: [
                                    CustomColors.mfinLightGrey,
                                    CustomColors.mfinLightBlue,
                                    CustomColors.mfinBlue
                                  ],
                                  stops: <double>[0.0, 0.5, 1.0],
                                ),
                              )
                            ],
                ),
              );
            } else {
              widget = Container(
                alignment: Alignment.center,
                height: 90,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        "No Entries during the selected Range!",
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

class JData {
  JData(this.date, this.amount);
  final DateTime date;
  final int amount;
}
