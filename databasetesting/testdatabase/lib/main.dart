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
                  backgroundColor: Color.fromARGB(255, 255, 220, 93)),
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
              color: Colors.amber,
              margin: EdgeInsetsDirectional.all(10),
              child: buildFutureBuilder()//buildFutureBuilder(),
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
          List<String> normalList = snapshot.data as List<String>;
          return Text(
            normalList[count],
            style: TextStyle(
              color: Color.fromARGB(255, 212, 184, 4),
              fontSize: 50,
            ),
          );
        }
      },
    );
  }
}
