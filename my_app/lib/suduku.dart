import 'dart:math';

import 'package:flutter/material.dart';

class sudukuPage extends StatefulWidget {
  sudukuPage({Key key, @required this.title}) : super(key: key);
  String title;
  @override
  _sudukuPageState createState() => _sudukuPageState();
}

class _sudukuPageState extends State<sudukuPage> {
  // 界面大小初始化
  double screenWidth = 0;
  double screenHeight = 0;
  double safeTop = 0;
  double safeBottom = 0;

  // 界面状态 0 - 准备阶段 1 - 进行中
  int pageState = 0;

  // 生成了结果数组
  List gameList = [];

  // 展示的数组
  List showGameList = [];

  // 输入的数组
  List inputGameList = [];

  // 输入数字了
  inputNumber(String text) {}

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    safeTop = MediaQuery.of(context).padding.top;
    safeBottom = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.red,
      ),
      backgroundColor: Color(0xffeeeeee),
      body: Center(
        child: buildChildElement(),
      ),
    );
  }

  // 统一返回固定的控件
  Widget buildChildElement() {
    if (pageState == 0 || pageState == 2) {
      return getStayByView();
    } else if (pageState == 1) {
      return getGameView();
    } else if (pageState == 3) {}
  }

  // 返回准备开始的界面
  Widget getStayByView() {
    var buttonText = '';
    if (pageState == 0) {
      buttonText = '开始';
    } else if (pageState == 2) {
      buttonText = '继续';
    }
    return Center(
        child: Container(
      width: screenWidth / 3 * 2,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.pink),
      ),
      child: FlatButton(
        onPressed: () {
          if (pageState == 0) {
            gameList = generatePuzzleMatrix();
            configShowGameList();
            printNumbers(gameList);
            printNumbers(showGameList);
            setState(() {
              pageState = 1;
            });
          } else if (pageState == 2) {
            setState(() {
              pageState = 1;
            });
          }
        },
        child: Text(
          buttonText,
          style: TextStyle(
            color: Colors.pink,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ));
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
      decoration: BoxDecoration(
        color: Color(0xffffffff)
      ),
      child: Wrap(
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
          child: getSubWrapView(resource),
        ));
      }
    }
    return widgetList;
  }

  // 返回小组
  Widget getSubWrapView(List numbers) {
    List<Widget> widgets = [];
    for (int i = 0; i < numbers.length; i++) {
      widgets.add(getItem(numbers[i]));
    }
    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      children: widgets,
    );
  }

  // 创建单个item
  Widget getItem(int number) {
    return Container(
      width: screenWidth / 9 - 1,
      height: screenWidth / 9 - 1,
      color: Color(0xffeeeeee), //number > 5 ? Colors.red : Colors.blue
      child: Center(
        child: Text(
          number == 0 ? '' : number.toString(),
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
      '重来',
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
        onPressed: () {
          inputNumber(text);
        },
        child: Text(text),
      ),
    );
  }

  printNumbers(List grids) {
    for (int i = 0; i < 9; i++) {
      if (i % 3 == 0) {
        print('-----------------------------------------');
      }
      String printString = '';
      for (int j = 0; j < 9; j++) {
        if (j % 3 == 0) {
          printString = printString + '|';
        }
        printString =
            printString + (grids[i][j] == 0 ? '' : (grids[i][j]).toString());
        printString = printString + '   ';
      }
      printString = printString + '|';
      print(printString);
    }
    print('-----------------------------------------');
  }

  // 生成显示的数组
  configShowGameList() {
    List randomMatrix = List();
    for (int i = 0; i < 9; i++) {
      List tempList = [];
      for (int j = 0; j < 9; j++) {
        tempList.add(0);
      }
      randomMatrix.add(tempList);
    }
    showGameList = randomMatrix;
    // 随机生成一个 10 - 20 区间的数字
    int randomNumber = Random().nextInt(10) + 10;
    for (int i = 0; i < randomNumber; i++) {
      // 生成这次需要显示的的二维地址
      int x = Random().nextInt(8) + 1;
      int y = Random().nextInt(8) + 1;
      showGameList[x][y] = gameList[x][y];
    }
  }

  // 设置阈值
  int maxCount = 220;

  // 记录当前调用次数
  int currentTimes = 0;

  // 生成原始数独数据
  List generatePuzzleMatrix() {
    List randomMatrix = List();
    for (int i = 0; i < 9; i++) {
      List tempList = [];
      for (int j = 0; j < 9; j++) {
        tempList.add(0);
      }
      randomMatrix.add(tempList);
    }
    for (int row = 0; row < 9; row++) {
      if (row == 0) {
        currentTimes = 0;
        randomMatrix[row] = buildRandomArray();
      } else {
        List tempRandomArray = buildRandomArray();
        for (int col = 0; col < 9; col++) {
          if (currentTimes < maxCount) {
            if (!isCandidateNmbFound(randomMatrix, tempRandomArray, row, col)) {
              resetValuesInRowToZero(randomMatrix, row);
              row = -1;
              col = 8;
              tempRandomArray = buildRandomArray();
            }
          } else {
            row = -1;
            col = 8;
            resetValuesToZeros(randomMatrix);
            currentTimes = 0;
          }
        }
      }
    }
    return randomMatrix;
  }

  resetValuesInRowToZero(List matrix, int row) {
    for (int j = 0; j < 9; j++) {
      matrix[row][j] = 0;
    }
  }

  resetValuesToZeros(List matrix) {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        matrix[row][col] = 0;
      }
    }
  }

  bool isCandidateNmbFound(
      List randomMatrix, List randomArray, int row, int col) {
    for (int i = 0; i < randomArray.length; i++) {
      randomMatrix[row][col] = randomArray[i];
      if (noConflict(randomMatrix, row, col)) {
        return true;
      }
    }
    return false;
  }

  bool noConflict(List candidateMatrix, int row, int col) {
    return noConflictInRow(candidateMatrix, row, col) &&
        noConflictInColumn(candidateMatrix, row, col) &&
        noConflictInBlock(candidateMatrix, row, col);
  }

  bool noConflictInRow(List candidateMatrix, int row, int col) {
    int currentValue = candidateMatrix[row][col];
    for (int colNum = 0; colNum < col; colNum++) {
      if (currentValue == candidateMatrix[row][colNum]) {
        return false;
      }
    }
    return true;
  }

  bool noConflictInColumn(List candidateMatrix, int row, int col) {
    int currentValue = candidateMatrix[row][col];
    for (int rowNum = 0; rowNum < row; rowNum++) {
      if (currentValue == candidateMatrix[rowNum][col]) {
        return false;
      }
    }
    return true;
  }

  bool noConflictInBlock(List candidateMatrix, int row, int col) {
    int baseRow = (row / 3).toInt() * 3;
    int baseCol = (col / 3).toInt() * 3;
    for (int rowNum = 0; rowNum < 8; rowNum++) {
      if (candidateMatrix[(baseRow + rowNum / 3).toInt()]
              [baseCol + rowNum % 3] ==
          0) {
        continue;
      }
      for (int colNum = rowNum + 1; colNum < 9; colNum++) {
        if (candidateMatrix[(baseRow + rowNum / 3).toInt()]
                [baseCol + rowNum % 3] ==
            candidateMatrix[(baseRow + colNum / 3).toInt()]
                [baseCol + colNum % 3]) {
          return false;
        }
      }
    }
    return true;
  }

  // 返回一个有1到9九个数随机排列的一维数组,
  List buildRandomArray() {
    currentTimes++;
    List array = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    int randomInt = 0;
    // 随机产生一个1到8的随机数，使得该下标的数值和下标为0的数值交换，
    // 处理20次，能够获取一个有1到9九个数随机排列的一维数组
    for (int i = 0; i < 20; i++) {
      randomInt = Random().nextInt(8) + 1;
      int temp = array[0];
      array[0] = array[randomInt];
      array[randomInt] = temp;
    }
    return array;
  }
}
