import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:rick_morty_catalog/data/character_data.dart';
import 'package:rick_morty_catalog/presentation/state/character_bloc.dart';
import 'package:rick_morty_catalog/presentation/state/character_bloc_events.dart';
import 'package:rick_morty_catalog/presentation/state/character_bloc_states.dart';
import 'package:rick_morty_catalog/service/character_service.dart';

Character makeCharacter(int id) {
  return Character(
    id: id,
    name: 'Rick $id',
    status: 'Alive',
    species: 'Human',
    image: '',
    origin: 'Earth',
    location: 'Earth',
  );
}

class FakeCharacterService extends CharacterService {
  bool shouldFail = false;

  @override
  Future<CharactersPage> getCharacters({
    required int page,
    String query = '',
  }) async {
    if (shouldFail) throw const CharacterException('no-connection');

    if (query == 'nobody') {
      return const CharactersPage(characters: [], hasNext: false);
    }

    return CharactersPage(
      characters: [makeCharacter(page * 2 - 1), makeCharacter(page * 2)],
      hasNext: page < 2,
    );
  }
}

void main() {
  late FakeCharacterService service;
  late CharacterBloc bloc;

  setUp(() {
    service = FakeCharacterService();
    bloc = CharacterBloc(service: service);
  });

  tearDown(() => bloc.close());

  test('loads the first page and then the next one', () async {
    bloc.add(LoadCharactersEvent());

    var state = await bloc.stream.firstWhere(
      (s) => s.status == CharacterStatusEnum.success,
    );
    expect(state.characters.length, 2);
    expect(state.hasNext, true);

    bloc.add(LoadMoreCharactersEvent());

    state = await bloc.stream.firstWhere((s) => s.characters.length == 4);
    expect(state.hasNext, false);
    expect(state.isLoadingMore, false);
  });

  test('search without results gives an empty list', () async {
    bloc.add(SearchCharactersEvent('nobody'));

    final state = await bloc.stream.firstWhere(
      (s) => s.query == 'nobody' && s.status == CharacterStatusEnum.success,
    );
    expect(state.characters, isEmpty);
    expect(state.error, isNull);
  });

  test('shows an error and loads again after retry', () async {
    service.shouldFail = true;
    bloc.add(LoadCharactersEvent());

    var state = await bloc.stream.firstWhere(
      (s) => s.status == CharacterStatusEnum.failure,
    );
    expect(state.error, 'Please check your internet connection.');

    service.shouldFail = false;
    bloc.add(LoadCharactersEvent());

    state = await bloc.stream.firstWhere(
      (s) => s.status == CharacterStatusEnum.success,
    );
    expect(state.characters, isNotEmpty);
    expect(state.error, isNull);
  });

  test('service returns an empty page on 404', () async {
    final client = MockClient((request) async => http.Response('{}', 404));
    final page = await CharacterService(client: client).getCharacters(page: 1);

    expect(page.characters, isEmpty);
    expect(page.hasNext, false);
  });

  test('Character.fromJson handles missing fields', () {
    final character = Character.fromJson({
      'id': 1,
      'name': 'Rick Sanchez',
      'status': 'Dead',
      'origin': {'name': 'Earth (C-137)'},
      'location': null,
    });

    expect(character.status, 'Dead');
    expect(character.origin, 'Earth (C-137)');
    expect(character.location, 'unknown');
    expect(character.species, 'unknown');
  });
}
