import 'package:almentor_analytics_module/events_name.dart';

extension EventNameExtension on EventName {
  String get convertToSnakeCase {
    String result = name.replaceAllMapped(RegExp(r'[A-Z]'), (match) {
      return '_${match.group(0)!.toLowerCase()}';
    });
    if (result.startsWith('_')) {
      result = result.substring(1);
    }
    return result.replaceAll('Event', '').toLowerCase();
  }

  String get convertToTitleCase {
    String result = name.replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (match) {
      return '${match.group(1)!} ${match.group(2)!.toLowerCase()}';
    });
    return result.replaceAll("Event", "").trim();
  }
}
