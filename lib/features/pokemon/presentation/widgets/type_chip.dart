import 'package:flutter/material.dart';

/// Etiqueta de tipo. El tipo se comunica con texto + color (no solo color,
/// RNF-ACC-05); el texto usa el color de contenido del tema para mantener el
/// contraste (RNF-ACC-02).
class TypeChip extends StatelessWidget {
  const TypeChip({required this.type, super.key});

  final String type;

  @override
  Widget build(BuildContext context) {
    final color = typeColor(type);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            capitalize(type),
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}

String capitalize(String value) {
  if (value.isEmpty) return value;
  return value[0].toUpperCase() + value.substring(1);
}

Color typeColor(String type) {
  return switch (type) {
    'normal' => const Color(0xFFA8A77A),
    'fire' => const Color(0xFFF08030),
    'water' => const Color(0xFF6890F0),
    'electric' => const Color(0xFFF8D030),
    'grass' => const Color(0xFF78C850),
    'ice' => const Color(0xFF98D8D8),
    'fighting' => const Color(0xFFC03028),
    'poison' => const Color(0xFFA040A0),
    'ground' => const Color(0xFFE0C068),
    'flying' => const Color(0xFFA890F0),
    'psychic' => const Color(0xFFF85888),
    'bug' => const Color(0xFFA8B820),
    'rock' => const Color(0xFFB8A038),
    'ghost' => const Color(0xFF705898),
    'dragon' => const Color(0xFF7038F8),
    'dark' => const Color(0xFF705848),
    'steel' => const Color(0xFFB8B8D0),
    'fairy' => const Color(0xFFEE99AC),
    _ => const Color(0xFF9E9E9E),
  };
}
