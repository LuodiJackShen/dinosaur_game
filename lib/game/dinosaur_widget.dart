import 'dart:ui';

import 'package:flutter/material.dart';

class DinosaurWidget extends StatelessWidget {
  final double width;
  final double height;

  DinosaurWidget(this.width, this.height);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'images/dinosaur.png',
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
  }
}
