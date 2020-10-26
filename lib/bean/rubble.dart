import 'dart:ui';

class Rubble {
  Offset start;
  Offset end;

  Rubble(this.start, this.end);

  Rubble.startEnd(double sx, double sy, double ex, double ey) {
    start = Offset(sx, sy);
    end = Offset(ex, ey);
  }
}
