import 'package:flutter/material.dart';

class Cbuttons extends StatelessWidget {
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Widget child;
  final double padding;
  final double borderRadius;
  const Cbuttons(
      {Key? key,
      required this.onPressed,
      required this.backgroundColor,
      required this.child,
      required this.padding,
      required this.borderRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 15,
      color: backgroundColor,
      borderRadius: BorderRadius.circular(borderRadius),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: MaterialButton(
          padding: EdgeInsets.all(padding),
          onPressed: onPressed,
          child: child,
        ),
      ),
    );
  }
}
