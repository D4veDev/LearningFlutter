import 'dart:io';
import 'package:flutter/material.dart';
import 'package:testdatabase/main.dart';

class HomePage extends StatefulWidget {
  // It is essential to give the class a key and make it constant
  const HomePage({Key? key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/back.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              child: Align(
                alignment: Alignment.center,
                child: IconButton(
                icon: Image.asset('assets/images/start.png'),
                iconSize: 10,
                onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const LandingPage()));},
              )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
