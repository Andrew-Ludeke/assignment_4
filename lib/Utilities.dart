import 'package:intl/intl.dart';

String? formatDate(DateTime? time) {
  if (time == null) return null;

  return DateFormat.yMMMd().format(time);
}

String? formatTime(DateTime? time) {
  if (time == null) return null;

  return DateFormat.Hms().format(time);
}

String? formatDuration(Duration? duration) {
  if (duration == null) return null;

  return '${duration.inHours}h ${duration.inMinutes % 60}m ${duration.inSeconds % 60}s';
}

String? formatInt(int? duration) {
  if (duration == null) return null;

  Duration d = Duration(milliseconds: duration);

  return '${d.inHours}h ${d.inMinutes % 60}m ${d.inSeconds % 60}s';
}
