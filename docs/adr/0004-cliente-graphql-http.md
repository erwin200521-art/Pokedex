# ADR-0004 · Consultas GraphQL sobre `http` (sin cliente GraphQL con caché)

* **Estado:** aceptada · **Relacionado:** OE-02, RNF-RES-01, RNF-RES-05

## Contexto
PokeAPI es una fuente de solo lectura. Se necesita control fino de timeout, de errores diferenciados (red, timeout, 429, 5xx, errores GraphQL y respuestas parciales) y que la caché sea la base local, no la del cliente.

## Decisión
Enviar las consultas GraphQL como `POST` JSON con el paquete **`http`** (`GraphQlClient`), con timeout explícito, descarte de respuestas con `errors`, y decodificación del JSON en un isolate.

## Alternativas consideradas
| Alternativa | Motivo de descarte |
|---|---|
| Paquete `graphql` / `graphql_flutter` | Su caché normalizada compite con la fuente de verdad local (§6.5) y añade capas (links, cache) que habría que neutralizar; el beneficio (mutaciones, suscripciones) no aplica. |
| Generación de código con `ferry`/`artemis` | Complejidad de build desproporcionada para 1–2 consultas. |

## Consecuencias
* (+) Menos dependencias, errores explícitos, comportamiento predecible.
* (−) Sin tipado generado: la validación se hace en los DTO. Si el proyecto crece, migrar a un cliente generado afecta solo a `core/network` y `data/datasources`.
