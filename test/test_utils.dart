import 'dart:io';

Future<String> readFileString(String name) =>
    File('test/test_resources/$name').readAsString();

List<String> readFileLines(String name) =>
    File('test/test_resources/$name').readAsLinesSync();
