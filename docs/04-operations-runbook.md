# 4. Operations Runbook

Daily, weekly, and monthly operational tasks.

## 4.1 Startup Procedure

```bash
# Iniciar stack
docker-compose up -d

# Verificar salud
docker-compose ps

# Esperar 2 minutos
sleep 120

# Verificar conectividad
curl http://localhost:8080 && echo "✅ Zabbix OK"
curl http://localhost:3000 && echo "✅ Grafana OK"
```

## 4.2 Daily Tasks

### 4.2.1 Monitoreo de Alertas

```bash
# Ver últimas alertas Wazuh
docker-compose exec wazuh-manager grep "Alert" /var/ossec/logs/alerts/alerts.log | tail -20

# Ver logs de Zabbix
docker-compose logs zabbix-server | tail -50
```

### 4.2.2 Verificar Agentes

```bash
# Agentes Wazuh conectados
docker-compose exec wazuh-manager /var/ossec/bin/agent_control -l

# Hosts Zabbix
# En web: Monitoring → Hosts (filtrar por estado)
```

### 4.2.3 Revisar Dashboards

- Grafana Executive Summary
- Wazuh Threat Analysis
- Alertas críticas en WhatsApp

## 4.3 Weekly Tasks

### 4.3.1 Backup Verification

```bash
# Verificar backup local
ls -lh /data/backups/

# Verificar backup en cloud
rclone ls remote:monitoring-backups/ | head -10
```

### 4.3.2 Database Optimization

```bash
# Ver tamaño BD
docker-compose exec zabbix-postgres \
  psql -U zabbix -d zabbix -c "SELECT pg_size_pretty(pg_database_size('zabbix'));"

# Ejecutar VACUUM
docker-compose exec zabbix-postgres \
  psql -U zabbix -d zabbix -c "VACUUM ANALYZE;"
```

### 4.3.3 Update Check

```bash
# Ver versiones
docker-compose exec zabbix-server zabbix_server -V
docker-compose exec wazuh-manager /var/ossec/bin/wazuh-control -v
```

## 4.4 Monthly Tasks

### 4.4.1 Full System Backup

```bash
# Backup completo
bash scripts/backup.sh

# Verificar integridad
tar -tzf /data/backups/monitoring-stack-backup-*.tar.gz | head -20
```

### 4.4.2 Security Audit

```bash
# Revisar logs de fail2ban
docker-compose exec -T fail2ban fail2ban-client status sshd

# Revisar accesos fallidos
docker-compose logs | grep "Authentication failed"
```

### 4.4.3 Performance Review

```bash
# Housekeeper runtime
docker-compose logs zabbix-server | grep "housekeeping" | tail -5

# Consultas lentas (PostgreSQL)
docker-compose exec zabbix-postgres \
  psql -U zabbix -d zabbix -c "EXPLAIN ANALYZE SELECT * FROM trends LIMIT 1;"
```

### 4.4.4 Disk Space Review

```bash
# Ver uso de disco
du -sh /data/*

# Límpieza si >80%
# Bajar retención en Zabbix (ver docs/03-detailed-configuration.md)
```

## 4.5 Shutdown Procedure

```bash
# Detenerse gracefully
docker-compose down

# Verificar
docker-compose ps
```

---

Para troubleshooting, ver [05-troubleshooting-guide.md](05-troubleshooting-guide.md).
