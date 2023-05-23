import 'package:logger/logger.dart';

///all logs will be filtered by this class
///[shouldLog] return true if you want to print log
class LoggerFilter extends LogFilter {
  ///force all logs to be printed
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}
