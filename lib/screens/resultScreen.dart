import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  static const routeName = '/resultScreen';
  // todo: show multiple faces 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Result"),
      ),
      body: Center(
        child: Text("RESULTS"),
      ),
    );
  }
}
