# 5. Troubleshooting Guide

Diagnostic and resolution procedures by symptom.

## 5.1 Containers Not Starting

**Síntoma:** `docker-compose up -d` cuelga o falla

```bash
# Ver logs detallados
docker-compose logs

# Limpiar y reintentar
docker-compose down --volumes
docker-compose up -d --no-cache

# Ver logs específicos
docker-compose logs zabbix-server
docker-compose logs wazuh-manager
```

## 5.2 Zabbix No Conecta a PostgreSQL

**Síntoma:** Zabbix logs muestran "Cannot connect to database"

```bash
# Verificar que PostgreSQL está corriendo
docker-compose exec zabbix-postgres pg_isready

# Ver credenciales en env.conf
grep POSTGRES_PASSWORD env.conf

# Reiniciar ambos
docker-compose restart zabbix-postgres zabbix-server
```

## 5.3 Grafana Datasources No Conectan

**Síntoma:** Dashboards muestran "No data" o "Connection failed"

```bash
# Verificar datasources
curl -u admin:password http://localhost:3000/api/datasources | jq .

# Reiniciar Grafana
docker-compose restart grafana

# Verificar conectividad interna
docker-compose exec grafana curl http://zabbix-server:10051
docker-compose exec grafana curl http://wazuh-indexer:9200
```

## 5.4 Wazuh Manager No Inicia

**Síntoma:** `docker-compose logs wazuh-manager` muestra errores

```bash
# Ver logs detallados
docker-compose logs wazuh-manager | tail -50

# Verificar integridad de archivos
docker-compose exec wazuh-manager ls -la /var/ossec/etc/

# Reiniciar con logs verbosos
docker-compose restart wazuh-manager
docker-compose logs -f wazuh-manager
```

## 5.5 Alertas no Llegan a WhatsApp

**Síntoma:** Alertas críticas no se reciben en WhatsApp

```bash
# Ver log de integración
docker-compose exec wazuh-manager tail -50 /var/ossec/logs/integrations.log

# Verificar API Key en env.conf
grep CALLMEBOT env.conf

# Probar manualmente
curl -X POST "https://api.callmebot.com/whatsapp.php?phone=56937528894&text=Test&apikey=<KEY>"
```

## 5.6 Base de Datos Muy Grande

**Síntoma:** `/data/` usa >30GB, queries lentas

```bash
# Ver tamaño actual
docker-compose exec zabbix-postgres psql -U zabbix -d zabbix \
  -c "SELECT pg_size_pretty(pg_database_size('zabbix'));"

# Reducir retención (ver docs/03)
# Ejecutar VACUUM
docker-compose exec zabbix-postgres psql -U zabbix -d zabbix -c "VACUUM FULL;"

# Recrear índices si es necesario
docker-compose exec zabbix-postgres psql -U zabbix -d zabbix -c "REINDEX DATABASE zabbix;"
```

## 5.7 Agente Wazuh no Conecta

**Síntoma:** "Agent never connected" en Wazuh dashboard

```bash
# Verificar puerto 1515
docker-compose exec wazuh-manager netstat -an | grep 1515

# Ver reg log del agente
docker-compose logs wazuh-manager | grep "agent.*connected"

# Reinstalar agente con nuevo ID
```

## 5.8 Firewall Bloqueado

**Síntoma:** No se puede acceder a dashboards desde otra máquina

```bash
# Verificar iptables
sudo iptables -L -n

# Permitir puerto 8080 (Zabbix)
sudo ufw allow 8080/tcp

# Permitir puerto 3000 (Grafana)
sudo ufw allow 3000/tcp
```

## 5.9 Certificados SSL Vencidos

**Síntoma:** Warning de certificado en Wazuh/Grafana

```bash
# Regenerar certificados Wazuh
docker-compose exec wazuh-manager /usr/share/wazuh-indexer-certs/tool.sh -a

# Reiniciar stack
docker-compose down
docker-compose up -d
```

---

Para procedimientos comunes, ver [06-procedures.md](06-procedures.md).
