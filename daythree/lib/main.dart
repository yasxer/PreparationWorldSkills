import 'package:daythree/screens/home.dart';
import 'package:flutter/material.dart';
void main(){
  runApp(const GoSkinng());
}
class GoSkinng extends StatelessWidget {
  const GoSkinng({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
