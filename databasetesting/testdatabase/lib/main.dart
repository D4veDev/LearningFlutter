import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

void main() {
  runApp(const MainApp());
}

Future<List> connectToDB() async {
  List<String> hanzi= [];
  List<String> pinyin= [];
  List<String> translation = [];
  List<List> unifiedList = [];

  print("We're about to make a connection to the DB!");
  var settings = ConnectionSettings(
    host: 'mydatabase.cr8csc4s4i51.eu-north-1.rds.amazonaws.com',
    port: 3306,
    user: 'admin',
    password: 'databasepass',
    db: 'hsk',
  );
  var conn = await MySqlConnection.connect(settings);
  
  var Pinyinresults = await conn.query('select pinyin from hsk.vocabulary');
  var Hanziresults = await conn.query('select simplified from hsk.vocabulary');
  var Translationresults = await conn.query('select simplified from hsk.vocabulary');

  for (var row in Pinyinresults) {
    pinyin.add(row[1]);
  }
  for (var row in Hanziresults) {
    hanzi.add(row[1]);
  }
  for (var row in Translationresults) {
    translation.add(row[1]);
  }

  unifiedList = [hanzi, pinyin, translation];

  return unifiedList;
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LandingPage(),
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key});

  @override
  State<LandingPage> createState() => _LandingPage();
}

class _LandingPage extends State<LandingPage> {
  int count = 0;

  void _incrementCounter() {
    setState(() {
      count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 108, 29, 29),
        title: Text(
          "HANZI BROWSER",
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 25,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.amber,
                backgroundColor: Color.fromARGB(255, 255, 220, 93),
              ),
              child: const Text(
                "ITERATE",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                _incrementCounter();
              },
            ),
            Container(
              child: buildFutureBuilder(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFutureBuilder() {
    return FutureBuilder(
      future: connectToDB(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<List> normalList = snapshot.data as List<List>;
          List hanzi, pinyin, translation;
          hanzi = normalList[0];
          pinyin = normalList[1];
          translation = normalList[2];

          return Container(
            
            child: Column(
              children: <Widget>[
                Text(
                  hanzi[count],
                  style: TextStyle(
                    color: Color.fromARGB(255, 212, 184, 4),
                    fontSize: 50,
                  ),
                ),
                Text(
                  pinyin[count],
                  style: TextStyle(
                    color: Color.fromARGB(255, 212, 184, 4),
                    fontSize: 50,
                  ),
                ),
                Text(
                  translation[count],
                  style: TextStyle(
                    color: Color.fromARGB(255, 212, 184, 4),
                    fontSize: 50,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
