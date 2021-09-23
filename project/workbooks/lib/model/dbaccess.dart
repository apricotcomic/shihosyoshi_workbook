import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart'; // WidgetsFlueetBindingを使うときimportする
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class Question {
  final int id; // 連番
  final String questiontext; // 問題文
  final int correct; // 正解番号

  Question(
      {required this.id, required this.questiontext, required this.correct});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'questiontext': questiontext,
      'correct': correct,
    };
  }

  static Future<Database> get database async {
    WidgetsFlutterBinding
        .ensureInitialized(); // Flutter Engineの機能をCALLする際は、事前にこれを発行
    // database open
    final Future<Database> _database = openDatabase(
      join(await getDatabasesPath(), 'test.db'),
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE question (id	INTEGER,questiontext	TEXT,correct	INTEGER)');
      },
      version: 1,
    );
    return _database;
  }

  static Future<void> insertData(Question question) async {
    final db = await database;
    //var question = loadJsonAsset();
    await db.insert(
      'question',
      question.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Question>> search() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('question');

    return List.generate(maps.length, (i) {
      return Question(
        id: maps[i]['id'],
        questiontext: maps[i]['questiontext'],
        correct: maps[i]['correct'],
      );
    });
  }

  static Future<List<Question>> loadJsonAsset() async {
    String loadData = await rootBundle.loadString('assets/question.json');
    final List<dynamic> questionDatas = json.decode(loadData);
    //final questionDatas =
    //    loadData.map((dynamic item) => Article.fromJson(item)).toList;

    return List.generate(questionDatas.length, (i) {
      return Question(
        id: questionDatas[i]['id'],
        questiontext: questionDatas[i]['question'],
        correct: questionDatas[i]['anser'],
      );
    });
  }
}
