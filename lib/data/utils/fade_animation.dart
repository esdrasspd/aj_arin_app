import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  const FadeAnimation(this.delay, this.child, {super.key});

  @override
  Widget build(BuildContext context) {
    final tween = MovieTween()
      ..tween('opacity', Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 500))
      ..tween('translateX', Tween(begin: 120.0, end: 0.0),
          duration: const Duration(milliseconds: 500), curve: Curves.easeOut);

    return CustomAnimationBuilder<Movie>(
      control: Control.play,
      tween: tween,
      duration: tween.duration,
      delay: Duration(milliseconds: (500 * delay).round()),
      builder: (context, animation, child) {
        return Opacity(
          opacity: animation.get('opacity'),
          child: Transform.translate(
            offset: Offset(animation.get('translateX'), 0),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
