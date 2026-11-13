# ADR-0001 · Drift (SQLite) como fuente de verdad observable

* **Estado:** aceptada · **Relacionado:** P-01, OF-16, OE-03, PS-01

## Contexto
La UI debe funcionar sin red y reflejar los cambios de la sincronización sin recargas manuales. Se necesita un modelo estructurado y consultable (entidades, relaciones, índices), transacciones y flujos reactivos.

## Decisión
Persistir el catálogo en **SQLite mediante Drift**. La UI observa `watch()` de consultas Drift; las respuestas remotas solo llegan a la UI tras guardarse en una transacción. `drift_flutter` abre la base en un isolate de fondo.

## Alternativas consideradas
| Alternativa | Motivo de descarte |
|---|---|
| Caché normalizada del cliente GraphQL / caché HTTP | Es una caché de respuestas, no un modelo consultable; no cumple OF-16 ni permite filtros/orden nuevos sin red (§6.5). |
| `sqflite` a mano | Sin streams reactivos ni tipado; habría que construir la invalidación de consultas. |
| Isar / Hive | Sin SQL relacional ni transacciones multi-tabla tan directas; el modelo del Diagrama 6 es relacional. |

## Consecuencias
* (+) Una sola fuente de lectura; transacciones por página; índices; migraciones versionadas.
* (+) Pruebas con base en memoria.
* (−) Requiere `build_runner` y mantener el esquema/migraciones.
