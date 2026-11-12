import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/images/app_image_cache.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../domain/entities/pokemon.dart';
import 'type_chip.dart';

/// Tarjeta del listado: número, nombre, imagen y tipos (RF-CAT-01).
class PokemonCard extends StatelessWidget {
  const PokemonCard({required this.pokemon, super.key});

  final Pokemon pokemon;

  static const double imageSize = 80;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = capitalize(pokemon.name);

    return Semantics(
      label: AppStrings.semanticsPokemon(
        name,
        pokemon.nationalDexNumber,
        pokemon.types.map(capitalize).toList(),
      ),
      excludeSemantics: true,
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              PokemonImage(url: pokemon.spriteUrl, size: imageSize),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppStrings.pokedexNumber(pokemon.nationalDexNumber),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(name, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final type in pokemon.types) TypeChip(type: type),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Imagen con caché en disco (visible offline si ya se descargó, OF-08) y
/// recurso de respaldo cuando no está disponible. Se decodifica a un tamaño
/// acorde al contenedor (RNF-REN-04).
class PokemonImage extends StatelessWidget {
  const PokemonImage({required this.url, required this.size, super.key});

  final String url;
  final double size;

  @override
  Widget build(BuildContext context) {
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);
    return SizedBox(
      width: size,
      height: size,
      child: CachedNetworkImage(
        imageUrl: url,
        cacheManager: AppImageCache.instance,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.medium,
        memCacheWidth: (size * pixelRatio).round(),
        fadeInDuration: const Duration(milliseconds: 150),
        placeholder: (context, _) => const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        errorWidget: (context, _, __) => const _ImageFallback(),
      ),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.catching_pokemon_outlined, color: color, size: 32),
            Text(
              AppStrings.imageUnavailable,
              textAlign: TextAlign.center,
              style: TextStyle(color: color, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
