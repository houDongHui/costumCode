import 'package:flutter/material.dart';
import 'package:my_app/guessNumber.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: homePage(),
    );
  }
}

class homePage extends StatefulWidget {
  homePage({Key key}) : super(key: key);

  @override
  _homePageState createState() => _homePageState();
}

final menuList = ['猜数字'];

class _homePageState extends State<homePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('列表'),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        itemCount: menuList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              pushToVC(index);
            },
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                width: 1,
                color: Color(0xffeeeeee),
              ))),
              child: Center(
                child: Text(
                  menuList[index],
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // 跳转到指定的控制器
  pushToVC(int index) {
    switch (index) {
      case 0:
        {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return guessNumberPage(
              title: menuList[index],
            );
          }));
        }
        break;
    }
  }
}
