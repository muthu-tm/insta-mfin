import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:instamfin/screens/app/appBar.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/app/sideDrawer.dart';
import 'package:instamfin/screens/home/Authenticate.dart';
import 'package:instamfin/screens/home/HomeOptions.dart';
import 'package:instamfin/screens/settings/PrimaryFinanceWidget.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/services/controllers/auth/auth_controller.dart';

class UserHomeScreen extends StatelessWidget {
  final AuthController _authController = AuthController();

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
        body: ListView(
            padding: const EdgeInsets.fromLTRB(0, 1, 0, 10),
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
                child: PrimaryFinanceWidget("Primary Finance"),
              ),
              Container(
                  height: 45.0,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new Spacer(
                        flex: 4,
                      ),
                      Text(
                        "Cash In Hand: ",
                        style: TextStyle(
                          fontFamily: 'Georgia',
                          color: CustomColors.mfinBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 22.0,
                        ),
                      ),
                      new Spacer(
                        flex: 1,
                      ),
                      Container(
                        color: CustomColors.mfinPositiveGreen,
                        height: 40.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              " Rs. 1,00,000 ",
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0,
                                color: CustomColors.mfinLightGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      new Spacer(
                        flex: 1,
                      ),
                    ],
                  )),
              new Divider(),
              Container(
                // height: MediaQuery.of(context).size.height * 1.0,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            "Last Month stock: ",
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              color: CustomColors.mfinBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0,
                            ),
                          ),
                        ],
                      )
                    ]),
              ),
            ]),
        // ListView.builder(
        //   itemCount: options.length + 2,
        //   itemBuilder: (BuildContext context, int index) {
        //     if (index == 0) {
        //       return SizedBox(height: 5.0);
        //     } else if (index == options.length + 1) {
        //       return SizedBox(height: 100.0);
        //     }
        //     return Container(
        //       alignment: Alignment.center,
        //       margin: EdgeInsets.all(10.0),
        //       width: double.infinity,
        //       height: 70.0,
        //       decoration: BoxDecoration(
        //           color: CustomColors.mfinGrey,
        //           borderRadius: BorderRadius.circular(10.0),
        //           border: Border.all(color: CustomColors.mfinWhite)),
        //       child: ListTile(
        //         trailing: Text(options[index - 1].value),
        //         title: Text(
        //           options[index - 1].title,
        //           style: TextStyle(
        //             color: CustomColors.mfinGrey,
        //           ),
        //         ),
        //         onTap: () {},
        //       ),
        //     );
        //   },
        // ),
        bottomSheet: bottomBar(context),
      ),
    );
  }
}
