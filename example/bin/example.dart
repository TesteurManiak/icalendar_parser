import 'package:example/command_runner.dart';

Future<void> main(List<String> args) async {
  await AppCommandRunner().run(args);
}
