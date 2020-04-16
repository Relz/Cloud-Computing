import 'package:flutter/material.dart';

class OverlayMessage extends StatelessWidget {
  const OverlayMessage({
    Key key,
    this.message,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  final String message;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) => Container(
        color: backgroundColor,
        child: Center(
          child: Text(
            message,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      );
}
