import 'package:flutter/material.dart';

import '../../data/character_data.dart';
import '../home_screen/widgets/character_card_widget.dart';

class DetailsScreen extends StatelessWidget {
  final Character character;

  const DetailsScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(character.name),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    character.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox(
                        height: 300,
                        child: Icon(
                          Icons.person,
                          size: 90,
                          color: Colors.green,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  character.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                _InfoRow(
                  title: 'Status',
                  value: character.status,
                  color: statusColor(character.status),
                ),
                _InfoRow(title: 'Species', value: character.species),
                _InfoRow(title: 'Origin', value: character.origin),
                _InfoRow(title: 'Location', value: character.location),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String title;
  final String value;
  final Color? color;

  const _InfoRow({
    required this.title,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          Row(
            children: [
              if (color != null) ...[
                Icon(Icons.circle, size: 10, color: color),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: Text(value, style: const TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
