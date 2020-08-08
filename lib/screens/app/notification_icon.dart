import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/screens/app/NotificationHome.dart';
import 'package:instamfin/screens/home/AuthPage.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class PushNotification extends StatefulWidget {
  @override
  _PushNotificationState createState() => _PushNotificationState();
}

class _PushNotificationState extends State<PushNotification> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  bool _newNotification = false;
  Map<String, dynamic> message;

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(
                message['notification']['title'],
                style: TextStyle(
                    color: CustomColors.mfinBlue,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.start,
              ),
              subtitle: Text(
                message['notification']['body'],
                style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
        setState(() {
          this.message = message;
          _newNotification = true;
        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        _navigateToItemDetail(message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget widget;

    _newNotification
        ? widget = Stack(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.notifications,
                  size: 30.0,
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationHome(),
                    settings: RouteSettings(name: '/notifications'),
                  ),
                ),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  padding: EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: CustomColors.mfinAlertRed,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 13,
                    minHeight: 13,
                  ),
                  child: Text(
                    '',
                    style: TextStyle(
                      color: CustomColors.mfinWhite,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          )
        : widget = IconButton(
            icon: Icon(Icons.notifications),
            iconSize: 30.0,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NotificationHome(),
                settings: RouteSettings(name: '/notifications'),
              ),
            ),
          );

    return widget;
  }

  //PRIVATE METHOD TO HANDLE NAVIGATION TO SPECIFIC PAGE
  void _navigateToItemDetail(Map<String, dynamic> message) {
    final dynamic data = message['data'] ?? message;
    final String user = data['user'];

    AuthPage();
  }
}
