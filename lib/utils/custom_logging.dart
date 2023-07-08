import 'package:logger/logger.dart';

class CustomLogging {
  static final CustomLogging _customLogging = CustomLogging._internal(
    Logger(
      printer: PrettyPrinter(
        colors: true,
        printTime: true,
      ),
    ),
  );

  final Logger logger;

  factory CustomLogging() {
    return _customLogging;
  }

  CustomLogging._internal(this.logger);
}
