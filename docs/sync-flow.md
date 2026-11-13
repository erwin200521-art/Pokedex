# Flujo de sincronización implementado (ENT-08)

```mermaid
flowchart TD
  A[Disparador: inicio · reconexión · 15 min · manual] --> B{syncAll en curso?}
  B -- sí --> B1[Reutiliza el Future en curso<br/>RNF-RES-03]
  B -- no --> C[ConnectivityMonitor.check]
  C --> D{¿Hay red?}
  D -- no --> D1[Offline: omitir, UI con datos locales]
  D -- sí --> E{¿GraphQL responde? sonda 5 s}
  E -- no --> E1[Servicio no disponible: omitir]
  E -- sí --> F{¿needsSync? incompleto, fallido o > 6 h}
  F -- no --> F1[Datos vigentes: no hace nada]
  F -- sí --> G[Estado: Sincronizando]
  G --> H[Leer cursor en sync_metadata]
  H --> I[Pedir página offset/limit con timeout 15 s]
  I --> J{¿Respuesta válida?<br/>sin errors, estructura OK}
  J -- fallo recuperable --> J1[Backoff 1 s, 2 s: 3 intentos]
  J1 --> I
  J -- inválida o agotada --> K[markFailed conserva cursor y datos]
  J -- sí --> L[Transacción: upsert + relaciones + cursor]
  L --> M{¿Última página? len < 100}
  M -- no --> I
  M -- sí --> N[markCompleted + lastSuccessAt]
  N --> O[Estado: Idle · datos remotos actualizados]
  K --> P[waitingRetry: reintento 15 s → 5 min, máx. 5]
  P --> A
```

## Garantías

| Garantía | Mecanismo |
|---|---|
| UI nunca bloqueada | Todo asíncrono; Drift en isolate; JSON decodificado con `Isolate.run`. |
| Sin duplicados (PA-13) | Upsert por PK + un único sync en vuelo. |
| Sin datos parciales (PA-09) | Página + cursor en una transacción. |
| Reanudación | `status ≠ completed` ⇒ continuar en `cursor`. |
| Remoto prevalece (OF-19) | El upsert sobrescribe todos los campos del catálogo. |
| Datos locales a salvo (OF-04) | Una respuesta con errores/parcial se descarta antes de escribir. |
| Reintentos acotados (RNF-RES-02) | `RetryPolicy` por página + límite de reintentos automáticos en el coordinador. |
