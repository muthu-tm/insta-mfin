import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/db/models/notification.dart' as not;
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class NotificationListWidget extends StatelessWidget {
  NotificationListWidget(this.emptyText, this.tColor, this.fetchAll, this.type);

  final String emptyText;
  final Color tColor;
  final bool fetchAll;
  final List<int> type;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: fetchAll
          ? not.Notification().streamAll()
          : not.Notification().streamAllByType(type),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          if (snapshot.data.documents.length > 0) {
            children = <Widget>[
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    not.Notification _n = not.Notification.fromJson(
                        snapshot.data.documents[index].data);

                    Color cardColor = CustomColors.mfinGrey;
                    Color textColor = CustomColors.mfinBlue;
                    if (index % 2 == 0) {
                      cardColor = CustomColors.mfinBlue;
                      textColor = CustomColors.mfinGrey;
                    }

                    return Material(
                      color: cardColor,
                      elevation: 10.0,
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.36,
                        height: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Spacer(
                              flex: 3,
                            ),
                            SizedBox(
                              height: 20,
                              child: Text(
                                _n.title.toString(),
                                style: TextStyle(
                                    color: textColor,
                                    fontFamily: 'Georgia',
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Spacer(
                              flex: 1,
                            ),
                            new Divider(
                              color: CustomColors.mfinWhite,
                            ),
                            Spacer(
                              flex: 1,
                            ),
                            SizedBox(
                              height: 30,
                              child: Text(
                                _n.desc,
                                style: TextStyle(
                                    color: textColor,
                                    fontFamily: 'Georgia',
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Spacer(
                              flex: 1,
                            ),
                          ],
                        ),
                      ),
                    );
                  })
            ];
          } else {
            // No Collections available for this filterred view
            children = [
              Container(
                height: 90,
                child: Column(
                  children: <Widget>[
                    new Spacer(),
                    Text(
                      emptyText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: tColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    new Spacer(),
                  ],
                ),
              ),
            ];
          }
        } else if (snapshot.hasError) {
          children = AsyncWidgets.asyncError();
        } else {
          children = AsyncWidgets.asyncWaiting();
        }

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
        );
      },
    );
  }
}
