import 'package:flutter/widgets.dart';

class FadeSlideTransition extends StatefulWidget {
  final Widget child;
  final Key key;

  const FadeSlideTransition({this.key,this.child}) : super(key: key);

  @override
  State<StatefulWidget> createState() => FadeSlideTransitionState();
}

class FadeSlideTransitionState extends State<FadeSlideTransition>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  FadeSlideTransitionState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {

    final slideTween = Tween<Offset>(begin: Offset(0.15, 0), end: Offset.zero)
        .animate(_animationController);
    final fadeTween =
        Tween<double>(begin: 0, end: 1).animate(_animationController);

    return SlideTransition(
        position: slideTween,
        child: FadeTransition(opacity: fadeTween, child: widget.child));
  }
}
