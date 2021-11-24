import 'package:logger/logger.dart';

class SimpleLogPrinter extends LogPrinter {
  final String className;
  SimpleLogPrinter(this.className);

  @override
  List<String> log(LogEvent event) {
    AnsiColor color = PrettyPrinter.levelColors[event.level]!;
    String emoji = PrettyPrinter.levelEmojis[event.level]!;
    return [color('$emoji [$className]: ${event.message}')];
  }
}
