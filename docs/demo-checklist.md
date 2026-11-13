# Guion de demostración del avance

Todo se demuestra en vivo (§13). Prepara un emulador/dispositivo y la consola (`flutter run`) visible: los logs `[GraphQL]`, `[Sync]`, `[CatalogSync]` y `[Connectivity]` sirven de evidencia.

| PA | Cómo demostrarlo |
|---|---|
| **PA-01** Primera ejecución | Desinstalar la app, instalarla con red. Navegar de inmediato: el indicador pasa a *Sincronizando* y luego a *En línea*; la lista se llena página a página y el indicador muestra la fecha de la última sync. |
| **PA-03** Offline con datos | Modo avión. Abrir catálogo: se ven datos e imágenes vistas; indicador *Sin conexión · Datos locales · última sync HH:mm*. |
| **PA-04** Reinicio offline | Con modo avión, cerrar la app a la fuerza y reabrirla: arranca con los datos locales. |
| **PA-07** Reconexión automática | Desde offline, desactivar modo avión sin tocar la app: *Sincronizando* → *En línea* (en pocos segundos: evento de red + 800 ms de antiparpadeo + comprobación de la API). |
| **PA-08** API caída con red | Menú ⋮ → *Simular API caída*: indicador *Servicio no disponible* (nunca *En línea*); en consola se ven los reintentos con backoff. Desmarcar para recuperar. |
| **PA-09** Interrupción | Durante la descarga inicial activar modo avión (o cerrar la app). Inspeccionar `sync_metadata_entries` (`status`, `cursor`) antes/después; al volver la red continúa desde el cursor. |
| **PA-12** Cuatro estados | Provocar: red activa → *En línea*; modo avión → *Sin conexión*; simular API caída → *Servicio no disponible*; menú → *Sincronizar ahora* → *Sincronizando*. |
| **PA-13** Sin duplicados | Menú → *Sincronizar ahora* tres veces. Contar filas con un inspector de BD (Android Studio *App Inspection → Database Inspector*, base `pokedex`): `pokemons` conserva el mismo conteo. |
| **PA-14** Fluidez | Hacer scroll y cambiar de pantalla durante la descarga inicial. |
| **PA-15** Vacíos sin datos | Instalar limpia en modo avión: estado vacío explicativo con «Reintentar». |

Para **PA-13/PA-09** se requiere "un inspector de base de datos accesible": Database Inspector de Android Studio sobre el emulador.
