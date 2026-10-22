class CharacterEvents {}

class LoadCharactersEvent extends CharacterEvents {}

class LoadMoreCharactersEvent extends CharacterEvents {
  final bool retry;

  LoadMoreCharactersEvent({this.retry = false});
}

class SearchCharactersEvent extends CharacterEvents {
  final String query;

  SearchCharactersEvent(this.query);
}
