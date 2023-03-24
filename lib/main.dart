import 'package:flutter/material.dart';

import 'chat.dart';

void main() {
  runApp(MyApp());
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/images/logo-comwork.png'),
        centerTitle: false,
        title: Text(
          'CWAI Chat',
          textAlign: TextAlign.left
        ),
        backgroundColor: Color(0xFF114575)
      ),
      body: Column(
        children: [
          ChatComponent(),
        ],
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CWAI Chat',
      home: Home(),
    );
  }
}
