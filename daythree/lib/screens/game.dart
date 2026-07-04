import 'package:flutter/material.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  bool pause = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                IconButton(
                  padding: EdgeInsets.all(10),
                  onPressed: () {
                    setState(() {
                      pause = !pause;
                    });
                  },
                  icon: pause
                      ? Icon(Icons.play_arrow, color: Colors.black, size: 30)
                      : Icon(Icons.pause, color: Colors.black, size: 30),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    spacing: 15,
                    children: [
                      Text(
                          'Player name',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),

                      Row(
                        spacing: 10,
                        children: [
                          Image.asset('assets/coin.png', width: 20),
                          Text(
                            '10',
                            style: TextStyle(
                              color: Color.fromARGB(255, 221, 198, 56),
                            ),
                          ),
                        ],
                      ),
                      Text('10 s'),
                    ],
                  ),
                ),
              ],
            ),
            Transform.rotate(
              angle:  0.3,
              child: Container(
                width: double.infinity,
                color: Colors.white,
                height: 200,
                
              ),
            )
          ],
        ),
      ),
    );
  }
}
