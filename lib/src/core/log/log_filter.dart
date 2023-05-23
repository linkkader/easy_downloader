import 'package:logger/logger.dart';

class LoggerFilter extends LogFilter {
  ///force all logs to be printed
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}
