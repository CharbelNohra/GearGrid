import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double? width;
  final double? height;

  const AppLogo({
    super.key,
    this.width = 250,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/logo.png',
          width: width,
          height: height,
        ),
      ],
    );
  }
}