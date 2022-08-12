import 'package:flutter/material.dart';

class PlayerWidget extends StatefulWidget {
  const PlayerWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: Colors.black),
      home: Scaffold(
        body: const Text("Player"),
      ),
    );
  }
}
