    import 'package:flutter/material.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

    Widget customTextFormField(hintText,bodyColor,icon,type) {
      return TextFormField(
              keyboardType: type,
              decoration: InputDecoration(
                hintText: hintText,
                fillColor: bodyColor,
                filled: true,
                
                suffixIcon: Icon(
                  icon,
                  color: CustomColors.mfinPositiveGreen,
                  size: 35.0,
                ),
              ),
              validator: (value) => value.isEmpty ? hintText+ 'is required' : null,
            );
    }
    