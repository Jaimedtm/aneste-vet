import 'package:flutter/material.dart';

class SlidePageRoute extends PageRouteBuilder {
  SlidePageRoute(Widget widget)
      : super(
          transitionDuration: Duration(milliseconds: 800),
          pageBuilder: (context, animation, secondaryAnimation) => widget,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            animation =
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
            return SlideTransition(
              position: Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
                  .animate(animation),
              child: child,
            );
          },
        );
}

class FadePageRoute extends PageRouteBuilder {
  FadePageRoute(Widget widget)
      : super(
          transitionDuration: Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) => widget,
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
