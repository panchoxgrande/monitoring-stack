# 8. Quick Reference — Cheat Sheet

Comandos y URLs de uso frecuente.

## 8.1 URLs de Acceso

| Sistema | URL | Usuario |
|---------|-----|---------|
| Zabbix | http://localhost:8080 | Admin |
| Grafana | http://localhost:3000 | admin |
| Wazuh | https://localhost:5601 | admin |
| PostgreSQL | localhost:5432 | zabbix |
| OpenSearch | http://localhost:9200 | admin |

## 8.2 Comandos Docker

```bash
# Ver estado de contenedores
docker-compose ps

# Ver logs
docker-compose logs -f <servicio>

# Ejecutar comando en contenedor
docker-compose exec <servicio> <comando>

# Reiniciar servicio
docker-compose restart <servicio>

# Detener todo
docker-compose down

# Iniciar todo
docker-compose up -d
```

## 8.3 Comandos Útiles

```bash
# Ver espacio en disco
du -sh /data/*

# Ver tamaño BD
docker-compose exec zabbix-postgres \
  psql -U zabbix -d zabbix -c "SELECT pg_size_pretty(pg_database_size('zabbix'));"

# Ver agentes Wazuh conectados
docker-compose exec wazuh-manager /var/ossec/bin/agent_control -l

# Ver últimas alertas
docker-compose exec wazuh-manager tail -50 /var/ossec/logs/alerts/alerts.log

# Backup
bash scripts/backup.sh

# Backup en cloud
bash scripts/backup-offsite.sh
```

## 8.4 Puertos

| Puerto | Servicio | Protocolo |
|--------|----------|-----------|
| 8080 | Zabbix | HTTP |
| 3000 | Grafana | HTTP |
| 5601 | Wazuh Dashboard | HTTPS |
| 10051 | Zabbix Server | TCP |
| 10050 | Zabbix Agent | TCP |
| 1515 | Wazuh Agent | TCP |
| 514 | Syslog (Wazuh) | UDP |
| 162 | SNMP Traps | UDP |
| 5432 | PostgreSQL | TCP |
| 9200 | OpenSearch | HTTP |

## 8.5 Credenciales

Todas en: `env.conf` (NO commitar)

```bash
ZABBIX_ADMIN_PASSWORD=
GF_SECURITY_ADMIN_PASSWORD=
WAZUH_DASHBOARD_PASSWORD=
POSTGRES_PASSWORD=
CALLMEBOT_API_KEY=      # Opcional
RCLONE_CONFIG_PATH=     # Opcional
```

## 8.6 Archivos de Config

```
config/
├── zabbix/
│   ├── zabbix_server.conf
│   └── zabbix_web.conf
├── grafana/
│   ├── provisioning/dashboards/
│   └── provisioning/datasources/
├── wazuh/
│   ├── ossec.conf
│   └── rules/local_rules.xml
└── fail2ban/
    └── jail.local
```

## 8.7 Paths Importantes

```
/data/zabbix-postgres/     # BD Zabbix
/data/grafana/             # Dashboards Grafana
/data/wazuh-etc/           # Config Wazuh
/data/backups/             # Backups locales
/var/ossec/logs/           # Logs Wazuh
/var/log/zabbix/           # Logs Zabbix
```

## 8.8 Útiles Uno-Liners

```bash
# Limpiar logs viejos
find /var/log -name "*.log" -mtime +30 -delete

# Ver CPU/Memory en tiempo real
docker stats

# Ver alertas activas (últimas 100)
docker-compose exec wazuh-manager grep "Alert" /var/ossec/logs/alerts/alerts.log | tail -100

# Buscar en logs
docker-compose logs | grep "error"

# Backup rápido (sin offsite)
tar -czf /data/backups/backup-$(date +%s).tar.gz /data/
```

## 8.9 Links Útiles

- [Zabbix Docs](https://www.zabbix.com/documentation)
- [Grafana Docs](https://grafana.com/docs/)
- [Wazuh Docs](https://documentation.wazuh.com/)
- [OPNsense Docs](https://docs.opnsense.org/)
- [FortiGate Docs](https://docs.fortinet.com/)

## 8.10 Emergency Contacts

- **Soporte:** GitHub Issues
- **Documentación:** `/docs/`
- **Contribuir:** Ver `CONTRIBUTE.md`

---

Para procedimientos completos, ver [06-procedures.md](06-procedures.md).
