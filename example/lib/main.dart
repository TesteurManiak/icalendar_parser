import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ICalendar? _iCalendar;
  bool _isLoading = false;

  Future<void> _getAssetsFile(String assetName) async {
    setState(() => _isLoading = true);
    try {
      final directory = await getTemporaryDirectory();
      final myPath = path.join(directory.path, assetName);
      final data = await rootBundle.load('assets/$assetName');
      final bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      final file = await File(myPath).writeAsBytes(bytes);
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
    final calendar = _iCalendar;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_isLoading) const Center(child: CircularProgressIndicator()),
            if (calendar != null) IcsTextContent(calendar),
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

class IcsTextContent extends StatelessWidget {
  const IcsTextContent(
    this.iCalendar, {
    super.key,
  });

  final ICalendar iCalendar;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            style: TextStyle(fontWeight: FontWeight.bold),
            children: [
              TextSpan(text: 'VERSION: ${iCalendar.version}\n'),
              TextSpan(text: 'PRODID: ${iCalendar.prodid}\n'),
              TextSpan(text: 'CALSCALE: ${iCalendar.calscale}\n'),
              TextSpan(text: 'METHOD: ${iCalendar.method}\n'),
            ],
          ),
          TextSpan(
            children: [
              for (final entry in iCalendar.data)
                for (final key in entry.keys)
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${key.toUpperCase()}: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: '${entry[key]}\n'),
                    ],
                  ),
            ],
          ),
        ],
      ),
    );
  }
}
