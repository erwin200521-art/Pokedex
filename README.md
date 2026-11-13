# Pokédex Flutter · Offline-First

Proyecto Final de **Desarrollo de Aplicaciones Móviles** (PUCMM). Este repositorio contiene el **Avance (≈ 40 %)**: base arquitectónica, persistencia local, integración GraphQL, catálogo funcional, funcionamiento offline e indicador global de conectividad.

> Equipo: _Erwin Martínez_. Docente: Freddy Peña.

## 1. Descripción del proyecto

Pokédex móvil multiplataforma hecha con Flutter que consume la API GraphQL de PokeAPI con un modelo **Offline-First + Online-Preferred**: la interfaz siempre se construye desde una base SQLite local observable; cuando el servicio remoto está disponible, la app lo consulta, valida, guarda en transacción y la UI se actualiza sola por observación de la base.

Alcance del avance (ver `Avance_Proyecto_Final`): estructura por features/capas, modelo local (catálogo, favoritos, metadatos de sync), catálogo con paginación GraphQL sin duplicados, UI sin bloqueos, estados de carga/vacío/error con «Reintentar», funcionamiento offline tras reiniciar, indicador global (Online / Offline / Servicio no disponible / Sincronizando) y documentación inicial con ADR.

## 2. Requisitos de ejecución

| Herramienta | Versión |
|---|---|
| Flutter | ≥ 3.27 (Dart ≥ 3.6) |
| Android | minSdk 21+ / emulador o dispositivo |
| iOS | 12+ (macOS con Xcode) |

## 3. Instrucciones de instalación

```bash
git clone <url-del-repositorio> pokedex && cd pokedex

# Si el repositorio aún no tiene android/ ios/ (solo se versionó lib/ y pubspec):
flutter create --org do.edu.pucmm --project-name pokedex .

flutter pub get
dart run build_runner build --delete-conflicting-outputs   # genera app_database.g.dart (Drift)
flutter run
```

**Android — permisos** (en `android/app/src/main/AndroidManifest.xml`, dentro de `<manifest>`, antes de `<application>`):

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
```

Calidad: `dart format .` · `flutter analyze` · `flutter test`.

## 4. Tecnologías utilizadas y su justificación (RNF-MAN-04, ENT-09)

| Dependencia | Para qué | Por qué esta y no otra |
|---|---|---|
| `flutter_riverpod` 2.x | Estado + inyección de dependencias | Providers sustituibles en pruebas, sin `BuildContext`, estado reactivo derivado (ADR-0002). Se fija 2.x por estabilidad de API. |
| `drift` + `drift_flutter` | SQLite estructurado y observable | Consultas tipadas, `watch()` reactivo, transacciones, índices, migraciones y ejecución en isolate de fondo (ADR-0001). |
| `http` | Transporte de las consultas GraphQL | Control explícito de timeout/errores y cero magia; PokeAPI es solo lectura y no necesita caché normalizada (ADR-0004). |
| `connectivity_plus` | Eventos de cambio de red | Solo *dispara* la re-comprobación; la disponibilidad real se determina con una consulta GraphQL mínima (ADR-0005). |
| `cached_network_image` + `flutter_cache_manager` | Imágenes con caché en disco | Imágenes ya vistas se muestran sin red (OF-08); caché acotada y configurable. |
| `flutter_lints` | Análisis estático | RNF-CAL-01. |
| `build_runner` + `drift_dev` | Generación de código Drift | Requisito de Drift. |

## 5. Arquitectura

Clean Architecture **por funcionalidades** con capas `presentation → domain ← data`. Las dependencias apuntan al dominio. Detalle y diagrama en [`docs/architecture.md`](docs/architecture.md).

```
UI (widgets) → Riverpod (estado derivado) → casos de uso → PokemonRepository (contrato, domain)
                                                              ▲ implementa
                         ┌────────────────────────────────────┘
                 PokemonRepositoryImpl (data)
                   │ lee                       │ solicita actualización
                   ▼                           ▼
        PokemonLocalDataSource (Drift)   SyncCoordinator (core) ──► CatalogSyncTask ──► GraphQL (PokeAPI)
                   ▲                                                            │ valida + transacción
                   └────────────────── cambios observables ◄───────────────────┘
