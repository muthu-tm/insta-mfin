import 'package:flutter/material.dart';
import 'package:instamfin/screens/app/sideDrawer.dart';
import 'package:instamfin/screens/customer/CustomerListWidget.dart';
import 'package:instamfin/screens/settings/widgets/ViewCustomerWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:instamfin/screens/app/appBar.dart';
import 'package:instamfin/screens/app/bottomBar.dart';

class ViewCustomer extends StatefulWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  _ViewCustomerState createState() => _ViewCustomerState();
}

class _ViewCustomerState extends State<ViewCustomer> {
  int status = 0;
  String title = "New Customers";
  final _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);
  List<Widget> _pages;

  final titles = [
    'New Customers',
    'Active Customers',
    'Pending Customers',
    'Closed Customers',
    'Blocked Customers'
  ];

  @override
  Widget build(BuildContext context) {
    _pages = <Widget>[
      new ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
            child: Column(children: <Widget>[
              viewCustomerWidget(titles[0], CustomColors.mfinBlue),
            ])),
      ),
      new ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: Column(children: <Widget>[
            viewCustomerWidget(titles[1], CustomColors.mfinPositiveGreen),
          ])),
      new ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: Column(children: <Widget>[
            viewCustomerWidget(titles[2], CustomColors.mfinFadedButtonGreen),
          ])),
      new ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: Column(children: <Widget>[
            viewCustomerWidget(titles[3], CustomColors.mfinGrey),
          ])),
      new ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: Column(children: <Widget>[
            viewCustomerWidget(titles[4], CustomColors.mfinAlertRed),
          ])),
    ];
    return new Scaffold(
      resizeToAvoidBottomInset: false, // set it to false
      key: widget._scaffoldKey,
      appBar: topAppBar(context),
      drawer: openDrawer(context),
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              _buildPageView(),
              _buildCircleIndicator(),
            ],
          ),
          CustomerListWidget(widget._scaffoldKey, title, status),
        ],
      ),
      bottomSheet: bottomBar(context),
    );
  }

  _buildPageView() {
    return Container(
      height: 250,
      child: Card(
        child: PageView.builder(
            itemCount: _pages.length,
            controller: _pageController,
            itemBuilder: (BuildContext context, int index) {
              return Center(
                child: _pages[index],
              );
            },
            onPageChanged: (int index) {
              _currentPageNotifier.value = index;
              setSelectedCard(index, titles[index]);
            }),
      ),
    );
  }

  _buildCircleIndicator() {
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: CirclePageIndicator(
          itemCount: _pages.length,
          currentPageNotifier: _currentPageNotifier,
        ),
      ),
    );
  }

  setSelectedCard(int val, String title) {
    setState(() {
      this.status = val;
      this.title = title;
    });
  }
}
