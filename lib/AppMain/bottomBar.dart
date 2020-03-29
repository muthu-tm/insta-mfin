import 'package:flutter/material.dart';
import 'package:instamfin/Common/IconButton.dart';

    Widget bottomBar() {
      return Container(
        width: double.infinity,
        height: 90.0,
        color: Colors.grey[300],
          child: Row(
            children: <Widget>[
                customIconButton(Icons.supervisor_account,50.0),Spacer(),
                customIconButton(Icons.date_range,50.0),Spacer(),
                customIconButton(Icons.assessment,50.0),Spacer(),
                customIconButton(Icons.content_copy,50.0),Spacer(),
                customIconButton(Icons.settings,50.0),Spacer(),
            ],
          ),
      );
    }