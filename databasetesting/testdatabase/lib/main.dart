import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

void main() {
  runApp(const MainApp());
}

Future<List> connectToDB() async {
  List<String> hanzipinyin = [];

  print("We're about to make a connection to the DB!");
  var settings = ConnectionSettings(
    host: 'mydatabase.cr8csc4s4i51.eu-north-1.rds.amazonaws.com',
    port: 3306,
    user: 'admin',
    password: 'databasepass',
    db: 'hsk',
  );
  var conn = await MySqlConnection.connect(settings);
  var results = await conn.query('select * from hsk.vocabulary');

  for (var row in results) {
    print('Hanzi: ${row[1]}, Pinyin: ${row[4]}');
    hanzipinyin.add(row[1]);
    hanzipinyin.add(row[4]);
  }
  print('We have made contact');
  return hanzipinyin;
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Container(decoration: new BoxDecoration(color: Color.fromARGB(255, 118, 34, 29))),
            Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            child: buildFutureBuilder()
            ),
            TextButton(
           child: const Text(
                "Text Button",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold
                ),
              ),
              onPressed: () {print("you hit that button!");},
            )
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
          List<String> normalList = snapshot.data as List<String>;
          return Text(
            normalList[1],
            style: TextStyle(
              color: Color.fromARGB(255, 212, 184, 4),
              fontSize: 25,
            ),
          );
        }
      },
    );
  }
}
