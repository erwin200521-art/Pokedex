import 'package:flutter/material.dart';

import '../../domain/entities/pokemon.dart';
import 'pokemon_card.dart';

/// Listado responsivo y virtualizado (RF-CAT-06, RNF-REN-01).
///
/// * Teléfonos (< 600 dp): lista de una columna con altura variable, robusta
///   frente al escalado de texto del sistema.
/// * Pantallas anchas: cuadrícula adaptable; su altura de celda crece con el
///   factor de escala del texto (RNF-ACC-04).
/// Ambos usan constructores `builder`: solo se crean los elementos visibles.
class PokemonListView extends StatelessWidget {
  const PokemonListView({required this.pokemon, super.key});

  final List<Pokemon> pokemon;

  static const double _gridBreakpoint = 600;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const padding = EdgeInsets.all(12);
        const physics = AlwaysScrollableScrollPhysics();

        if (constraints.maxWidth < _gridBreakpoint) {
          return ListView.builder(
            physics: physics,
            padding: padding,
            itemCount: pokemon.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: PokemonCard(pokemon: pokemon[index]),
            ),
          );
        }

        final textScale = MediaQuery.textScalerOf(context).scale(14) / 14;
        return GridView.builder(
          physics: physics,
          padding: padding,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 420,
            mainAxisExtent: 120 + 70 * textScale,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: pokemon.length,
          itemBuilder: (context, index) => PokemonCard(pokemon: pokemon[index]),
        );
      },
    );
  }
}
