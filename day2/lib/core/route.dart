import 'package:day2/features/game/game.dart';
import 'package:day2/features/home/home.dart';
import 'package:flutter/material.dart';


class AppRoutes{
  static const String home = '/';
  static const String game = '/game';
  static Map<String, WidgetBuilder> get routes{
    return{
      home : (context) => const homePage(),
      game : (context) => const GamePage(),
    };
  }

}
