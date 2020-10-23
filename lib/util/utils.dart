import 'dart:ui';

///数字补位
String addDigitToFive(int number) {
  int length = number.toString().length;
  return '${'0' * (5 - length)}$number';
}

///判断两个矩形是否发生了碰撞
///坐标原点在屏幕右上角时的判断规则
bool isCrash(Rect r1, Rect r2) {
  return !(((r1.right < r2.left) || (r1.bottom < r2.top)) ||
      ((r1.left > r2.left) || (r1.top > r2.bottom)));
}
