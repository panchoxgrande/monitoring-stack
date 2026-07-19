# 6. Procedures & Howtos

Common tasks and step-by-step procedures.

## 6.1 Agregar un Nuevo Host a Zabbix

### 6.1.1 Desde Zabbix Web

```
Configuration → Hosts → Create Host

Nombre: srv-web-01
IP: 192.168.1.50
Template: Linux by Zabbix Agent
Puerto: 10050
```

Click: **Add → Save**

Esperar 2-3 minutos. El host debería pasar a estado "Available".

### 6.1.2 Instalar Zabbix Agent

En el servidor Linux:

```bash
# Instalar agente
sudo apt install -y zabbix-agent

# Configurar
sudo nano /etc/zabbix/zabbix_agentd.conf

# Cambiar:
Server=<IP_servidor_monitoreo>
ListenIP=0.0.0.0
```

Reiniciar: `sudo systemctl restart zabbix-agent`

## 6.2 Conectar FortiGate / OPNsense

### 6.2.1 OPNsense (Syslog)

En OPNsense:
```
System → Settings → Logging → Targets

Hostname: <IP_servidor_monitoreo>
Port: 514
Transport: UDP
```

### 6.2.2 FortiGate (SNMP + Syslog)

En FortiGate CLI:

```bash
config log syslogd setting
set status enable
set server "<IP_servidor>"
set port 514
end

config system snmp community
edit 1
set name "public"
end
```

Luego en Zabbix: Crear host con template "FortiGate by SNMP"

## 6.3 Crear un Dashboard Grafana Personalizado

### 6.3.1 Pasos

1. **Ir a Grafana:** http://localhost:3000
2. **Click:** Dashboard → New Dashboard → New Panel
3. **Configurar Panel:**
   - Título: "Mi Panel"
   - Data Source: Zabbix
   - Métrica: Seleccionar (CPU, RAM, etc.)
4. **Guardar:** Click Save → Ingresar nombre dashboard
5. **Exportar:** Dashboard Settings → JSON Model → Copy
6. **Pushear a GitHub:** `git add dashboards/`, commit, push

### 6.3.2 Estructura JSON

```json
{
  "dashboard": {
    "title": "Custom Dashboard",
    "panels": [...]
  }
}
```

## 6.4 Crear una Regla Wazuh Personalizada

### 6.4.1 Editar local_rules.xml

```bash
nano config/wazuh/rules/local_rules.xml
```

### 6.4.2 Ejemplo: Detectar Proceso Sospechoso

```xml
<rule id="100600" level="7">
  <match>process.*nc|ncat|netcat</match>
  <description>Suspicious process detected: nc/netcat</description>
  <group>malware</group>
  <mitre>
    <id>T1059</id>
  </mitre>
</rule>
```

### 6.4.3 Guardar y Reiniciar

```bash
docker-compose restart wazuh-manager
```

## 6.5 Configurar Alertas por Email

### 6.5.1 En Zabbix

```
Administration → Media Types → Create Media Type

Name: Email
Type: Email
SMTP Server: smtp.gmail.com
SMTP Port: 587
SMTP Username: tu-email@gmail.com
SMTP Password: app-password
```

### 6.5.2 Asignar a Usuario

```
Administration → Users → Seleccionar usuario → Media

Email: tu-email@ejemplo.com
Media Type: Email
When active: 24/7
```

## 6.6 Restaurar Backup Completo

### 6.6.1 Detener Stack

```bash
docker-compose down
```

### 6.6.2 Restaurar

```bash
bash scripts/restore.sh /data/backups/monitoring-stack-backup-YYYYMMDD.tar.gz
```

### 6.6.3 Reiniciar

```bash
docker-compose up -d
sleep 60
docker-compose ps
```

## 6.7 Escalar a Múltiples Hosts

Ver [07-future-roadmap.md](07-future-roadmap.md) para estrategia FASE 2.

---

Para troubleshooting, ver [05-troubleshooting-guide.md](05-troubleshooting-guide.md).
