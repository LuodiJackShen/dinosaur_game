import 'dart:ui';

class Rubble {
  Offset start;
  Offset end;

  Rubble(this.start, this.end);

  Rubble.startEnd(double sx, double sy, double ex, double ey) {
    start = Offset(sx, sy);
    end = Offset(ex, ey);
  }

  double get sx => start.dx;

  double get sy => start.dy;

  double get ex => end.dx;

  double get ey => end.dy;
}
