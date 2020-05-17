import 'package:flutter/material.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class NotificationHome extends StatelessWidget {
  NotificationHome(this.message);

  final Map<String, dynamic> message;

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic> notification = message['notification'];
    String title = notification['title'];
    String body = notification['body'];
    Map<dynamic, dynamic> data = message['data'];

    return Center(
      child: Container(
          child: Column(
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: CustomColors.mfinBlue,
            ),
          ),
          Text(
            body,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: CustomColors.mfinBlue,
            ),
          ),
          Text(
            data['user'],
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: CustomColors.mfinBlue,
            ),
          ),
        ],
      )),
    );
  }
}
