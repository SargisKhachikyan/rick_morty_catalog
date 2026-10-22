import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../state/character_bloc.dart';
import '../../state/character_bloc_events.dart';

class SearchFieldWidget extends StatefulWidget {
  const SearchFieldWidget({super.key});

  @override
  State<SearchFieldWidget> createState() => _SearchFieldWidgetState();
}

class _SearchFieldWidgetState extends State<SearchFieldWidget> {
  late final TextEditingController controller;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(
      text: context.read<CharacterBloc>().state.query,
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    controller.dispose();
    super.dispose();
  }

  void search(String text) {
    timer?.cancel();
    timer = Timer(const Duration(milliseconds: 500), () {
      context.read<CharacterBloc>().add(SearchCharactersEvent(text));
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: search,
      decoration: const InputDecoration(
        hintText: 'Search by name',
        border: InputBorder.none,
        prefixIcon: Icon(Icons.search),
      ),
    );
  }
}
