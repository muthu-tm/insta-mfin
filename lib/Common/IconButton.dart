import 'package:flutter/material.dart';
import 'package:instamfin/screens/common/colors.dart';

Widget customIconButton(icon, size, color) {
  return IconButton(
    icon: Icon(
      icon,
      color: color,
      size: size,
    ),
    onPressed: () {},
  );
}
