import 'dart:async';
import 'dart:math';
import 'dart:math' as math;

import 'package:dinosaur_game/bean/tree.dart';
import 'package:dinosaur_game/util/utils.dart' as utils;
import 'package:flutter/material.dart';

import 'dinosaur_widget.dart';
import 'ground.dart';

class Game extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

const double adminWidth = 40.0; //角色宽度
const double adminHeight = 40.0; //角色高度
const double initAdminYAlign = 0.655; //角色初始位置
const double jumpHeight = 0.4; //角色跳的高度
const double initCenterXAlign = 0.5; //中间土地的初始位置
const double adminXAlign = 0.15; //角色在x轴的位置
const double groundYAlign = 0.7; //土地在y轴的位置
const double groundHeight = 10.0; //土地的高度

class _GameState extends State<Game> with SingleTickerProviderStateMixin {
  double ratio = 0.6; //每个土地占屏幕宽度的比例
  int highestScore = 0; //最高分数
  int curScore = 0; //目前分数
  bool canJump = true; //是否可以跳
  bool jumping = false; //是否在跳跃中

  double initRightXAlign = 0.5; //最右边的土地所在的初始位置
  double initLeftXAlign = 0.5; //最左边土地所在的初始位置

  double centerXAlign = initCenterXAlign; //中间土地的实时x轴位置
  double rightXAlign = 0.5; //右侧土地实时x轴位置
  double leftXAlign = 0.5; //左侧土地实时x轴位置
  double adminYAlign = initAdminYAlign; //角色的实时y轴位置

  bool firstBuild = true; //是否第一次构建
  bool isRunning = false; //游戏是否正在运行
  bool isFirstStart = true; //是否第一次开始游戏

  Timer groundTimer; //操纵土地滚动
  Color drawColor = const Color(0xff9C9C9C);

  Tree leftTree; //左边土地上的树
  Tree centerTree; //中间土地上的树
  Tree rightTree; //右侧土地上的树

  Animation upAnimation; //向上跳的动画
  Animation downAnimation; //向下跳的动画
  AnimationController jumpController; //用来控制跳跃动画

