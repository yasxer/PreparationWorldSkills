import 'package:day2/core/route.dart';
import 'package:flutter/material.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.game);
          },
          child: Text('data', style: Theme.of(context).textTheme.headlineLarge),
        ),
      ),
    );
  }
}
