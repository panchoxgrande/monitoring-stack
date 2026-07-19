# 7. Future Roadmap — Fases 2-4

Expansion strategy and planned enhancements.

## 7.1 FASE 1 (Actual) ✅

**Estado:** Completo

- ✅ Zabbix 7.0 + Grafana 11.4
- ✅ Wazuh 4.9.2 SIEM
- ✅ 6 FortiGates + 1 OPNsense (syslog)
- ✅ Alertas WhatsApp
- ✅ Backups automáticos
- ✅ Documentación completa
- ✅ OpenSource en GitHub

**Efecto:** Reducción de 98% en alertas falsas (250+ → 3-5 diarias)

---

## 7.2 FASE 2: Agentes en Endpoints (Q3 2026)

**Objetivo:** Monitoreo granular de 20-100 servidores/PCs

### 7.2.1 Instalar Wazuh Agents

**Windows:**
```powershell
# Descargar installer
https://packages.wazuh.com/4.x/windows/wazuh-agent-4.9.2-1.msi

# Instalar (PowerShell Admin)
msiexec.exe /i wazuh-agent-4.9.2-1.msi /quiet WAZUH_MANAGER_IP=192.168.1.100
```

**Linux:**
```bash
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | apt-key add -
apt-get install wazuh-agent

# Configurar manager
sed -i 's/<manager_ip>/192.168.1.100/' /var/ossec/etc/ossec.conf

# Iniciar
systemctl start wazuh-agent
```

### 7.2.2 File Integrity Monitoring (FIM)

En `ossec.conf`:

```xml
<directories check_all="yes" realtime="yes">/etc,/usr/bin</directories>
<directories check_all="yes" realtime="yes">C:\Windows\System32</directories>
```

### 7.2.3 Resultados Esperados

- Detección de cambios de archivos críticos
- Monitoreo de procesos en tiempo real
- Visibilidad de intentos de acceso
- Compliance reporting

---

## 7.3 FASE 3: Threat Intelligence (Q4 2026)

**Objetivo:** Integrar feeds de amenazas y bloqueo proactivo

### 7.3.1 AlienVault OTX

```bash
# Instalar dependencia
pip install alienvault-otx-python

# Script de sincronización
scripts/threat-feeds/alienvault-sync.sh
```

### 7.3.2 Actualizar FortiGate/OPNsense

```bash
# Feed de IPs maliciosas → blocklist
# Actualización cada 6 horas
*/6 * * * * /scripts/threat-feeds/update-firewall-blocklist.sh
```

### 7.3.3 Resultados Esperados

- Bloqueo automático de IPs maliciosas
- Detección de dominios C2
- Alertas de malware conocido

---

## 7.4 FASE 4: Automatización (2027)

**Objetivo:** Respuestas automáticas ante incidentes

### 7.4.1 FortiGate API Integration

```python
# scripts/integrations/fortigate-api.py
import requests

def block_ip(ip, reason):
    """Bloquear IP automáticamente en FortiGate"""
    payload = {
        "name": f"AUTO_BLOCK_{ip}",
        "action": "deny",
        "srcaddr": ip,
        "comment": reason
    }
    # POST a FortiGate API
```

### 7.4.2 Auto-Isolation

```bash
# Si detecta malware → aislar endpoint
# Deshabilitar acceso a red
# Notificar a SOC
```

### 7.4.3 Playbooks

- **Ransomware detected:** Aislar, alertar, backup
- **Brute force:** Bloquear IP, forzar cambio password
- **Exfiltración:** Cortar acceso, preservar logs

---

## 7.5 Métricas de Éxito

| Métrica | FASE 1 | FASE 2 | FASE 3 | FASE 4 |
|---------|--------|--------|--------|--------|
| % Alertas Falsas | -98% | -99% | -99.5% | -99.9% |
| MTTR (Mean Time to Response) | 30min | 10min | 2min | <30seg |
| Endpoints Monitoreados | 7 | 27 | 27 | 27 |
| Threat Intel Feeds | 0 | 0 | 3+ | 3+ |
| Auto-Remediation | No | No | Parcial | Completo |
| Costo Total | $100-150/mes | $150-200/mes | $200-250/mes | $250-300/mes |

---

## 7.6 Timeline Estimado

```
2026-Q3: FASE 2 (agentes)
2026-Q4: FASE 3 (threat intel)
2027-Q1: FASE 4 (automatización)
2027-Q2: Certificación SOC2/ISO27001
```

---

Para comenzar FASE 2, ver [06-procedures.md](06-procedures.md) → Instalar Wazuh Agents.
