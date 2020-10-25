import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

Future<List<String>> _getAssetsFile() async {
  final directory = await getApplicationDocumentsDirectory();
  final path = p.join(directory.path, 'calendar.ics');
  final data = await rootBundle.load('assets/calendar.ics');
  final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  final file = await File(path).writeAsBytes(bytes);
  return file.readAsLines();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<List<String>>(
          future: _getAssetsFile(),
          builder: (_, snapshot) {
            if (!snapshot.hasData)
              return const Center(child: CircularProgressIndicator());
            final iCalendar = ICalendar.fromLines(snapshot.data);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('${iCalendar?.toString()}'),
              ],
            );
          },
        ),
      ),
    );
  }
}
