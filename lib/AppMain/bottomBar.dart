import 'package:flutter/material.dart';
import 'package:instamfin/Common/IconButton.dart';
import 'package:instamfin/screens/common/colors.dart';

    Widget bottomBar() {
      return Container(
        width: double.infinity,
        height: 90.0,
        color: CustomColors.mfinGrey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                customIconButton(Icons.supervisor_account,55.0, CustomColors.mfinBlue),Spacer(),
                customIconButton(Icons.date_range,50.0, CustomColors.mfinBlue),Spacer(),
                customIconButton(Icons.assessment,50.0, CustomColors.mfinBlue),Spacer(),
                customIconButton(Icons.content_copy,50.0, CustomColors.mfinBlue),Spacer(),
                customIconButton(Icons.settings,50.0, CustomColors.mfinBlue),Spacer(),
            ],
          ),
      );
    }