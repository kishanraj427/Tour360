import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get apiKey => dotenv.env['GOOGLE_API_KEY'] ?? '';
  static String get cx => dotenv.env['GOOGLE_CX'] ?? '';

  static String buildSearchUrl(String query) {
    final sanitizedQuery = sanitizeQuery(query);
    return 'https://customsearch.googleapis.com/customsearch/v1'
        '?key=$apiKey'
        '&cx=$cx'
        '&searchType=image'
        '&imgSize=HUGE'
        '&q=${Uri.encodeComponent('$sanitizedQuery panoramic image')}';
  }

  static String sanitizeQuery(String input) {
    return input.replaceAll(RegExp(r'[^\w\s\-.,]'), '').trim();
  }
}