```

Reglas verificables: `domain/` no importa Flutter, `graphql_client` ni `drift`; `presentation/` no importa `data/` ni el cliente GraphQL; los DTO no salen de `data/`; los fallos de infraestructura se traducen a `Failure` del dominio.

## 6. Estructura del proyecto

```
lib/
├─ main.dart
├─ app/                     # bootstrap (composición) y shell con el indicador global
├─ core/
│  ├─ config/               # AppConfig: endpoint, timeouts, tamaños, TTL
│  ├─ error/                # Failure (dominio), excepciones de infraestructura, Result, mapper
│  ├─ network/              # GraphQlClient, ConnectivityMonitor, ApiSimulation
│  ├─ database/             # Drift: tablas, AppDatabase, store de metadatos de sync
│  ├─ sync/                 # SyncCoordinator, SyncTask, RetryPolicy, SyncState
│  ├─ images/  theme/  l10n/  widgets/ (indicador global)
│  └─ providers.dart        # DI de infraestructura
└─ features/
   └─ pokemon/
      ├─ domain/            # Pokemon, PokemonRepository, WatchCatalog, RefreshCatalog
      ├─ data/              # DTO, mapper, data sources (GraphQL/Drift), CatalogSyncTask, repo impl
      ├─ presentation/      # CatalogPage, estado de pantalla, widgets
      └─ pokemon_providers.dart
```
`favorites/`, `trivia/` y `settings/` se añaden en la entrega final con la misma forma. La tabla `favorites` ya existe en el modelo.

## 7. Estrategia Offline-First

1. La UI **solo** observa `PokemonLocalDataSource.watchCatalog()` (un `Stream` de Drift). Ningún widget ve respuestas GraphQL (OF-16/17).
2. El `SyncCoordinator` actualiza la base en segundo plano; cada página se confirma en una transacción y la UI recibe los cambios por la observación local (OF-02/03).
3. Sin red o con la API caída se siguen mostrando los datos locales; los errores remotos nunca borran ni sobrescriben datos válidos (OF-04/05).
4. Al arrancar sin conexión la app muestra los datos guardados (OF-10); sin datos locales, un estado vacío explicativo (PA-15).
5. No es una caché HTTP: hay entidades, relaciones e índices consultables localmente (§6.5).

## 8. Uso de GraphQL y estrategia de paginación (RF-CAT-02)

Endpoint `https://graphql.pokeapi.co/v1beta2`. Consulta (`pokemon_graphql_queries.dart`):

```graphql
query CatalogPage($limit: Int!, $offset: Int!, $maxId: Int!) {
  pokemon(where: {id: {_lt: $maxId}}, order_by: {id: asc}, limit: $limit, offset: $offset) {
    id name height weight
    pokemontypes(order_by: {slot: asc}) { slot type { id name } }
  }
}
```

* **Paginación offset/limit, 100 por página, orden estable por `id`.** El esquema Hasura de PokeAPI no ofrece cursores/keyset utilizables en el cliente; con orden por clave primaria inmutable, offset no produce saltos ni repetidos (ADR-0003).
* `id < 10000` limita a las formas por defecto (≈ 1 025 Pokémon); las formas alternativas llegan en la entrega final.
* Una página con menos de 100 elementos marca el final.
* Las respuestas con `errors` (incluso parciales) se descartan completas (RNF-RES-05).

## 9. Estrategia de sincronización (PS-02 a PS-12)

