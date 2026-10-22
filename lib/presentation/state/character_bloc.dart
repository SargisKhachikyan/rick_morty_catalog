import 'package:flutter_bloc/flutter_bloc.dart';

import '../../service/character_service.dart';
import 'character_bloc_events.dart';
import 'character_bloc_states.dart';

class CharacterBloc extends Bloc<CharacterEvents, CharacterState> {
  final CharacterService _service;

  CharacterBloc({CharacterService? service})
      : _service = service ?? CharacterService.instance,
        super(CharacterState()) {
    on<LoadCharactersEvent>((event, emit) async {
      await _loadFirstPage(state.query, emit);
    });

    on<SearchCharactersEvent>((event, emit) async {
      final query = event.query.trim();

      if (query == state.query) return;

      await _loadFirstPage(query, emit);
    });

    on<LoadMoreCharactersEvent>(_loadMore);
  }

  Future<void> _loadFirstPage(
    String query,
    Emitter<CharacterState> emit,
  ) async {
    emit(state.copyWith(
      status: CharacterStatusEnum.loading,
      query: query,
      characters: [],
      page: 1,
      hasNext: false,
      isLoadingMore: false,
      clearError: true,
    ));

    try {
      final result = await _service.getCharacters(page: 1, query: query);

      if (state.query != query) return;

      emit(state.copyWith(
        status: CharacterStatusEnum.success,
        characters: result.characters,
        hasNext: result.hasNext,
      ));
    } on CharacterException catch (e) {
      if (state.query != query) return;

      emit(state.copyWith(
        status: CharacterStatusEnum.failure,
        error: _errorMessage(e.code),
      ));
    } catch (_) {
      if (state.query != query) return;

      emit(state.copyWith(
        status: CharacterStatusEnum.failure,
        error: _errorMessage('unknown'),
      ));
    }
  }

  Future<void> _loadMore(
    LoadMoreCharactersEvent event,
    Emitter<CharacterState> emit,
  ) async {
    if (state.isLoading || state.isLoadingMore || !state.hasNext) return;

    if (state.error != null && !event.retry) return;

    final query = state.query;
    final nextPage = state.page + 1;

    emit(state.copyWith(isLoadingMore: true, clearError: true));

    try {
      final result = await _service.getCharacters(page: nextPage, query: query);

      if (state.query != query) return;

      emit(state.copyWith(
        characters: [...state.characters, ...result.characters],
        page: nextPage,
        hasNext: result.hasNext,
        isLoadingMore: false,
      ));
    } on CharacterException catch (e) {
      if (state.query != query) return;

      emit(state.copyWith(
        isLoadingMore: false,
        error: _errorMessage(e.code),
      ));
    } catch (_) {
      if (state.query != query) return;

      emit(state.copyWith(
        isLoadingMore: false,
        error: _errorMessage('unknown'),
      ));
    }
  }

  String _errorMessage(String code) {
    switch (code) {
      case 'timeout':
        return 'The request timed out. Please try again.';

      case 'no-connection':
        return 'Please check your internet connection.';

      case 'server-error':
        return 'Server error. Please try again later.';

      case 'invalid-data':
        return 'Received invalid data from the server.';

      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
