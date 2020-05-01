import 'package:flutter/material.dart';
import 'package:instamfin/screens/settings/widgets/LastMonthStockWidget.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

Widget mothlyStatistics(){
             return new Container(
                color: CustomColors.mfinLightGrey,
                child: Column(
                  children: <Widget>[
                    homeContainerWidget("New Customers:", "35"),
                    homeContainerWidget("Number of Payments:", "625000"),
                    homeContainerWidget("Total Stock:", "625000"),
                    homeContainerWidget("Total Collection:", "625000"),
                    homeContainerWidget("Number of Closing:", "625000"),
                    homeContainerWidget("Total Miscellaneous:", "625000"),
                    homeContainerWidget("Journal Entries In:", "625000"),
                    homeContainerWidget("Journal Entries Out:", "625000"),
                    homeContainerWidget("Shortage Amount:", "625000"),
                  ],
                ),
              );
              }