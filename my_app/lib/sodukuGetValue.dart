import 'package:flutter/material.dart';

import 'class.dart';

class sodukuGetValue extends StatefulWidget {
  sodukuGetValue({Key key, this.title}) : super(key: key);
  String title;
  @override
  _sodukuGetValueState createState() => _sodukuGetValueState();
}

class _sodukuGetValueState extends State<sodukuGetValue> {
  // 界面大小初始化
  double screenWidth = 0;
  double screenHeight = 0;
  double safeTop = 0;
  double safeBottom = 0;

  // 表示当前选中的位置
  final location = sudukuLocation(-1, -1);

  // 展示的数组
  List showGameList = [];

  // 保存初始值
  List oGameList = [];

  // 输入数字了
  inputNumber(String text) {
    if (text == '←') {
      int rowX = location.x ~/ 3; // 1
      int rowY = (location.x % 3); // 1
      int indexY = location.y ~/ 3; //
      int indexX = location.y % 3; // 1

      setState(() {
        showGameList[rowY * 3 + indexY][rowX * 3 + indexX] = 0;
      });
    } else {
      int rowX = location.x ~/ 3; // 1
      int rowY = (location.x % 3); // 1
      int indexY = location.y ~/ 3; //
      int indexX = location.y % 3; // 1
      setState(() {
        showGameList[rowY * 3 + indexY][rowX * 3 + indexX] = int.parse(text);
      });
    }
  }

