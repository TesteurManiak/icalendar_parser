import 'dart:io';

import 'dart:typed_data';

Future<String> readFileString(String name) =>
    File('test/test_resources/$name').readAsString();

Future<Uint8List> readAsBytes(String name) =>
    File('test/test_resources/$name').readAsBytes();

List<String> readFileLines(String name) =>
    File('test/test_resources/$name').readAsLinesSync();
