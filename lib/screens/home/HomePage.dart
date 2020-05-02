import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:instamfin/screens/home/MonthlyStatistics.dart';
import 'package:instamfin/screens/settings/widgets/CashInHandWidget.dart';
import 'package:instamfin/screens/settings/widgets/LastMonthStockWidget.dart';
import 'package:instamfin/screens/settings/widgets/PageViewWidget.dart';
import 'package:instamfin/screens/settings/widgets/PrimaryFinanceWidget.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class HomePage extends StatelessWidget {
  final _pageController = new PageController();

  static const _kDuration = const Duration(milliseconds: 300);

  static const _kCurve = Curves.ease;

  final _kArrowColor = CustomColors.mfinBlue.withOpacity(0.8);

  final List<Widget> _pages = <Widget>[
    new ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
        child: PrimaryFinanceWidget("Primary Finance"),
      ),
    ),
    new ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: mothlyStatistics(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return new IconTheme(
          data: new IconThemeData(color: _kArrowColor),
          child: Column(
            children: <Widget>[
              new Stack(
                children: <Widget>[
                  Container(
                    height: 240,
                    child: Card(
                      child: new PageView.builder(
                        physics: new AlwaysScrollableScrollPhysics(),
                        controller: _pageController,
                        itemBuilder: (BuildContext context, int index) {
                          return _pages[index % _pages.length];
                        },
                      ),
                    ),
                  ),
                  new Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: new Container(
                      color: CustomColors.mfinLightGrey,
                      child: new Center(
                        child: new DotsIndicator(
                          controller: _pageController,
                          itemCount: _pages.length,
                          onPageSelected: (int page) {
                            _pageController.animateToPage(
                              page,
                              duration: _kDuration,
                              curve: _kCurve,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              new Divider(),
              new Container(
                color: CustomColors.mfinLightGrey,
                child: cashInHand(),
              ),
              new Divider(),
              new Container(
                color: CustomColors.mfinLightGrey,
                child: Column(
                  children: <Widget>[
                    homeContainerWidget("Total Customers:", "35"),
                    homeContainerWidget("Total Stock:", "625000"),
                    homeContainerWidget("Total Collection:", "625000"),
                  ],
                ),
              ),
            ],
          ),
    );
  }
}
