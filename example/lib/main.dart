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

class _MyHomePageState extends State<MyHomePage> {
  ICalendar _iCalendar;
  bool _isLoading = false;

  Future<void> _getAssetsFile(String assetName) async {
    setState(() => _isLoading = true);
    try {
      final directory = await getTemporaryDirectory();
      final path = p.join(directory.path, assetName);
      final data = await rootBundle.load('assets/$assetName');
      final bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      final file = await File(path).writeAsBytes(bytes);
      final lines = await file.readAsLines();
      setState(() {
        _iCalendar = ICalendar.fromLines(lines);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      throw 'Error: $e';
    }
  }

  Widget _generateTextContent() {
    final style = const TextStyle(color: Colors.black);
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
              text: 'VERSION: ${_iCalendar.version}\n',
              style: style.copyWith(fontWeight: FontWeight.bold)),
          TextSpan(
              text: 'PRODID: ${_iCalendar.prodid}\n',
              style: style.copyWith(fontWeight: FontWeight.bold)),
          TextSpan(
              text: 'CALSCALE: ${_iCalendar.calscale}\n',
              style: style.copyWith(fontWeight: FontWeight.bold)),
          TextSpan(
              text: 'METHOD: ${_iCalendar.method}\n',
              style: style.copyWith(fontWeight: FontWeight.bold)),
          TextSpan(
              children: _iCalendar.data
                  .map((e) => TextSpan(
                        children: e.keys
                            .map((f) => TextSpan(children: [
                                  TextSpan(
                                      text: '${f.toUpperCase()}: ',
                                      style: style.copyWith(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(text: '${e[f]}\n')
                                ]))
                            .toList(),
                      ))
                  .toList()),
        ],
        style: style,
      ),
    );
  }

  Future<void> _getAssets(String assetName) async {
    setState(() => _isLoading = true);
    try {
      final icsString = await rootBundle.loadString('assets/$assetName');
      final iCalendar = ICalendar.fromString(icsString);
      setState(() {
        _iCalendar = iCalendar;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      throw 'Error: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_isLoading || _iCalendar == null)
              const Center(child: CircularProgressIndicator())
            else
              _generateTextContent(),
            ElevatedButton(
              onPressed: () => _getAssetsFile('calendar.ics'),
              child: const Text('Load File 1'),
            ),
            ElevatedButton(
              onPressed: () => _getAssetsFile('calendar2.ics'),
              child: const Text('Load File 2'),
            ),
            ElevatedButton(
              onPressed: () => _getAssets('calendar.ics'),
              child: const Text('Load String 1'),
            ),
            ElevatedButton(
              onPressed: () => _getAssetsFile('calendar3.ics'),
              child: const Text('Load File 3'),
            ),
          ],
        ),
      ),
    );
  }
}
