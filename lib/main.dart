import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'presentation/home_screen/home_page.dart';
import 'presentation/state/character_bloc.dart';
import 'presentation/state/character_bloc_events.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CharacterBloc()..add(LoadCharactersEvent()),
      child: MaterialApp(
        title: 'Rick and Morty',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0xFF97CE4C),
          brightness: Brightness.dark,
        ),
        home: const HomePage(),
      ),
    );
  }
}
