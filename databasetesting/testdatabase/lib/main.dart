import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:testdatabase/home.dart';

void main() {
  runApp(const MainApp());
}

Future<List> connectToDB(int counter) async {
  List<String> items = ['...', '...', '...'];

  print("We're about to make a connection to the DB!");
  var settings = ConnectionSettings(
    host: 'mydatabase.cr8csc4s4i51.eu-north-1.rds.amazonaws.com',
    port: 3306,
    user: 'admin',
    password: 'databasepass',
    db: 'hsk',
  );
  var conn = await MySqlConnection.connect(settings);
  
  var results = await conn.query('select simplified, pinyin_tones, translation from hsk.vocabulary where id = '+ counter.toString());

  for (var row in results) {
  items[0] = row[0];
  items[1] = row[1];
  items[2] = row[2];
  };


  return items;
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
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
        child: Stack(

          children: <Widget>[
            Container(
              child: buildFutureBuilder(),
            ),

         
            Align(
              alignment: Alignment.bottomCenter,
            child: TextButton(
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
            )
            )
          ],
        ),
      ),
    );
  }

  Widget buildFutureBuilder() {
    return FutureBuilder(
      future: connectToDB(count),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("");
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<String> normalList = snapshot.data as List<String>;

          return Container(
            child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: <Widget>[
                Text(
                  normalList[0],
                  style: TextStyle(
                    color: Color.fromARGB(255, 212, 184, 4),
                    fontSize: 50,
                  ),
                ),
                Text(
                  normalList[1],
                  style: TextStyle(
                    color: Color.fromARGB(255, 212, 184, 4),
                    fontSize: 50,
                  ),
                ),
                Text(
                  normalList[2],
                  style: TextStyle(
                    color: Color.fromARGB(255, 212, 184, 4),
                    fontSize: 50,
                  ),
                ),
              ],
            ),
            )
          );
        }
      },
    );
  }
}