  // 全删除
  longInputNumber(text) {
    showGameList = [];
    oGameList = [];
    for (int i = 0; i < 9; i++) {
      List tempList = [];
      for (int j = 0; j < 9; j++) {
        tempList.add(0);
      }
      setState(() {
        showGameList.add(tempList);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 0; i < 9; i++) {
      List tempList = [];
      for (int j = 0; j < 9; j++) {
        tempList.add(0);
      }
      showGameList.add(tempList);
    }
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    safeTop = MediaQuery.of(context).padding.top;
    safeBottom = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(widget.title),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                getResultNumbers();
              },
              child: Container(
                width: 44,
                height: 44,
                child: Icon(Icons.refresh),
              ))
        ],
      ),
      body: getGameView(),
    );
  }

  // 返回游戏界面
  Widget getGameView() {
    return Container(
      width: screenWidth,
      height: screenHeight - safeTop - 24,
      color: Color(0xffeeeeee),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          getNumberView(),
          getMainBottomView(),
        ],
      ),
    );
  }

  // 返回数字区域
  Widget getNumberView() {
    return Container(
      width: screenWidth,
      height: screenWidth,
      decoration: BoxDecoration(color: Color(0xffffffff)),
      child: Wrap(
        runSpacing: 2,
        runAlignment: WrapAlignment.center,
        alignment: WrapAlignment.spaceEvenly,
        children: buildNumberItem(),
      ),
    );
  }

  // 创建数字方块工厂方法
  List<Widget> buildNumberItem() {
    List<Widget> widgetList = [];
    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        List resource = [];
        for (int rowIndex = row * 3; rowIndex < (row * 3) + 3; rowIndex++) {
          for (int colIndex = col * 3; colIndex < (col * 3) + 3; colIndex++) {
            resource.add(showGameList[rowIndex][colIndex]);
          }
        }
        widgetList.add(Container(
          width: screenWidth / 3 - 2,
          height: screenWidth / 3 - 2,
          child: getSubWrapView(resource, row, col),
        ));
      }
    }
    return widgetList;
  }

  // 返回小组
  Widget getSubWrapView(List numbers, int row, int col) {
    List<Widget> widgets = [];
    for (int i = 0; i < numbers.length; i++) {
      widgets.add(getItem(numbers[i], (3 * col) + row, i));
    }
    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      children: widgets,
    );
  }

  // 创建单个item
  Widget getItem(int number, int row, int col) {
    Color backColor;
    if (oGameList != null && oGameList.length > 0) {
      int rowX = row ~/ 3; // 1
      int rowY = (row % 3); // 1
      int indexY = col ~/ 3; //
      int indexX = col % 3; // 1
      if (oGameList[rowY * 3 + indexY][rowX * 3 + indexX] > 0) {
        backColor = Colors.red;
      } else {
        backColor = Color(0xffeeeeee);
      }
    } else {
      backColor = (location.x == row && location.y == col)
          ? Colors.blue
          : Color(0xffeeeeee);
    }
    return GestureDetector(
      onTap: () {
        print('row' + row.toString() + '_| col' + col.toString());
        setState(() {
          location.x = row;
          location.y = col;
        });
      },
      child: Container(
        width: screenWidth / 9 - 1,
        height: screenWidth / 9 - 1,
        color: Color(0xffeeeeee),
        child: Container(
          color: backColor,
          child: Center(
            child: Text(
              number == 0 ? '' : number.toString(),
              style: TextStyle(
                fontSize: 20,
                color: Color(0xff333333),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 底部的键盘
  Widget getMainBottomView() {
    final kayboardNumber = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '←',
    ];
    return Container(
      width: screenWidth,
      height: screenWidth / 5 * 2,
      color: Color(0xffeaeaea),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              configButton(kayboardNumber[0]),
              configButton(kayboardNumber[1]),
              configButton(kayboardNumber[2]),
              configButton(kayboardNumber[3]),
              configButton(kayboardNumber[4])
            ],
          ),
          Row(
            children: <Widget>[
              configButton(kayboardNumber[5]),
              configButton(kayboardNumber[6]),
              configButton(kayboardNumber[7]),
              configButton(kayboardNumber[8]),
              configButton(kayboardNumber[9])
            ],
          )
        ],
      ),
    );
  }

  // 返回单个按钮
  Widget configButton(String text) {
    return Container(
      width: screenWidth / 5,
      height: screenWidth / 5,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Color(0xffeeeeee),
            width: 1,
          )),
      child: FlatButton(
        onLongPress: () {
          longInputNumber(text);
        },
        onPressed: () {
          inputNumber(text);
        },
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20,
            color: Color(0xff333333),
          ),
        ),
      ),
    );
  }

  int count = 0;

  /// 解题算法，
  getResultNumbers() {
    print(showGameList);
    oGameList = [];
    for (int i = 0; i < showGameList.length; i++) {
      List gameList = showGameList[i];
      List tempList = [];
      for (int j = 0; j < gameList.length; j++) {
        if (showGameList[i][j] > 0) {
          tempList.add(showGameList[i][j]);
        } else {
          tempList.add(0);
        }
      }
      oGameList.add(tempList);
    }
    print(oGameList.toString() + '  ' + oGameList.length.toString());
    bool res = backTrace(showGameList, 0, 0);
    print(res);
    if (res) {
    } else {}
  }

  bool backTrace(List board, int row, int col) {
    setState(() {});
    // print(count);
    count += 1;
    int n = board.length;
    if (col == 9) return backTrace(board, row + 1, 0);
    if (row == n) return true;
    if (board[row][col] != 0) return backTrace(board, row, col + 1);
    for (int c = 1; c <= 9; c++) {
      if (!isValid(board, row, col, c)) continue;
      board[row][col] = c;
      if (backTrace(board, row, col + 1)) return true;
      board[row][col] = 0;
    }
    return false;
  }

  bool isValid(List board, int row, int col, int c) {
    for (int k = 0; k < 9; k++) {
      if (board[row][k] == c) return false;
      if (board[k][col] == c) return false;
      if (board[(row ~/ 3) * 3 + k ~/ 3][(col ~/ 3) * 3 + k % 3] == c)
        return false;
    }
    return true;
  }

  // int n = 3;
  // int N = 9;
  // List rows;
  // List columns;
  // List boxes;

  // List board;

  // bool sudokuSolved = false;

  // getResultNumbers() {
  //   // 初始化list
  //   board = [];
  //   rows = [];
  //   columns = [];
  //   boxes = [];
  //   for (int i = 0; i < showGameList.length; i++) {
  //     List tempList = showGameList[i];
  //     List setList = List();
  //     for (int j = 0; j < tempList.length; j++) {
  //       setList.add(tempList[j]);
  //     }
  //     board.add(setList);
  //   }
  //   for (int i = 0; i < N; i++) {
  //     List tempList = [];
  //     for (int j = 0; j < N + 1; j++) {
  //       tempList.add(0);
  //     }
  //     rows.add(List.from(tempList));
  //     columns.add(List.from(tempList));
  //     boxes.add(List.from(tempList));
  //   }

  //   for (int i = 0; i < N; i++) {
  //     for (int j = 0; j < N; j++) {
  //       final num = board[i][j];
  //       if (num != '0') {
  //         int d = num;
  //         placeNumber(d, i, j);
  //       }
  //     }
  //   }
  //   backtrack(0, 0);
  //   print(board);
  // }

  // bool couldPlace(int d, int row, int col) {
  //   int idx = ((row / n) * n + col / n).toInt();
  //   return rows[row][d] + columns[col][d] + boxes[idx][d] == 0;
  // }

  // placeNumber(int d, int row, int col) {
  //   int idx = ((row ~/ n) * n + col ~/ n);
  //   rows[row][d]++;
  //   columns[col][d]++;
  //   boxes[idx][d]++;
  //   board[row][col] = d + 0;
  // }

  // removeNumber(int d, int row, int col) {
  //   int idx = ((row / n) * n + col / n).toInt();
  //   rows[row][d]--;
  //   columns[col][d]--;
  //   boxes[idx][d]--;
  //   board[row][col] = 0;
  // }

  // placeNextNumbers(int row, int col) {
  //   if ((col == N - 1) && (row == N - 1)) {
  //     sudokuSolved = true;
  //   } else {
  //     if (col == N - 1)
  //       backtrack(row + 1, 0);
  //     else
  //       backtrack(row, col + 1);
  //   }
  // }

  // backtrack(int row, int col) {
  //   if (board[row][col] == 0) {
  //     for (int d = 1; d < 10; d++) {
  //       if (couldPlace(d, row, col)) {
  //         placeNumber(d, row, col);
  //         placeNextNumbers(row, col);
  //         if (!sudokuSolved) removeNumber(d, row, col);
  //       }
  //     }
  //   } else {
  //     placeNextNumbers(row, col);
  //   }
  // }
}
