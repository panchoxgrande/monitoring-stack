# Runbook DRA — recreación y restauración

## Objetivo

Demostrar que el stack puede recuperarse en infraestructura nueva, dentro del RPO/RTO acordado y sin depender de los volúmenes del servidor original.

## Antes del ejercicio

- Aprobar la ventana y responsables.
- Registrar versiones e inventario.
- Ejecutar dump de PostgreSQL.
- Respaldar Grafana y configuraciones.
- Crear snapshot de índices OpenSearch.
- Copiar respaldos fuera del host y verificar checksums.
- Confirmar que las llaves de cifrado estén disponibles por un canal independiente.

## Recreación controlada

```bash
docker compose --env-file env.conf config --quiet
docker compose --env-file env.conf stop --timeout 60
docker compose --env-file env.conf up -d --force-recreate
docker compose --env-file env.conf ps
```

No uses `docker compose down -v`: elimina los volúmenes y convierte una recreación en pérdida de datos.

## Restauración real

1. Aprovisionar un host vacío.
2. Clonar el repositorio y cargar secretos desde el gestor autorizado.
3. Restaurar PostgreSQL.
4. Restaurar Grafana/configuración.
5. Restaurar snapshots OpenSearch.
6. Levantar servicios por dependencias.
7. Ejecutar todas las pruebas de `docs/VALIDATION.md`.
8. Confirmar que los eventos recientes son consultables desde Grafana y Wazuh Dashboard.

## Evidencia mínima

- Fecha, responsables y alcance.
- Checksums y ubicación de respaldos.
- Inicio/fin y tiempo total.
- Último dato antes del incidente y primero después de restaurar.
- RPO y RTO observados.
- Errores, decisiones y acciones correctivas.

Una recreación que reutiliza volúmenes prueba Compose, pero no demuestra recuperación ante pérdida total. El ensayo DRA debe completarse al menos una vez en un host vacío.
