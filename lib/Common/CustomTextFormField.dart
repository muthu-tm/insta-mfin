    import 'package:flutter/material.dart';

    Widget customTextFormField(hintText,bodyColor,icon,type) {
      return TextFormField(
              keyboardType: type,
              decoration: InputDecoration(
                hintText: hintText,
                fillColor: bodyColor,
                filled: true,
                
                suffixIcon: Icon(
                  icon,
                  color: Colors.blue[200],
                  size: 35.0,
                ),
              ),
              validator: (value) => value.isEmpty ? hintText+ 'is required' : null,
            );
    }
    