import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/db/models/notification.dart' as not;
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/date_utils.dart';

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
        Widget widget;

        if (snapshot.hasData) {
          if (snapshot.data.documents.length > 0) {
            widget = ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  not.Notification _n = not.Notification.fromJson(
                      snapshot.data.documents[index].data);

                  Color cardColor = CustomColors.mfinGrey;
                  Color textColor = CustomColors.mfinBlue;
                  if (index % 2 == 0) {
                    cardColor = CustomColors.mfinBlue;
                    textColor = CustomColors.mfinWhite;
                  }

                  return Card(
                    color: cardColor,
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: SizedBox(
                      height: 100,
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 5, right: 10),
                            child: _n.logoPath == ""
                                ? Container(
                                    width: 60,
                                    height: 60,
                                    margin: EdgeInsets.only(bottom: 5),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color:
                                              CustomColors.mfinFadedButtonGreen,
                                          style: BorderStyle.solid,
                                          width: 2.0),
                                    ),
                                    child: Icon(
                                      Icons.turned_in_not,
                                      size: 30.0,
                                      color: CustomColors.mfinLightGrey,
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(_n.logoPath),
                                    backgroundColor: Colors.transparent,
                                  ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(top: 2.0, bottom: 2.0),
                                    child: Text(
                                      _n.title.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: textColor,
                                          fontFamily: 'Georgia',
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    _n.desc,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: textColor,
                                        fontFamily: 'Georgia',
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 2.0, bottom: 5.0),
                                  child: Text(
                                    DateUtils.formatDateTime(_n.createdAt),
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        color: textColor,
                                        fontFamily: 'Georgia',
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          } else {
            widget = Container(
              height: 90,
              child: Column(
                children: <Widget>[
                  Spacer(),
                  Text(
                    emptyText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: tColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                ],
              ),
            );
          }
        } else if (snapshot.hasError) {
          widget = Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: AsyncWidgets.asyncError());
        } else {
          widget = Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: AsyncWidgets.asyncWaiting());
        }

        return widget;
      },
    );
  }
}
