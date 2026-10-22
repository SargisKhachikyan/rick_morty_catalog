# Rick and Morty Catalog

A Flutter app for browsing and searching Rick and Morty characters. It uses the [Rick and Morty API](https://rickandmortyapi.com/documentation).

## Features

- Browse characters with image, name, and status.
- The next page loads automatically when you scroll to the end of the list.
- Search characters by name.
- Loading, error, and empty states with a "Try again" button; a failed next page shows a SnackBar.
- Open a character to see status, species, origin, and current location.
- When you come back from the details screen, the list, scroll position, and search text stay the same.

## Built With

- **Flutter & Dart** — application UI and logic
- **flutter_bloc** — state management
- **http** — REST API requests

## Getting Started

```
flutter create . --project-name rick_morty_catalog
flutter pub get
flutter run
```

On macOS, add this to `macos/Runner/DebugProfile.entitlements` and `macos/Runner/Release.entitlements`, otherwise the app cannot use the network:

```
<key>com.apple.security.network.client</key>
<true/>
```

## How It Works

`CharacterBloc` is created once above `MaterialApp`, so the loaded characters and the search text are kept while the details screen is open.

`CharacterService` sends requests to the API. When a search has no results, the API answers with 404, and the service turns it into an empty list.

The search field waits 500 ms after the last typed letter before it sends a search event. If an answer comes for an old search text, the bloc ignores it.

When one of the last four cards is shown, the bloc loads the next page.

## Current Limitations

- Characters are stored in memory and are lost when the app restarts.
- Pull to refresh is not implemented.
- If loading the next page fails, it is retried only with the "Try again" button in the SnackBar.

## Tests

```
flutter test
```

## Future Improvements

- Local storage for offline access
- Filters by status and species
- Pull to refresh
