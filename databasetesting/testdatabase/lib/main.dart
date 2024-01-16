import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
void main () {
  runApp(const MainApp());
}


Future connectToDB() async{

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
  }
  print('we have made contact');
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});


  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      
    );
  }
}