import 'package:flutter/material.dart';

Color statusColor(String? status) {
  switch (status?.toLowerCase()) {
    case 'alive':
      return Colors.green;

    case 'dead':
      return Colors.red;

    default:
      return Colors.grey;
  }
}

class CharacterCardWidget extends StatelessWidget {
  final String? name;
  final String? status;
  final String? imagePath;
  final VoidCallback onTap;

  const CharacterCardWidget({
    super.key,
    required this.name,
    required this.status,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final path = imagePath;

    const characterIcon = SizedBox(
      width: 116,
      height: 116,
      child: Icon(
        Icons.person,
        size: 60,
        color: Colors.green,
      ),
    );

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            if (path != null && path.isNotEmpty)
              Image.network(
                path,
                width: 116,
                height: 116,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return characterIcon;
                },
              )
            else
              characterIcon,
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name ?? 'Unknown',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.circle,
                          size: 10,
                          color: statusColor(status),
                        ),
                        const SizedBox(width: 6),
                        Text(status ?? 'unknown'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
