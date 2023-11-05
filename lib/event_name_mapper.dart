import 'package:almentor_analytics_module/events_name.dart';

extension EventNameExtension on EventName {
  String get convertToSnakeCase {
    String result = name.replaceAllMapped(RegExp(r'[A-Z]'), (match) {
      return '_${match.group(0)!.toLowerCase()}';
    });
    if (result.startsWith('_')) {
      result = result.substring(1);
    }
    return result.replaceAll('_event', '').toLowerCase();
  }

  String get convertToTitleCase {
    String result = name.replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (match) {
      return '${match.group(1)!} ${match.group(2)!.toLowerCase()}';
    });
    result = result.replaceAll('event', '');
    List<String> words = result.split(' ');
    words = words.map((word) {
      if (word.isNotEmpty) {
        return word[0].toUpperCase() + word.substring(1);
      }
      return word;
    }).toList();

    return words.join(' ');
  }
}
