import 'package:flutter/material.dart';

Container roundedButton({
  required BuildContext context,
  required IconData icon,
  required Function() onTap,
}) {
  return Container(
    height: 30,
    width: 30,
    decoration: BoxDecoration(
      color: Colors.lightBlue,
      border: Border.all(color: Colors.transparent),
      borderRadius: BorderRadius.circular(10),
    ),
    child: GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        color: Colors.white,
      ),
    ),
  );
}
