import 'package:flutter/material.dart';

class FocusedMenuItem {
  Color? backgroundColor;
  Widget? title;
  Icon? trailingIcon;
  Function? onPressed;

  FocusedMenuItem(
      {this.backgroundColor, this.title,
      this.trailingIcon, this.onPressed});
}
