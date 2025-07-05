import 'package:flutter/material.dart';

class CenteredLayout extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const CenteredLayout({
    super.key,
    required this.child,
    this.maxWidth = 600,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
