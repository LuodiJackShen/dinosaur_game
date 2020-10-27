import 'package:dinosaur_game/game/dinosaur_widget.dart';
import 'package:flutter/material.dart';

import 'game/game.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  double xAlign = 0.0;
  double yAlign = 1.0;
  double opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    var upTween = Tween<double>(begin: 1, end: -1);
    var downTween = Tween<double>(begin: -1, end: 0);
    var rightTween = Tween<double>(begin: 0, end: 1.5);

    Animation upAnimation = upTween.animate(CurveTween(
      curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn),
    ).animate(_controller));

    Animation downAnimation = downTween.animate(CurveTween(
      curve: Interval(0.5, 0.75, curve: Curves.decelerate),
    ).animate(_controller));

    Animation rightAnimation = rightTween.animate(CurveTween(
      curve: Interval(0.75, 1, curve: Curves.easeIn),
    ).animate(_controller));

    _controller.addListener(() {
      double value = _controller.value;
      if (value <= 0.5) {
        setState(() {
          yAlign = upAnimation.value;
        });
      } else if (value <= 0.75) {
        setState(() {
          yAlign = downAnimation.value;
          opacity = 1.0;
        });
      } else {
        setState(() {
          xAlign = rightAnimation.value;
        });
      }
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Game(),
          ),
        );
      }
    });

    //当页面展示完全后再运行动画
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(Duration(milliseconds: 500), () {
        _controller.forward();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ClipRect(
          child: Align(
            widthFactor: 1.0,
            child: Container(
              width: 400.0,
              height: 200.0,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment(xAlign, yAlign),
                    child: DinosaurWidget(50, 50),
                  ),
                  Align(
                    alignment: Alignment(0, 0.2),
                    child: AnimatedOpacity(
                      opacity: opacity,
                      duration: Duration(milliseconds: 1000),
                      child: Container(
                        height: 0.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
