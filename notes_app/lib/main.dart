import 'package:flutter/material.dart';
import 'package:notes_app/adding_note.dart';
import 'homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      debugShowCheckedModeBanner: false,
      home:  const MyHomePage(),
      routes: {
        "adding_note" :(context) => const AddingNote(id:-1,edit: false),
        "home" :(context) => const MyHomePage(),
      },
    );
  }
}


