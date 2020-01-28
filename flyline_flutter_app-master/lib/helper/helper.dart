import 'package:intl/intl.dart';

class Helper {
  static getDateViaString(String date, String format) {
    DateTime d = DateTime.parse(date);
    var formatter = new DateFormat(format);
    return formatter.format(d);
  }

  static getDateViaDate(DateTime date, String format) {
    var formatter = new DateFormat(format);
    return formatter.format(date);
  }

  static duration(Duration duration) {
    List<String> d = List();
    if (duration.inDays != 0) {
      d.add(duration.inDays.toString() + "d");
    }

    if (duration.inHours != 0) {
      d.add(duration.inHours.remainder(60).toString() + "h");
    }

    if (duration.inMinutes != 0) {
      d.add(duration.inMinutes.remainder(60).toString() + "m");
    }

    return d.join(" ");
  }
}
