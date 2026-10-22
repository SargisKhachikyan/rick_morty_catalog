import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../data/character_data.dart';

class CharacterException implements Exception {
  final String code;

  const CharacterException(this.code);
}

class CharacterService {
  CharacterService({http.Client? client}) : _client = client ?? http.Client();

  static final instance = CharacterService();

  final http.Client _client;

  Future<CharactersPage> getCharacters({
    required int page,
    String query = '',
  }) async {
    final uri = Uri.parse('https://rickandmortyapi.com/api/character').replace(
      queryParameters: {
        'page': '$page',
        if (query.isNotEmpty) 'name': query,
      },
    );

    try {
      final response =
          await _client.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 404) {
        return const CharactersPage(characters: [], hasNext: false);
      }

      if (response.statusCode != 200) {
        throw const CharacterException('server-error');
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final results = json['results'] as List<dynamic>;
      final info = json['info'] as Map<String, dynamic>;

      return CharactersPage(
        characters: [
          for (final item in results)
            Character.fromJson(item as Map<String, dynamic>),
        ],
        hasNext: info['next'] != null,
      );
    } on TimeoutException {
      throw const CharacterException('timeout');
    } on http.ClientException {
      throw const CharacterException('no-connection');
    } on FormatException {
      throw const CharacterException('invalid-data');
    }
  }
}