  @override
  void initState() {
    super.initState();

    jumpController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 900),
    );

    upAnimation = Tween<double>(
      begin: initAdminYAlign,
      end: initAdminYAlign - jumpHeight,
    ).animate(CurveTween(
      curve: Interval(0, 0.5, curve: Curves.decelerate),
    ).animate(jumpController));

    downAnimation = Tween<double>(
      begin: initAdminYAlign - jumpHeight,
      end: initAdminYAlign,
    ).animate(CurveTween(
      curve: Interval(0.5, 1, curve: Curves.fastOutSlowIn),
    ).animate(jumpController));

    jumpController.addListener(() {
      if (jumping) {
        double value = jumpController.value;
        setState(() {
          if (value < 0.5) {
            adminYAlign = upAnimation.value;
          } else {
            adminYAlign = downAnimation.value;
          }
        });
      }
    });

    jumpController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        jumping = false;
        jumpController.reverseDuration = Duration(milliseconds: 0);
        jumpController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        canJump = true;
      }
    });
  }

  @override
  void dispose() {
    jumpController.dispose();
    stopGroundTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (firstBuild) {
      firstBuild = false;

      rightXAlign = (0.5 * ratio + 0.5) / (1 - ratio);
      initRightXAlign = rightXAlign;

      leftXAlign = (0.5 - 1.5 * ratio) / (1 - ratio);
      initLeftXAlign = leftXAlign;

      recreateAllTrees();
    }

    return GestureDetector(
      onTap: () {
        jump();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: ClipRect(
            child: Align(
              widthFactor: 1,
              child: Stack(
                children: [
                  //得分
                  Align(
                    alignment: Alignment(0.7, -0.8),
                    child: Text(
                      'HI  ${utils.addDigitToFive(highestScore)}  '
                      '${utils.addDigitToFive(curScore)}',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 127, 127, 127),
                        fontFamily: 'FZXIANGSU12',
                      ),
                    ),
                  ),
                  //文字提示区域
                  if (!isRunning)
                    Align(
                      alignment: Alignment(0.0, -0.5),
                      child: Text(
                        isFirstStart ? 'S T A R T' : 'G A M E   O V E R',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 127, 127, 127),
                          fontFamily: 'FZXIANGSU12',
                        ),
                      ),
                    ),
                  //操作按钮
                  if (!isRunning)
                    GestureDetector(
                      onTap: () {
                        isFirstStart = false;
                        startGroundTimer();
                      },
                      child: Align(
                        alignment: Alignment(0.0, -0.2),
                        child: Container(
                          width: 45.0,
                          height: 30.0,
                          decoration: BoxDecoration(
                            color: drawColor,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Icon(
                            isFirstStart
                                ? Icons.not_started_outlined
                                : Icons.autorenew_outlined,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),

                  //游戏角色
                  Align(
                    alignment: FractionalOffset(adminXAlign, adminYAlign),
                    child: Container(
                      child: DinosaurWidget(adminWidth, adminHeight),
                    ),
                  ),

                  //左侧土地
                  createSingleGround(
                    leftXAlign,
                    leftTree,
                    // color: Colors.red,
                  ),
                  //中间土地
                  createSingleGround(
                    centerXAlign,
                    centerTree,
                    // color: Colors.blue,
                  ),
                  //右侧土地
                  createSingleGround(
                    rightXAlign,
                    rightTree,
                    // color: Colors.yellow,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///创建一块土地
  Widget createSingleGround(double xAlign, Tree tree, {Color color}) {
    double screenWidth = MediaQuery.of(context).size.width;
    double singleGroundWidth = ratio * screenWidth;

    return Align(
      alignment: FractionalOffset(xAlign, groundYAlign),
      child: CustomPaint(
        size: Size(singleGroundWidth, groundHeight),
        painter: Ground(color: color ?? drawColor, tree: tree),
      ),
    );
  }

  //定时对土地进行滚动
  void startGroundTimer() {
    setState(() {
      isRunning = true;
    });
    if (groundTimer != null) {
      //重新开始时的初始化操作
      groundTimer.cancel();
      recreateAllTrees();
      leftXAlign = initLeftXAlign;
      rightXAlign = initRightXAlign;
      centerXAlign = initCenterXAlign;
      adminYAlign = initAdminYAlign;
    }
    //定时器
    groundTimer = Timer.periodic(
      Duration(milliseconds: 100),
      (timer) {
        //判断游戏角色是否与树发生碰撞
        Rect adminRect = calculateAdminRect();
        List<Rect> list = calculateTreeRect(leftTree, leftXAlign)
          ..addAll(calculateTreeRect(centerTree, centerXAlign))
          ..addAll(calculateTreeRect(rightTree, rightXAlign));

        for (int i = 0; i < list.length; i++) {
          if (utils.isCrash(adminRect, list[i])) {
            stopGroundTimer();
            return;
          }
        }

        setState(() {
          runGroundScroll();
          curScore++;
        });
      },
    );
  }

  //停止滚动
  void stopGroundTimer() {
    setState(() {
      isRunning = false;
      highestScore = highestScore > curScore ? highestScore : curScore;
      curScore = 0;
      jumping = false;
      canJump = true;
    });
    groundTimer?.cancel();
  }

  //水平面进行左右滚动
  void runGroundScroll() {
    leftXAlign -= 0.1;
    centerXAlign -= 0.1;
    rightXAlign -= 0.1;

    //最右边的line全部进入屏幕时，
    //将最左边的line的起点放到屏幕的最右边。
    if (rightXAlign + 0.001 >= 1 && rightXAlign < 1) {
      leftXAlign = 2.5;
      leftTree = createTree();
    }

    //最左边的line全部进入屏幕时，
    //将中间line的起点放到屏幕的最右边。
    if (leftXAlign + 0.001 >= 1 && leftXAlign < 1) {
      centerXAlign = 2.5;
      centerTree = createTree();
    }

    //中间的line全部进入屏幕时，
    //将最右边的line的起点放到屏幕的最右边。
    if (centerXAlign + 0.001 >= 1 && centerXAlign < 1) {
      rightXAlign = 2.5;
      rightTree = createTree();
    }
  }

  //创建土地上的树
  Tree createTree() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double width = math.max<double>(screenWidth, screenHeight) * ratio;

    bool isSmall = Random().nextBool();
    bool isDouble = Random().nextBool();
    bool isAfter = Random().nextBool();
    return Tree(width / 2, isSmall, isDouble, isAfter);
  }

  //来，跳一跳
  void jump() {
    //游戏未开始，滚
    if (!isRunning) {
      return;
    }

    //正在跳，滚
    if (jumping) {
      return;
    }

    //不能跳，滚
    if (!canJump) {
      return;
    }

    //跳吧
    jumping = true;
    canJump = false;
    jumpController.forward();
  }

  //创建各个土地上的树
  void recreateAllTrees() {
    leftTree = createTree();
    centerTree = createTree();
    rightTree = createTree();
  }

  //计算小恐龙的矩形
  Rect calculateAdminRect() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double left = adminXAlign * (screenWidth - adminWidth);
    double top = adminYAlign * (screenHeight - adminHeight);
    return Rect.fromLTRB(left, top, left + adminWidth, top + adminHeight);
  }

  ///计算树所处的矩形
  List<Rect> calculateTreeRect(Tree tree, double xAlign) {
    var list = <Rect>[];
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double left = xAlign * (screenWidth - screenWidth * ratio) +
        screenWidth * ratio * 0.5;
    double gTop = groundYAlign * (screenHeight - groundHeight);

    if (tree.isSmall) {
      //小树
      double top = gTop - 23;
      list.add(Rect.fromLTRB(left - 9, top, left + 15, top + 33));

      if (tree.isDouble) {
        if (tree.isAfter) {
          double otherLeft = left + 13;
          list.add(Rect.fromLTRB(otherLeft, top, otherLeft + 25, top + 33));
        } else {
          double otherLeft = left - 35;
          list.add(Rect.fromLTRB(otherLeft, top, otherLeft + 27, top + 33));
        }
      }
    } else {
      //大树
      double top = gTop - 45;
      list.add(Rect.fromLTRB(left - 10, top, left + 18, top + 55));

      if (tree.isDouble) {
        if (tree.isAfter) {
          double otherLeft = left + 14;
          double otherTop = gTop - 23;
          list.add(
            Rect.fromLTRB(otherLeft, otherTop, otherLeft + 25, otherTop + 33),
          );
        } else {
          double otherLeft = left - 34;
          double otherTop = gTop - 23;
          list.add(
            Rect.fromLTRB(otherLeft, otherTop, otherLeft + 25, otherTop + 33),
          );
        }
      }
    }

    return list;
  }
}
