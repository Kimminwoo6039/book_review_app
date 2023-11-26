import 'package:intl/intl.dart';

class AppDataUtil {
  static String dataFormat(String format,DateTime date) {
      return DateFormat(format).format(date);
  }
}