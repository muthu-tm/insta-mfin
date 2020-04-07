import 'package:flutter/material.dart';

Widget customIconButton(icon, size, color, Function() onPressedCall) {
  return IconButton(
    icon: Icon(
      icon,
      color: color,
      size: size,
    ),
    onPressed: () => onPressedCall(),
  );
}
