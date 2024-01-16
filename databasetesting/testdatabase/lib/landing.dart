import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';


void main() {
  runApp(const MainApp());
}
Future<List> connectToDB() async{

  List<String> hanzipinyin = [];

  print("we're about to make a connection to the DB!");
  var settings = new ConnectionSettings(
    host: 'mydatabase.cr8csc4s4i51.eu-north-1.rds.amazonaws.com', 
    port: 3306,
    user: 'admin',
    password: 'databasepass',
    db: 'hsk'
  );
  var conn = await MySqlConnection.connect(settings);
  var results = await conn.query('select * from hsk.vocabulary');

  for (var row in results) {
  print('Hanzi: ${row[1]}, Pinyin: ${row[4]}');
  hanzipinyin.add(row[1]);
  hanzipinyin.add(row[4]);
  }
  print('we have made contact');
  return hanzipinyin;
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LandingPage()
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({ super.key });

  @override
  State<LandingPage> createState() => _LandingPage();
}

class _LandingPage extends State<LandingPage> {

  @override


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
          print(normalList);
          return Text(normalList[1]);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: Column(
      children: <Widget>[
        Container(child:buildFutureBuilder()),
      ],
    ));

  }
}