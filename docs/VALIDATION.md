# Validación del stack

Ejecuta las pruebas desde el host Docker. No imprimas contraseñas en logs ni las incluyas en reportes públicos.

## Estado de contenedores

```bash
docker compose --env-file env.conf config --quiet
docker compose --env-file env.conf ps
docker stats --no-stream
```

## PostgreSQL y Zabbix

```bash
docker inspect --format '{{.State.Health.Status}}' zabbix-postgres
curl -fsS -o /dev/null http://127.0.0.1:8080
```

## Grafana

```bash
curl -fsS http://127.0.0.1:3000/api/health
```

Comprueba que exista un único datasource Wazuh válido y que apunte a `http://wazuh-indexer:9200` dentro de la red Docker. Un datasource con `localhost:9200` apunta al propio contenedor Grafana y normalmente es incorrecto.

## Flujo Wazuh → OpenSearch → Grafana

1. Confirma que Wazuh Manager no registre errores `401 Unauthorized`:

```bash
docker logs --since 5m wazuh-manager 2>&1 | grep -c '401 Unauthorized'
```

2. Confirma que existan índices y documentos recientes en OpenSearch usando credenciales del entorno, sin mostrarlas.

3. En Grafana, usa **Save & test** sobre el datasource Wazuh.

4. Consulta el contador mediante el proxy de Grafana:

```bash
curl -u 'GRAFANA_USER:GRAFANA_PASSWORD' \
  'http://127.0.0.1:3000/api/datasources/proxy/uid/wazuh-opensearch/wazuh-alerts-*/_count'
```

Un HTTP 200 con `count > 0` demuestra que Grafana puede leer los índices. Verifica además el timestamp más reciente para confirmar que la ingesta no está detenida.

## Señales de deriva

- La imagen declarada difiere de la imagen del contenedor activo.
- Compose muestra variables obligatorias vacías.
- El dashboard responde 503.
- OpenSearch responde 401 a las credenciales configuradas.
- Filebeat repite 401.
- Hay datasources duplicados o sin versión.
- El indexador alcanza su límite de memoria.
- Los backups no incluyen snapshots de OpenSearch.
