import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/character_data.dart';
import '../details_screen/details_screen.dart';
import '../state/character_bloc.dart';
import '../state/character_bloc_events.dart';
import '../state/character_bloc_states.dart';
import 'widgets/appbar_widget.dart';
import 'widgets/character_card_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CharacterBloc, CharacterState>(
      listenWhen: (previous, current) =>
          previous.error != current.error &&
          current.error != null &&
          current.status == CharacterStatusEnum.success,
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.error ?? 'Something went wrong.'),
            action: SnackBarAction(
              label: 'Try again',
              onPressed: () => context
                  .read<CharacterBloc>()
                  .add(LoadMoreCharactersEvent(retry: true)),
            ),
          ),
        );
      },
      builder: (context, state) => Scaffold(
        appBar: const AppbarWidget(),
        body: _buildBody(context, state),
      ),
    );
  }

  Widget _buildBody(BuildContext context, CharacterState state) {
    if (state.status == CharacterStatusEnum.failure) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 56),
              const SizedBox(height: 16),
              Text(
                state.error ?? 'Something went wrong.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () =>
                    context.read<CharacterBloc>().add(LoadCharactersEvent()),
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      );
    }

    if (state.characters.isEmpty) {
      if (state.status == CharacterStatusEnum.success) {
        return const Center(child: Text('No characters found.'));
      }

      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 420,
              mainAxisExtent: 116,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: state.characters.length,
            itemBuilder: (context, index) {
              if (index >= state.characters.length - 4) {
                context.read<CharacterBloc>().add(LoadMoreCharactersEvent());
              }

              final Character character = state.characters[index];

              return CharacterCardWidget(
                name: character.name,
                status: character.status,
                imagePath: character.image,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsScreen(character: character),
                    ),
                  );
                },
              );
            },
          ),
        ),
        if (state.isLoadingMore)
          const Padding(
            padding: EdgeInsets.all(12),
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
