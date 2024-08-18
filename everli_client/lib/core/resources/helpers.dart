import 'package:everli_client/core/common/constants/app_constants.dart';
import 'package:intl/intl.dart';

String formatString(String string, int maxLength) {
  if (string.length > maxLength) {
    return '${string.substring(0, maxLength)}...';
  }
  return string;
}

String formatDate(String iso8601String) {
  final DateTime dateTime = DateTime.parse(iso8601String);
  return DateFormat('d MMMM, yyyy').format(dateTime);
}

DateTimeStatus checkDateTimeStatus(String iso8601String) {
  final DateTime dateTime = DateTime.parse(iso8601String);
  final now = DateTime.now();
  final difference = dateTime.difference(now);

  if (difference.inHours >= 24) {
    return DateTimeStatus.future;
  } else if (difference.inHours < 0) {
    return DateTimeStatus.past;
  } else {
    return DateTimeStatus.within24Hours;
  }
}