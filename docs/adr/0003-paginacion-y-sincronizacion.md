# ADR-0003 · Paginación offset/limit con cursor persistido y páginas transaccionales

* **Estado:** aceptada · **Relacionado:** RF-CAT-02, OF-13, PS-02, PS-06, PS-07, RNF-RES-04

## Contexto
PokeAPI (Hasura) permite `limit/offset` y `order_by`; no ofrece un mecanismo de sincronización incremental ni cursores utilizables. El catálogo ronda las 1 025 especies por defecto. La primera ejecución no debe bloquear la UI y una interrupción no debe dejar datos inconsistentes.

## Decisión
* **Paginación offset/limit** (100 por página) con `order_by: {id: asc}` y `where id < 10000`.
* **Cada página se guarda en una transacción junto con el cursor** (`sync_metadata_entries.cursor`). Si se interrumpe, se reanuda en el cursor.
* **Upsert por `id`**; las relaciones de los Pokémon de la página se reemplazan. Una nueva actualización recorre el catálogo desde 0 y sobrescribe con la versión remota (OF-19).
* Vigencia de 6 h; disparadores: inicio, reconexión, periódico (15 min) y manual.

## Alternativas consideradas
| Alternativa | Motivo de descarte |
|---|---|
| Descargar todo en una sola consulta | Respuesta grande, lenta y sin progreso; un fallo pierde todo. |
| Paginación por keyset (`id > último`) | Equivalente aquí y viable; offset es suficiente con orden por PK inmutable y simplifica el cursor. Se puede migrar sin cambiar el modelo. |
| Descarga bajo demanda por Pokémon únicamente | No cumple el catálogo/filtros offline sobre datos locales. |

## Consecuencias
* (+) Carga progresiva visible, reanudable, idempotente y sin duplicados.
* (−) La actualización completa vuelve a descargar ~11 páginas; se mitiga con la vigencia de 6 h. La comprobación dirigida por detalle (OF-20) llega en la entrega final.
