import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lettuce_sudoku/util/helpers.dart';
import 'package:lettuce_sudoku/util/globals.dart';
import 'SudokuScreen.dart';

class LoadingScreen extends StatefulWidget {
  LoadingScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _asyncInitState();
  }

  Future<bool> _asyncInitState() async {
    readFromPrefs().then((value) async {
      problem = await getNextGame();
      applyGameState();
    });

    SudokuScreen game = SudokuScreen();
    Timer(Duration(seconds: 0), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => game));
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
