import '../../data/character_data.dart';

enum CharacterStatusEnum { initial, loading, success, failure }

class CharacterState {
  final CharacterStatusEnum status;
  final List<Character> characters;
  final String query;
  final int page;
  final bool hasNext;
  final bool isLoadingMore;
  final String? error;

  CharacterState({
    this.status = CharacterStatusEnum.initial,
    this.characters = const [],
    this.query = '',
    this.page = 1,
    this.hasNext = false,
    this.isLoadingMore = false,
    this.error,
  });

  bool get isLoading => status == CharacterStatusEnum.loading;

  CharacterState copyWith({
    CharacterStatusEnum? status,
    List<Character>? characters,
    String? query,
    int? page,
    bool? hasNext,
    bool? isLoadingMore,
    String? error,
    bool clearError = false,
  }) {
    return CharacterState(
      status: status ?? this.status,
      characters: characters ?? this.characters,
      query: query ?? this.query,
      page: page ?? this.page,
      hasNext: hasNext ?? this.hasNext,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: clearError ? null : error ?? this.error,
    );
  }
}
