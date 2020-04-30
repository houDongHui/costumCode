import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class guessNumberPage extends StatefulWidget {
  guessNumberPage({Key key, @required this.title}) : super(key: key);

  String title;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return guessNumberPageState();
  }
}

class guessNumberPageState extends State<guessNumberPage> {
  // 界面大小初始化
  double screenWidth = 0;
  double screenHeight = 0;
  double safeTop = 0;
  double safeBottom = 0;

  // 记录一个最终的数字
  int gameNumber = 0;

  // 用于判断当前的状态 0 - 准备 1 - 开始 2 - 暂停 3 - 装逼成功
  int pageState = 0;

  // 游戏进行的状态 0 - 空闲 1 - 完蛋
  int gameState = 0;

  // 已经输入的数字集合
  var inputNumbers = [];

  // 输入的数字
  String inputNum = '----';

  // 胜利后的倒计时
  Timer countDownTimer;

  // 消失
  @override
  void dispose() {
    if (countDownTimer != null) {
      countDownTimer.cancel();
      countDownTimer = null;
    }
    super.dispose();
  }

  // 主要：生成一个数字
  randomGameNumber() {
    String alphaString = '0123456789';
    int length = 4;
    String res = '';
    while (res.length != length) {
      String tempString = alphaString[Random().nextInt(alphaString.length)];
      if (res.length == 0 && tempString == '0') {
        break;
      }
      if (!res.contains(tempString)) {
        res = res + tempString;
      }
    }
    if (res.length != 4) {
      randomGameNumber();
    } else {
      gameNumber = int.parse(res);
    }
    print(res);
  }

  // 键盘输入的点击方法
  inputNumber(String input) {
    if (input == '重输') {
      setState(() {
        inputNum = '----';
      });
    } else if (input == '删除') {
      if (inputNum.length > 0 && !inputNum.contains('-')) {
        setState(() {
          inputNum = inputNum.substring(0, inputNum.length - 1);
        });
        if (inputNum.length <= 0) {
          setState(() {
            inputNum = '----';
          });
        }
      } else {
        setState(() {
          inputNum = '----';
        });
      }
    } else {
      if (inputNum.indexOf('-') != -1) {
        inputNum = '';
      }
      if (!inputNum.contains(input)) {
        setState(() {
          inputNum = inputNum + input;
        });
      }
      if (inputNum.length == 4 && inputNum.indexOf('-') == -1) {
        seeResult();
      }
    }
  }

  // 校验
  seeResult() {
    print(inputNum);
    // 如果相等，就是胜利了
    if (inputNum == gameNumber.toString()) {
      setState(() {
        pageState = 3;
        gameState = 0;
      });
      startCountDown();
    } else {
      // 查看相差多少然后添加到历史记录
      int countA = 0;
      int countB = 0;
      final inputNumList = inputNum.split('');
      final gameNumList = gameNumber.toString().split('');
      for (var i = 0; i < inputNumList.length; i++) {
        String gameN = gameNumList[i];
        String inputN = inputNumList[i];
        print(gameN + ' ' + inputN);
        if (gameN == inputN) {
          countA += 1;
        } else if (gameNumList.contains(inputN)) {
          countB += 1;
        }
      }
      inputNumbers.add(countA.toString() +
          'A' +
          countB.toString() +
          'B' +
          '                 ' +
          inputNum);
      inputNum = '----';
      setState(() {
        if (inputNumbers.length < 10) {
          gameState = 0;
        } else if (inputNumbers.length >= 10 && pageState != 3) {
          // 装逼失败
          gameState = 1;
          pageState = 3;
        }
      });
      if (gameState == 1) {
        startCountDown();
      }
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
          title: Text(widget.title),
          backgroundColor: Colors.red,
        ),
        backgroundColor: Color(0xffeeeeee),
        body: Center(
          child: buildChildElement(),
        ));
  }

  // 统一返回固定的控件
  Widget buildChildElement() {
    if (pageState == 0 || pageState == 2) {
      return getStayByView();
    } else if (pageState == 1) {
      return getMainView();
    } else if (pageState == 3) {
      return getSuccessView();
    }
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
            randomGameNumber();
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

  // 主要：返回界面
  Widget getMainView() {
    return Container(
      width: screenWidth,
      height: screenHeight,
      child: Column(
        children: <Widget>[
          getMainTopView(),
          getMainCenterView(),
          getMainBottomView()
        ],
      ),
    );
  }

  // 最上面的输入历史
  Widget getMainTopView() {
    return Container(
      width: screenWidth,
      height: screenHeight - 200 - 55 - safeTop - safeBottom - 24,
      child: ListView.builder(
        itemCount: inputNumbers.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 44,
            child: Center(
              child: Text(
                inputNumbers[index],
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // 中间的view
  Widget getMainCenterView() {
    return Container(
      width: screenWidth,
      height: 55,
      color: Colors.orangeAccent,
      child: Center(
        child: Text(
          inputNum,
          style: TextStyle(
            fontSize: 30,
            color: Colors.red,
            fontWeight: FontWeight.bold,
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
      '重输',
      '0',
      '删除'
    ];
    return Container(
      width: screenWidth,
      height: 200,
      color: Color(0xffeaeaea),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              configButton(kayboardNumber[0]),
              configButton(kayboardNumber[1]),
              configButton(kayboardNumber[2])
            ],
          ),
          Row(
            children: <Widget>[
              configButton(kayboardNumber[3]),
              configButton(kayboardNumber[4]),
              configButton(kayboardNumber[5])
            ],
          ),
          Row(
            children: <Widget>[
              configButton(kayboardNumber[6]),
              configButton(kayboardNumber[7]),
              configButton(kayboardNumber[8])
            ],
          ),
          Row(
            children: <Widget>[
              configButton(kayboardNumber[9]),
              configButton(kayboardNumber[10]),
              configButton(kayboardNumber[11])
            ],
          )
        ],
      ),
    );
  }

  // 返回单个按钮
  Widget configButton(String text) {
    return Container(
      width: screenWidth / 3,
      height: 44,
      child: FlatButton(
        onPressed: () {
          inputNumber(text);
        },
        child: Text(text),
      ),
    );
  }

  // 写给装逼成功的人的话
  String message = '尽管你解出来这次的结果，但是不代表你很厉害！要是我媳妇的话，那很棒，如果不是，那你没有我媳妇厉害！！！';
  String failMessage = '哼哼～失败了吧！完蛋！再试一次吧！';
  String tempMessage = '';

  // 定时任务
  startCountDown() {
    inputNumbers = [];
    inputNum = '----';
    gameNumber = 0;
    countDownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      String tempMsg = gameState == 1 ? failMessage : message;
      if (tempMessage.length < tempMsg.length) {
        setState(() {
          tempMessage = tempMsg.substring(0, tempMessage.length + 1);
        });
      } else {
        countDownTimer.cancel();
        countDownTimer = null;
        countDownTimer = Timer(Duration(seconds: 3), () {
          countDownTimer.cancel();
          countDownTimer = null;
          tempMessage = '';
          setState(() {
            pageState = 0;
          });
        });
      }
    });
  }

  // 返回装逼成功界面
  Widget getSuccessView() {
    return Center(
      child: Text(
        tempMessage,
        style: TextStyle(
          color: gameState == 1 ? Colors.red : Colors.blue,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
