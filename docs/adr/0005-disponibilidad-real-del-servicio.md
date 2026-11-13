# ADR-0005 · Disponibilidad real del servicio (sonda GraphQL) y modelo de dos dimensiones

* **Estado:** aceptada · **Relacionado:** IND-02, IND-06, OF-11, §7.4

## Contexto
"Hay Wi-Fi" no implica "la API responde". El indicador no debe mostrar *online* si PokeAPI falla, ni mezclar disponibilidad y sincronización en estados contradictorios.

## Decisión
* `connectivity_plus` solo informa de interfaces de red y **dispara** una re-comprobación (con *debounce* de 800 ms).
* La disponibilidad se decide con una consulta GraphQL mínima (`pokemon(limit: 1){id}`, timeout 5 s): `offline` (sin red), `serviceUnavailable` (red sin API), `online`.
* Re-comprobación periódica: 30 s si no está online; 2 min si lo está.
* Estado de **sincronización** como dimensión separada; el indicador las compone y `offline`/`serviceUnavailable` prevalecen sobre `syncing`.
* Mecanismo de simulación de API caída (`ApiSimulation`) para PA-08.

## Alternativas consideradas
| Alternativa | Motivo de descarte |
|---|---|
| Solo `connectivity_plus` | Incumple IND-02: mostraría *online* con la API caída. |
| Ping/DNS a otro host | No prueba el servicio que realmente se consume. |

## Consecuencias
* (+) Indicador veraz, sin parpadeos, sin estados contradictorios.
* (−) Una solicitud ligera periódica; es insignificante frente a la fiabilidad del estado.
