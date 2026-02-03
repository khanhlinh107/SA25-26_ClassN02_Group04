import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class BookApiService {
  static const String _apiKey =
      'AIzaSyBa8L5P4k1oylnDLOS63ZcThXLrDSMhu9w'; // API KEY
  static const String _baseUrl =
      'https://www.googleapis.com/books/v1/volumes';

  Future<List<Book>> searchBooks(String keyword) async {
    if (keyword.trim().isEmpty) return [];

    final encodedKeyword = Uri.encodeQueryComponent(keyword.trim());

    final url = Uri.parse(
      '$_baseUrl?q=$encodedKeyword&maxResults=20&key=$_apiKey',
    );

    try {
      final response = await http
          .get(url)
          .timeout(const Duration(seconds: 10));

      print('API URL: $url');
      print('STATUS: ${response.statusCode}');

      /// ❌ QUOTA / RATE LIMIT
      if (response.statusCode == 429) {
        print('⚠️ Google Books API: Quota exceeded');
        return [];
      }

      /// ❌ OTHER ERRORS
      if (response.statusCode != 200) {
        print('❌ API ERROR BODY: ${response.body}');
        return [];
      }

      final data = json.decode(response.body);

      if (data['items'] == null || data['items'] is! List) {
        print('⚠️ NO ITEMS FROM API');
        return [];
      }

      final List items = data['items'];

      return items.map<Book>((item) {
        final volume = item['volumeInfo'] ?? {};

        return Book.create(
          title: volume['title'] ?? 'No title',
          author: (volume['authors'] is List &&
              volume['authors'].isNotEmpty)
              ? volume['authors'][0]
              : 'Unknown',
          category: (volume['categories'] is List &&
              volume['categories'].isNotEmpty)
              ? volume['categories'][0]
              : 'General',
          quantity: 1,
          imageUrl: volume['imageLinks']?['thumbnail'] ?? '',
          description: volume['description'] ?? '',
        );
      }).toList();
    } on TimeoutException {
      print('⏱ API TIMEOUT');
      return [];
    } catch (e) {
      print('🔥 API EXCEPTION: $e');
      return [];
    }
  }
}
