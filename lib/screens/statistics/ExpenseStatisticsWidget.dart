import 'package:flutter/material.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ExpenseStatisticsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      child: Container(
        child: SfCartesianChart(
          borderColor: CustomColors.mfinAlertRed,
          primaryXAxis: CategoryAxis(),
          title: ChartTitle(
            text: 'EXPENSES',
            textStyle: ChartTextStyle(
              color: CustomColors.mfinBlue,
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <LineSeries<SalesData, String>>[
            LineSeries<SalesData, String>(
                dataSource: <SalesData>[
                  SalesData('Jan', 35),
                  SalesData('Feb', 28),
                  SalesData('Mar', 34),
                  SalesData('Apr', 32),
                  SalesData('May', 40)
                ],
                xValueMapper: (SalesData sales, _) => sales.year,
                yValueMapper: (SalesData sales, _) => sales.sales,
                // Enable data label
                dataLabelSettings: DataLabelSettings(isVisible: true))
          ],
        ),
      ),
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}
