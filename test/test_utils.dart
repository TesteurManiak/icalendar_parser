import 'dart:io';

String readFileString(String name) =>
    File('test/test_resources/$name').readAsStringSync();

List<String> readFileLines(String name) =>
    File('test/test_resources/$name').readAsLinesSync();
