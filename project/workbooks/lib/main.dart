import 'package:flutter/material.dart';
import 'package:workbooks/model/dbaccess.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workbook',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Workbook Question Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _question = '問１　この中で柴犬はどれ？\n\n1.いちごう\n2.こなつ\n3.とび\n4.どら\n5.めちゃ';
  List<Question> _data = [];
  int _counter = 0;

  Future<void> initData() async {
    var _data = await Question.loadJsonAsset();

    _data.forEach((d) {
      Question.insertData(d);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: FutureBuilder(
          future: initData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // 非同期処理未完了 = 通信中
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: _data.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        _data[_counter].questiontext,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            ElevatedButton(
                                onPressed: () {}, child: const Text('1')),
                            ElevatedButton(
                                onPressed: () {}, child: const Text('2')),
                            ElevatedButton(
                                onPressed: () {}, child: const Text('3')),
                            ElevatedButton(
                                onPressed: () {}, child: const Text('4')),
                            ElevatedButton(
                                onPressed: () {}, child: const Text('5')),
                          ],
                        )
                      )
                    ],
                  ),
                );
              });
          }),
        )
      );
  }
}
