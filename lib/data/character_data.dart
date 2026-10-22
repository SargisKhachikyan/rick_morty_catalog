class Character {
  final int id;
  final String name;
  final String status;
  final String species;
  final String image;
  final String origin;
  final String location;

  const Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.image,
    required this.origin,
    required this.location,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] as int,
      name: json['name'] ?? '',
      status: json['status'] ?? 'unknown',
      species: json['species'] ?? 'unknown',
      image: json['image'] ?? '',
      origin: json['origin']?['name'] ?? 'unknown',
      location: json['location']?['name'] ?? 'unknown',
    );
  }
}

class CharactersPage {
  final List<Character> characters;
  final bool hasNext;

  const CharactersPage({
    required this.characters,
    required this.hasNext,
  });
}
