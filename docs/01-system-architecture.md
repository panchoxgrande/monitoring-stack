# 1. System Architecture — COMFRUT Monitoring Stack

Complete architecture overview of the monitoring, SIEM, and security stack.

## 1.1 High-Level Architecture

```
                          INTERNET
                             │
                    ┌────────┼────────┐
                    │        │        │
              FortiGate    SSH      Attacks
                    │        │        │
                    └────────┼────────┘
                             │
              ┌──────────────────────────────┐
              │   Servidor Monitoreo         │
              │   Docker Compose Stack       │
              │                              │
              │  ┌────────────────────────┐  │
              │  │   Zabbix 7.0           │  │
              │  │   + Grafana 11.4       │  │
              │  │   + Wazuh 4.9.2        │  │
              │  │   + PostgreSQL 16      │  │
              │  │   + OpenSearch         │  │
              │  │   + fail2ban           │  │
              │  └────────────────────────┘  │
              │                              │
              │ Salidas:                    │
              │ • WhatsApp (alertas)        │
              │ • Backups (local + cloud)   │
              │ • Firewall blocks           │
              └──────────────────────────────┘
```

## 1.2 Containers (10 total)

| Container | Puerto | Función | Salud |
|-----------|--------|---------|-------|
| zabbix-server | 10051 | Colección de datos | health |
| zabbix-web | 8080 | Web UI | health |
| zabbix-postgres | 5432 | Base de datos | health |
| zabbix-agent | 10050 | Monitoreo local | health |
| zabbix-snmptraps | 162 | SNMP traps | health |
| grafana | 3000 | Dashboards | health |
| wazuh-manager | 514(udp), 1515(agent) | SIEM | health |
| wazuh-indexer | 9200 | OpenSearch | running |
| wazuh-dashboard | 5601 | Wazuh UI | health |
| threatfeed | internal | Threat feeds | running |

## 1.3 Network

- **Tipo:** Docker overlay network
- **Rango:** 172.28.0.0/24
- **Comunicación:** Contenedor a contenedor vía DNS interno
- **Exterior:** Puertos mapeados en host

## 1.4 Almacenamiento

- `/data/` — Volúmenes persistentes
  - `zabbix-postgres/` — BD Zabbix
  - `wazuh-api-credentials/` — Credenciales Wazuh
  - `wazuh-etc/` — Configuración Wazuh
  - `wazuh-var/` — Datos Wazuh
  - `grafana/` — Dashboards y datasources
  - `backups/` — Backups locales

## 1.5 Flujo de Datos

```
Hosts/Firewalls
        │
        ├─→ Zabbix Agent (TCP 10050)
        ├─→ SNMP Traps (UDP 162)
        ├─→ Syslog (UDP 514) → Wazuh Manager
        │
        ├─→ Zabbix Server (TCP 10051)
        │   └─→ PostgreSQL (BD)
        │
        ├─→ Wazuh Manager (TCP 1515)
        │   └─→ Wazuh Indexer (OpenSearch)
        │
        └─→ Grafana (visualización)
            ├─→ Datasource Zabbix
            └─→ Datasource Wazuh/OpenSearch

Alertas
        ├─→ WhatsApp (CallMeBot)
        ├─→ Email
        └─→ WebHooks
```

## 1.6 Seguridad

- **Firewall geográfico:** ipset (CL/MX/US)
- **SSH:** ed25519 keys, no password
- **fail2ban:** Anti-bruteforce (5 intentos = ban 24h)
- **HTTPS:** Certificados SSL (Grafana, Wazuh)
- **Credenciales:** Almacenadas en env.conf (NO en git)

## 1.7 Integraciones

- **FortiGate:** Syslog 514/udp
- **OPNsense:** Syslog 514/udp
- **Sistemas Legacy:** Windows 2012 R2, SQL 2014 (grupo separado)
- **OneDrive:** Backups vía rclone
- **GitHub:** Tracking de cambios (CI/CD opcional)

## 1.8 Escalabilidad

- **Fase 1 (Actual):** 6 firewalls + 1 servidor
- **Fase 2:** 20 endpoints con agentes Wazuh
- **Fase 3:** Threat intelligence (AlienVault OTX)
- **Fase 4:** Automatización (FortiGate API blocking)
