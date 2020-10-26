import 'dart:math';

import 'package:dinosaur_game/bean/rubble.dart';

class RubbleFactory {
  List<Rubble> _rubbles = [];

  static RubbleFactory _instance;

  static get instance => _getInstance();

  factory RubbleFactory() => _getInstance();

  static RubbleFactory _getInstance() {
    if (_instance == null) {
      _instance = RubbleFactory._internal();
    }
    return _instance;
  }

  RubbleFactory._internal();

  List<Rubble> createRubbles(double width, double height, {int count = 20}) {
    if (_rubbles.isEmpty) {
      double start = 0;
      double maxW = width / count;
      for (int i = 0; i < count; i++) {
        double h = Random().nextDouble() * height + 0.15;
        double w = Random().nextDouble() * maxW + 0.01;

        start += maxW * i;
        _rubbles.add(Rubble.startEnd(start, h, start + w, h));
      }
    }

    return _rubbles;
  }
}
