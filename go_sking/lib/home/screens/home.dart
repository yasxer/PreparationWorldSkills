import 'package:flutter/material.dart';
import 'package:go_sking/gamePage/screens/game.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _nameController = TextEditingController();
  @override
  void dispose(){
    _nameController.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    String PlayerName  = '';
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.jpg'),
            fit: BoxFit.cover,
            opacity: 0.7,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Go Skiing',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 50),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(

                  border: OutlineInputBorder(),
                  label: Text('Player name'),
                ),
              ),
            ),
            SizedBox(height: 15),
            Container(
              width: 150,
              height: 50,
              color: Color.fromARGB(255, 156, 211, 249),
              child: TextButton(
                onPressed: () {
                  String PlayerName = _nameController.text.trim();
                  if(PlayerName.isEmpty){
                    showDialog(context: context, builder: (_)=>AlertDialog(content: Text('invalid'),));
                  }else{
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>GamePage(PlayerName: PlayerName)));
                  }
                },
                child: Text(
                  'Start Game',
                  style: TextStyle(color: Colors.black),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Color.fromARGB(255, 156, 211, 249),
                ),
              ),
            ),
            SizedBox(height: 15),
            Container(
              width: 150,
              height: 50,
              color: Color.fromARGB(255, 156, 211, 249),
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Ranking',
                  style: TextStyle(color: Colors.black),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Color.fromARGB(255, 156, 211, 249),
                ),
              ),
            ),
            SizedBox(height: 15),
            Container(
              width: 150,
              height: 50,
              color: Color.fromARGB(255, 156, 211, 249),
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Settings',
                  style: TextStyle(color: Colors.black),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Color.fromARGB(255, 156, 211, 249),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
