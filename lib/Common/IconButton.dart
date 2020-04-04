import 'package:flutter/material.dart';

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
