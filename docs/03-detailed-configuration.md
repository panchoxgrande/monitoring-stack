# 3. Detailed Configuration

Component-by-component configuration guide.

## 3.1 Zabbix Server Configuration

### 3.1.1 Archivo de Config

```bash
nano config/zabbix/zabbix_server.conf
```

**Parámetros importantes:**

```conf
LogFile=/var/log/zabbix/zabbix_server.log
DBName=zabbix
DBUser=zabbix
DBPassword=<from env.conf>
ListenPort=10051
SourceIP=0.0.0.0
HousekeeperFrequency=0      # Desactivar housekeeper automático
MaxHousekeeperDelete=5000   # Si se habilita, límite por operación
```

### 3.1.2 Template Management

```
Configuration → Templates → Create Template
```

- **Linux by Zabbix Agent** — Para servidores Linux
- **Windows by SNMP** — Para servidores Windows
- **FortiGate by SNMP** — Para firewalls Fortinet

### 3.1.3 Host Management

```
Configuration → Hosts → Create Host

Nombre: sd-71297-opn-principal
IP: 192.168.1.1
Template: OPNsense SNMP
Puerto: 161
```

## 3.2 Grafana Configuration

### 3.2.1 Datasources

```
Configuration → Data Sources → Add data source
```

**Zabbix:**
```
Name: Zabbix
Type: Zabbix
URL: http://zabbix-server:10051
User: Admin
Password: <from env.conf>
```

**Wazuh/OpenSearch:**
```
Name: Wazuh
Type: OpenSearch
URL: http://wazuh-indexer:9200
Auth: Basic Auth
User: admin
Password: <from env.conf>
TLS: Skip verification
```

### 3.2.2 Dashboards

Los 7 dashboards están pre-configurados. Ver en:
```
Grafana → Home → Browse → Monitoreo Comfrut
```

## 3.3 PostgreSQL Configuration

### 3.3.1 Acceso a BD

```bash
docker-compose exec zabbix-postgres psql -U zabbix -d zabbix
```

### 3.3.2 Útiles Queries

```sql
-- Ver tamaño de BD
SELECT pg_size_pretty(pg_database_size('zabbix'));

-- Ver retención de historia (días)
SELECT name, history FROM zabbix.config;

-- Limpiar datos antiguos
DELETE FROM history WHERE clock < EXTRACT(EPOCH FROM (NOW() - INTERVAL '30 days'));
```

## 3.4 Wazuh Manager Configuration

### 3.4.1 Archivo de Config

```bash
nano config/wazuh/ossec.conf
```

**Secciones importantes:**

```xml
<ossec_config>
  <!-- Syslog listener (firewall logs) -->
  <remote>
    <connection>syslog</connection>
    <allowed-ips>0.0.0.0/0</allowed-ips>
    <port>514</port>
    <protocol>udp</protocol>
  </remote>

  <!-- Agent listener -->
  <remote>
    <connection>secure</connection>
    <port>1515</port>
    <protocol>tcp</protocol>
  </remote>

  <!-- Custom WhatsApp integration -->
  <integration>
    <name>custom-whatsapp</name>
    <hook_url>http://localhost:5000/webhook</hook_url>
    <level>7</level>
  </integration>
</ossec_config>
```

### 3.4.2 Custom Rules

```bash
nano config/wazuh/rules/local_rules.xml
```

**Ejemplo - Detectar ataques dirigidos:**

```xml
<rule id="100200" level="7">
  <if_matched_group>web|attack</if_matched_group>
  <description>Directed attack attempt</description>
  <mitre>
    <id>T1190</id>
  </mitre>
</rule>
```

## 3.5 fail2ban Configuration

```bash
nano /etc/fail2ban/jail.local
```

```conf
[sshd]
enabled = true
port = ssh
logpath = %(sshd_log)s
maxretry = 5
findtime = 600      # 10 minutos
bantime = 86400     # 24 horas
```

## 3.6 Firewall Geográfico

```bash
sudo nano /etc/iptables/rules.v4
```

Configurar ipset para permitir solo CL/MX/USA.

---

Ver [GETTING_STARTED.md](../GETTING_STARTED.md) para guía de inicio rápido.