| Decisión | Elección |
|---|---|
| **PS-02 Carga inicial** | Descarga progresiva en segundo plano de todo el catálogo (11 páginas). La UI es utilizable desde el primer instante y se llena página a página. Imágenes bajo demanda. |
| **PS-03 Vigencia** | Catálogo completo vigente 6 h (`AppConfig.catalogStaleAfter`); pasado ese tiempo, o si quedó incompleto/fallido, se considera desactualizado. |
| **PS-04 Disparadores** | Inicio de la app · recuperación de conectividad · cada 15 min · manual (pull-to-refresh, «Reintentar», tocar el indicador, menú ⋮). |
| **PS-05 Claves** | `pokemon.id` de PokeAPI (PK natural, estable). |
| **PS-06 Duplicados** | Upsert por PK (`insertOnConflictUpdate`); relaciones reemplazadas por Pokémon; un solo `SyncCoordinator` evita ejecuciones concurrentes (RNF-RES-03). |
| **PS-07 Interrupciones** | Cada página se guarda **junto con el cursor** en una transacción. Si se corta, se reanuda desde el cursor; nunca hay datos parciales visibles (RNF-RES-04). |
| **PS-08 Imágenes** | Sprites en caché de disco (hasta 1 500 archivos, 180 días, LRU). Si no están, se muestra un respaldo. |
| **PS-09 Última sync** | Tabla `sync_metadata_entries`; el indicador la expone (IND-04). |
| **PS-10 Fallos** | Por solicitud: 3 intentos con backoff 1 s·2 s (+jitter). A nivel de sincronización: hasta 5 reintentos automáticos 15 s → 5 min; luego espera evento/periodo. Estado `failed` persistido. Migraciones: `schemaVersion` + `onUpgrade`. |
| **PS-11 Datos de usuario** | `favorites` sin FK al catálogo y fuera de cualquier operación de sync. |
| **PS-12 Alteraciones** | Cada actualización sobrescribe con el dato remoto (upsert completo): lo alterado localmente se restaura (OF-19). Comprobación dirigida por detalle: entrega final. |

Timeouts: 15 s por solicitud, 5 s para la comprobación de salud (RNF-RES-01).
Flujo completo: [`docs/sync-flow.md`](docs/sync-flow.md).

## 10. Persistencia local

SQLite con Drift. Tablas: `pokemons`, `element_types`, `pokemon_type_links`, `favorites`, `sync_metadata_entries`. Índices: `idx_pokemons_name`, `idx_pokemons_dex`, `idx_pokemon_type_links_type` (RNF-REN-02). Esquema y relación con el Diagrama 6: [`docs/data-model.md`](docs/data-model.md).

## 11. Gestión de conectividad

Dos dimensiones independientes (§7.4): **disponibilidad** (`verifying | online | offline | serviceUnavailable`, `ConnectivityMonitor`) y **sincronización** (`idle | syncing | waitingRetry | failed`, `SyncCoordinator`). La disponibilidad se determina con una consulta GraphQL real, no solo por Wi-Fi (IND-02); los eventos de red se agrupan 800 ms para evitar parpadeos (IND-06). El indicador (`core/widgets/connectivity_indicator.dart`) está en `MaterialApp.builder`, por lo que aparece en **todas** las pantallas (IND-01); muestra icono + texto + color, etiqueta `Semantics` y la procedencia/vigencia de los datos (IND-04/05). Tocarlo fuerza una sincronización.

**Simular API caída con red activa (PA-08):** menú ⋮ → «Simular API caída».

## 12. Funcionalidades adicionales implementadas

Tema claro/oscuro Material 3, diseño responsivo (lista/cuadrícula), caché de imágenes acotada, menú de depuración y pruebas unitarias. Detalle, favoritos, búsqueda/filtros, trivia, restauración dirigida, i18n completa y demás: entrega final.

## 13. Limitaciones conocidas

* Los nombres de campos GraphQL (`pokemon`, `pokemontypes`, `type`) siguen el esquema v1beta2 documentado; si PokeAPI los cambia, solo hay que ajustar `pokemon_graphql_queries.dart` y `pokemon_dto.dart`.
* Offline en primera ejecución: sin datos hasta que haya conexión una vez (estado vacío explicativo).
* Las imágenes solo están offline si se visualizaron antes (descarga bajo demanda).
* Textos en español; la internacionalización completa llega en la entrega final.
* La generación de `app_database.g.dart` requiere `build_runner` (ver instalación).

## Documentación

* [`docs/architecture.md`](docs/architecture.md) · [`docs/data-model.md`](docs/data-model.md) · [`docs/sync-flow.md`](docs/sync-flow.md)
* ADR: [`0001`](docs/adr/0001-drift-fuente-de-verdad.md) · [`0002`](docs/adr/0002-riverpod.md) · [`0003`](docs/adr/0003-paginacion-y-sincronizacion.md) · [`0004`](docs/adr/0004-cliente-graphql-http.md) · [`0005`](docs/adr/0005-disponibilidad-real-del-servicio.md)
* [`docs/demo-checklist.md`](docs/demo-checklist.md): guion para demostrar los escenarios PA del avance.
