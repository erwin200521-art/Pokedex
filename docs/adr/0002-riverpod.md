# ADR-0002 · Riverpod para estado e inyección de dependencias

* **Estado:** aceptada · **Relacionado:** OE-06, RNF-MAN-03

## Contexto
Se necesita estado reactivo que modele carga/éxito/vacío/error combinando tres fuentes (base local, disponibilidad, sincronización) y dependencias sustituibles.

## Decisión
Usar **flutter_riverpod 2.x** (providers manuales, sin generación de código). El estado de pantalla se *deriva* con una función pura (`resolveCatalogState`) que combina los flujos.

## Alternativas consideradas
| Alternativa | Motivo de descarte |
|---|---|
| BLoC | Válida; exige más código (eventos/estados) para flujos que ya son streams derivados. |
| Provider + `ChangeNotifier` | Menos composición de dependencias y peor testabilidad. |
| Riverpod 3.x | Cambios de API recientes; se fija 2.x por estabilidad. |

## Consecuencias
* (+) Composición declarativa, `overrides` en pruebas, sin `BuildContext` en la lógica.
* (+) La lógica de estado de pantalla es pura y está probada.
* (−) Curva de aprendizaje de providers; hay que cuidar el ciclo de vida (`autoDispose`).
