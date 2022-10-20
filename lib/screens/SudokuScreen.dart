import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lettuce_sudoku/util/CustomStyles.dart';
import 'package:lettuce_sudoku/util/globals.dart';
import 'package:lettuce_sudoku/util/helpers.dart';

class SudokuScreen extends StatefulWidget {
  SudokuScreen({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _SudokuScreenState createState() => _SudokuScreenState();
}

class _SudokuScreenState extends State<SudokuScreen> {
  FocusNode focusNode = FocusNode();
  late var _actionMap;

  late List<Widget> _sudokuGrid;
  late List<Widget> _moveGrid;
  bool canClickNewGame = true;

  @override
  void initState() {
    super.initState();
    _populateGridList();
    _populateMoveGrid();
    _actionMap = {
      // Move Down//
      LogicalKeyboardKey.arrowDown: () {
        _shiftFocus(1, 0);
      },
      LogicalKeyboardKey.keyS: () {
        _shiftFocus(1, 0);
      },

      // Move Left
      LogicalKeyboardKey.arrowLeft: () {
        _shiftFocus(0, -1);
      },
      LogicalKeyboardKey.keyA: () {
        _shiftFocus(0, -1);
      },

      // Move Right
      LogicalKeyboardKey.arrowRight: () {
        _shiftFocus(0, 1);
      },
      LogicalKeyboardKey.keyD: () {
        _shiftFocus(0, 1);
      },

      // Move Up
      LogicalKeyboardKey.arrowUp: () {
        _shiftFocus(-1, 0);
      },
      LogicalKeyboardKey.keyW: () {
        _shiftFocus(-1, 0);
      },

      // Place 0 / Delete number from cell
      LogicalKeyboardKey.digit0: () =>
          _doMoveAndApply(0, selectedRow, selectedCol),
      LogicalKeyboardKey.numpad0: () =>
          _doMoveAndApply(0, selectedRow, selectedCol),
      LogicalKeyboardKey.keyX: () =>
          _doMoveAndApply(0, selectedRow, selectedCol),
      LogicalKeyboardKey.delete: () =>
          _doMoveAndApply(0, selectedRow, selectedCol),

      // Place 1
      LogicalKeyboardKey.digit1: () =>
          _doMoveAndApply(1, selectedRow, selectedCol),
      LogicalKeyboardKey.numpad1: () =>
          _doMoveAndApply(1, selectedRow, selectedCol),

      // Place 2
      LogicalKeyboardKey.digit2: () =>
          _doMoveAndApply(2, selectedRow, selectedCol),
      LogicalKeyboardKey.numpad2: () =>
          _doMoveAndApply(2, selectedRow, selectedCol),

      // Place 3
      LogicalKeyboardKey.digit3: () =>
          _doMoveAndApply(3, selectedRow, selectedCol),
      LogicalKeyboardKey.numpad3: () =>
          _doMoveAndApply(3, selectedRow, selectedCol),

      // Place 4
      LogicalKeyboardKey.digit4: () =>
          _doMoveAndApply(4, selectedRow, selectedCol),
      LogicalKeyboardKey.numpad4: () =>
          _doMoveAndApply(4, selectedRow, selectedCol),

      // Place 5
      LogicalKeyboardKey.digit5: () =>
          _doMoveAndApply(5, selectedRow, selectedCol),
      LogicalKeyboardKey.numpad5: () =>
          _doMoveAndApply(5, selectedRow, selectedCol),

      // Place 6
      LogicalKeyboardKey.digit6: () =>
          _doMoveAndApply(6, selectedRow, selectedCol),
      LogicalKeyboardKey.numpad6: () =>
          _doMoveAndApply(6, selectedRow, selectedCol),

      // Place 7
      LogicalKeyboardKey.digit7: () =>
          _doMoveAndApply(7, selectedRow, selectedCol),
      LogicalKeyboardKey.numpad7: () =>
          _doMoveAndApply(7, selectedRow, selectedCol),

      // Place 8
      LogicalKeyboardKey.digit8: () =>
          _doMoveAndApply(8, selectedRow, selectedCol),
      LogicalKeyboardKey.numpad8: () =>
          _doMoveAndApply(8, selectedRow, selectedCol),

      // Place 9
      LogicalKeyboardKey.digit9: () =>
          _doMoveAndApply(9, selectedRow, selectedCol),
      LogicalKeyboardKey.numpad9: () =>
          _doMoveAndApply(9, selectedRow, selectedCol),

      // Get Hint
      LogicalKeyboardKey.keyH: () =>
          _doMoveAndApply(10, selectedRow, selectedCol),
    };
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(focusNode);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          ' Sudoku',
          textAlign: TextAlign.left,
          style: CustomStyles.titleText,
        ),
      ),
      body: RawKeyboardListener(
        autofocus: true,
        focusNode: focusNode,
        onKey: (event) {
          if (event.runtimeType == RawKeyDownEvent) {
            Function action = _actionMap[event.data.logicalKey] ?? () {};
            action();
          }
        },
        child: Container(
          padding: EdgeInsets.all(bodySpacing),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(child: Container()),
              Container(
                width: getBodyWidth(context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      flex: 15,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9.0),
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _sudokuGrid.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: problem.boardSize),
                              itemBuilder: (BuildContext context, int index) =>
                                  _sudokuGrid[index],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 6,
                      child: AspectRatio(
                        aspectRatio: 5 / 2,
                        child: Container(
                          padding: EdgeInsets.all(2),
                          child: GridView.builder(
                            itemCount: _moveGrid.length,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 5,
                                    mainAxisSpacing: 4,
                                    crossAxisSpacing: 4),
                            itemBuilder: (BuildContext context, int index) =>
                                _moveGrid[index],
                          ),
                        ),
                      ),
                    ),

                    // زر الرفرش
                    Flexible(
                      flex: 3,
                      child: AspectRatio(
                        aspectRatio: 5,
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Flexible(
                                fit: FlexFit.tight,
                                flex: 3,
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Container(
                                    padding: EdgeInsets.all(2),
                                    child: TextButton(
                                      style: CustomStyles.darkButtonStyle,
                                      child: Center(
                                        child: Text(
                                          'New Game',
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: CustomStyles.nord6,
                                            fontSize: 30,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        _newGameAndSave();
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(child: Container()),
            ],
          ),
        ),
      ),
    );
  }

  void _shiftFocus(int rowOffset, int colOffset) {
    if (cellSelected()) {
      _selectCell((selectedRow + rowOffset) % problem.boardSize,
          (selectedCol + colOffset) % problem.boardSize);
    }
  }

  Future<bool> _newGame() async {
    if (canClickNewGame) {
      canClickNewGame = false;
      problem = await getNextGame();

      setState(
        () {
          _resetBoard();
        },
      );
      canClickNewGame = true;
    }
    return true;
  }

  void _newGameAndSave() async {
    await _newGame();
    saveGame();
  }

  void _resetBoard() {
    setState(() {
      problem.reset();
      resetGlobals();
      _populateGridList();
      saveGame();
    });
  }

  void _doMove(int num, int row, int col) {
    if (!problem.success() && cellSelected() && digitGood(num)) {
      if (!problem.isInitialHint(row, col)) {
        if (num == 10) {
          List finalBoard = problem.finalState.board;
          num = finalBoard[row][col];
        }
        problem.applyMove(num, row, col);
      }
    }
  }

  void _undoMove() {
    if (movesDone.isNotEmpty) {
      Move lastMove = movesDone.removeLast();
      var num = lastMove.oldNum;
      var row = lastMove.row;
      var col = lastMove.col;
      _selectCell(row, col);
      _doMoveAndApply(num, row, col);
      movesDone.removeLast();
    }
  }

  void _doMoveAndApply(int num, int row, int col) {
    setState(
      () {
        var currentBoard = problem.currentState.board;
        _whiteoutBoard(
            currentBoard[selectedRow][selectedCol], selectedRow, selectedCol);
        _doMove(num, row, col);
        movesDone.add(Move(currentBoard[row][col], num, row, col));
        saveGame();
        _updateCells(row, col);
      },
    );
  }

  void _solveGame() {
    setState(
      () {
        problem.solve();
        _populateGridList();
        saveGame();
      },
    );
  }

  void _whiteoutBoard(int num, int row, int col) {
    var currentBoard = problem.currentState.board;
    for (var i = 0; i < problem.boardSize; i++) {
      for (var j = 0; j < problem.boardSize; j++) {
        var sameRow = i == row;
        var sameCol = j == col;
        var sameFloor = i ~/ problem.cellSize == row ~/ problem.cellSize;
        var sameTower = j ~/ problem.cellSize == col ~/ problem.cellSize;
        var sameBlock = sameFloor && sameTower;
        var sameNum = num == currentBoard[i][j] && num != 0;
        if (sameRow || sameCol || sameBlock || sameNum) {
          var index = getIndex(i, j, problem.boardSize);
          _sudokuGrid[index] = _makeBoardButton(index, CustomStyles.nord6);
          setState(() {});
        }
      }
    }
  }

  void _populateGridList() {
    _sudokuGrid = List.generate(problem.boardSize * problem.boardSize, (index) {
      return _makeBoardButton(index,
          getCellColor(index ~/ problem.boardSize, index % problem.boardSize));
    });
  }

  Widget _makeBoardButton(int index, Color color) {
    var row = index ~/ problem.boardSize;
    var col = index % problem.boardSize;
    var currentBoard = problem.currentState.board;
    var cellNum = currentBoard[row][col];
    String toPlace = cellNum == 0 ? '' : cellNum.toString();
    // var splashColor = CustomStyles.nord12;
    var textColor = getTextColor(row, col, problem);
    double textSize = 40;
    var buttonColor = color;
    var radius = Radius.circular(7.0);
    var border = BorderRadius.only(
      topLeft: index == 0 ? radius : Radius.zero,
      topRight: index == problem.boardSize - 1 ? radius : Radius.zero,
      bottomLeft: index == (problem.boardSize - 1) * problem.boardSize
          ? radius
          : Radius.zero,
      bottomRight:
          index == pow(problem.boardSize, 2) - 1 ? radius : Radius.zero,
    );
    return Container(
      padding: getBoardPadding(index),
      child: Center(
        child: TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(buttonColor),
            shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: border)),
            // overlayColor: MaterialStateProperty.all(splashColor),
          ),
          onPressed: () {
            _selectCell(row, col);
          },
          child: Center(
            child: AutoSizeText(
              toPlace,
              textAlign: TextAlign.center,
              maxLines: 1,
              stepGranularity: 1,
              minFontSize: 18,
              maxFontSize: textSize,
              style: TextStyle(
                color: textColor,
                fontSize: textSize,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _selectCell(int row, int col) {
    setState(
      () {
        var currentBoard = problem.currentState.board;
        if (cellSelected()) {
          var num = currentBoard[selectedRow][selectedCol];
          _whiteoutBoard(num, selectedRow, selectedCol);
        }
        selectedRow = row;
        selectedCol = col;
        if (selectionRadio.value == 1 &&
            selectedNum > -1 &&
            selectedNum <= 10) {
          _doMove(selectedNum, row, col);
        }
        _updateCells(selectedRow, selectedCol);
      },
    );
  }

  void _updateCells(int row, int col) {
    if (!problem.success()) {
      var selected = getIndex(row, col, problem.boardSize);
      _sudokuGrid[selected] = _makeBoardButton(
          getIndex(row, col, problem.boardSize), getCellColor(row, col));
      if (doPeerCells.value) {
        for (var i = 0; i < problem.boardSize; i++) {
          var rowIndex = getIndex(row, i, problem.boardSize);
          _sudokuGrid[rowIndex] =
              _makeBoardButton(rowIndex, getCellColor(row, i));

          var colIndex = getIndex(i, col, problem.boardSize);
          _sudokuGrid[colIndex] =
              _makeBoardButton(colIndex, getCellColor(i, col));

          var blockRow = row ~/ problem.cellSize * problem.cellSize;
          var blockCol = col ~/ problem.cellSize * problem.cellSize;
          var blockIndex = getIndex(blockRow + i ~/ problem.cellSize,
              blockCol + i % problem.cellSize, problem.boardSize);
          _sudokuGrid[blockIndex] = _makeBoardButton(
              blockIndex,
              getCellColor(blockRow + i ~/ problem.cellSize,
                  blockCol + i % problem.cellSize));
        }
      }
      if (doPeerDigits.value) {
        var currentBoard = problem.currentState.board;
        var num = currentBoard[row][col];
        for (var i = 0; i < problem.boardSize; i++) {
          for (var j = 0; j < problem.boardSize; j++) {
            if (currentBoard[i][j] == num && num != 0) {
              var k = getIndex(i, j, problem.boardSize);
              _sudokuGrid[k] = _makeBoardButton(k, getCellColor(i, j));
            }
          }
        }
      }
    } else {
      _populateGridList();
    }
  }

  void _buttonMove(var num) {
    if (selectionRadio.value == 1) {
      selectedNum = num;
    } else {
      _doMoveAndApply(num, selectedRow, selectedCol);
    }
  }

  void _populateMoveGrid() {
    var textColor = CustomStyles.nord6;
    double textSize = 36;
    _moveGrid = List.generate(
      9,
      (index) {
        int num = (index + 1) % (problem.boardSize + 1);
        return TextButton(
          onPressed: () {
            _buttonMove(num);
          },
          style: CustomStyles.darkButtonStyle,
          child: Center(
            child: Text(
              num.toString(),
              textAlign: TextAlign.center,
              maxLines: 1,
              style: TextStyle(
                color: textColor,
                fontSize: textSize,
              ),
            ),
          ),
        );
      },
    );

    _moveGrid.add(TextButton(
      onPressed: () {
        _buttonMove(0);
      },
      style: CustomStyles.darkButtonStyle,
      child: Center(
        child: Icon(
          Icons.clear_sharp,
          size: textSize,
          color: textColor,
        ),
      ),
    ));
  }
}
