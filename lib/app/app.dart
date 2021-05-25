import 'package:flutter/material.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clothes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Material(
        child: Center(
          child: Text('Hello world!'),
        ),
      ),
    );
  }
}
