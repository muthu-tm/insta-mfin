import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:instamfin/screens/app/appBar.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/app/sideDrawer.dart';
import 'package:instamfin/screens/home/Authenticate.dart';
import 'package:instamfin/screens/home/HomePage.dart';
import 'package:instamfin/screens/home/MonthlyStatistics.dart';
import 'package:instamfin/screens/settings/widgets/PageViewWidget.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/services/controllers/auth/auth_controller.dart';

class UserHomeScreen extends StatelessWidget {
  final AuthController _authController = AuthController();
  final _controller = new PageController();

  static const _kDuration = const Duration(milliseconds: 300);

  static const _kCurve = Curves.ease;

  final _kArrowColor = CustomColors.mfinBlue.withOpacity(0.8);

  final List<Widget> _pages = <Widget>[
    new ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
        child: HomePage(),
      ),
    ),
    new ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: mothlyStatistics(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () => CustomDialogs.confirm(
          context, "Warning!", "Do you really want to exit?", () async {
        await _authController.signOut();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Authenticate()),
          (Route<dynamic> route) => false,
        );
      }, () => Navigator.pop(context, false)),
      child: Scaffold(
        // backgroundColor: CustomColors.mfinBlue,
        appBar: topAppBar(context),
        drawer: openDrawer(context),
        body: new IconTheme(
          data: new IconThemeData(color: _kArrowColor),
          child: new Stack(
            children: <Widget>[
              new PageView.builder(
                physics: new AlwaysScrollableScrollPhysics(),
                controller: _controller,
                itemBuilder: (BuildContext context, int index) {
                  return _pages[index % _pages.length];
                },
              ),
              new Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: new Container(
                  color: CustomColors.mfinLightGrey,
                  padding: const EdgeInsets.all(20.0),
                  child: new Center(
                    child: new DotsIndicator(
                      controller: _controller,
                      itemCount: _pages.length,
                      onPageSelected: (int page) {
                        _controller.animateToPage(
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
        ),
        bottomNavigationBar: bottomBar(context),
      ),
    );
  }
}
