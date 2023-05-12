import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:icalendar_parser/icalendar_parser.dart';

class AppCommandRunner {
  AppCommandRunner() : executableName = 'example';

  final String executableName;

  Future<int> run(List<String> args) async {
    int exitCode = 0;

    try {
      final parser = ArgParser()
        ..addFlag(
          'help',
          abbr: 'h',
          negatable: false,
          callback: displayHelp,
        );

      final resultsRest = parser.parse(args).rest;
      final futures = <Future>[];
      for (final arg in resultsRest) {
        futures.add(parseIcsFile(arg));
      }

      await Future.wait<void>(
        futures,
        eagerError: true,
      );
    } catch (e) {
      exitCode = 1;
    }

    return exitCode;
  }

  Future<void> parseIcsFile(String filePath) async {
    final lines = await File(filePath).readAsLines();
    final json = ICalendar.fromLines(lines).toJson();
    final buffer = StringBuffer('File: $filePath\n');
    final prettyprint = JsonEncoder.withIndent('  ').convert(json);
    buffer.writeln(prettyprint);
    print(buffer.toString());
  }

  void displayHelp(bool displayHelp) {
    if (!displayHelp) {
      return;
    }

    final buffer = StringBuffer()
      ..writeln('Usage: $executableName [files...]')
      ..writeln('')
      ..writeln('Global options:')
      ..writeln('--help, -h    Print this usage information.')
      ..writeln('')
      ..writeln('Available commands:')
      ..writeln('  help   Display help information for example.')
      ..writeln('');

    print(buffer.toString());
  }
}
