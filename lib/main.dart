import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

class Student {
  String studentId;
  String studentName;
  int studentScores;

  Student({this.studentId, this.studentName, this.studentScores});

  factory Student.fromJson(Map<String, dynamic> parsedJson) {
    return Student(
        studentId: parsedJson['id'],
        studentName: parsedJson['name'],
        studentScores: parsedJson['score']);
  }
}

Future<String> _loadAStudentAsset() async {
  return await rootBundle.loadString('assets/student.json');
}

Future<Student> loadStudent() async {
  await wait(5);
  String jsonString = await _loadAStudentAsset();
  final jsonResponse = json.decode(jsonString);
  return new Student.fromJson(jsonResponse);
}

Future wait(int seconds) {
  return new Future.delayed(Duration(seconds: seconds), () => {});
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp();
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  Widget futureWidget() {
    return new FutureBuilder<Student>(
      future: loadStudent(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return new Container(
              padding: new EdgeInsets.all(20.0),
              child: new Row(
                children: <Widget>[
                  Text(
                      "Hi ${snapshot.data.studentName} your id is ${snapshot.data.studentId} and score ${snapshot.data.studentScores} ")
                ],
              ));
        } else if (snapshot.hasError) {
          return new Text("${snapshot.error}");
        }
        return new CircularProgressIndicator();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
            title: new Text('Load Json'),
          ),
          body: futureWidget()
    )
    );
  }
}
