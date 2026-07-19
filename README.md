# Monitoring Stack — OpenSource

![Status](https://img.shields.io/badge/status-production-brightgreen)
![License](https://img.shields.io/badge/license-MIT-blue)
![Docker](https://img.shields.io/badge/docker-compose-blue?logo=docker)
![OpenSource](https://img.shields.io/badge/opensource-yes-green)

**Stack completo de monitoreo, SIEM y seguridad perimetral. 100% OpenSource. Sin costos. Listo para producción.**

---

## 🎯 ¿Qué es Monitoring Stack?

Un sistema empresarial de **monitoreo + SIEM + seguridad** que integra:

- **Zabbix 7.0** → Monitoreo de infraestructura
- **Grafana 11.4** → 7 dashboards profesionales
- **Wazuh 4.9.2** → SIEM (detección de amenazas)
- **OPNsense/FortiGate** → Firewall perimetral integrado
- **Alertas por WhatsApp** → Notificaciones en tiempo real
- **Backups automáticos** → Local + Cloud
- **Seguridad en capas** → Firewall geográfico, SSH hardening, fail2ban

**Resultado:** Visibilidad total + detección de amenazas + respuestas automáticas.

---

## 🚀 Inicio Rápido (5 minutos)

```bash
git clone https://github.com/panchoxgrande/monitoring-stack.git
cd zabbix-monitoring-stack
cp env.conf.example env.conf
# Editar env.conf con tus credenciales
docker-compose up -d
sleep 60
docker ps
```

✅ **Acceder:**
- Zabbix: http://localhost:8080 (usuario: Admin)
- Grafana: http://localhost:3000 (usuario: admin)
- Wazuh: https://localhost:5601 (usuario: admin)

---

## 📊 7 Dashboards Incluidos

Visualización en tiempo real de:
- KPIs de seguridad (Executive Summary)
- Amenazas detectadas (Threat Analysis)
- Intentos de login (Authentication)
- Bloqueos de firewall (Firewall Security)
- Cambios de archivos (File Integrity)
- Malware detectado (Malware Detection)
- Auditoría (Compliance)

---

## 🔐 Características de Seguridad

- Firewall geográfico (CL/MX/US)
- SSH Hardening (llave ed25519)
- fail2ban anti-fuerza bruta
- HTTPS en todos los dashboards
- WhatsApp Alerts en tiempo real
- Backups automáticos local + cloud
- SIEM completo (Wazuh)

---

## 📖 Documentación

| Documento | Para |
|-----------|------|
| [GETTING_STARTED.md](GETTING_STARTED.md) | Instalar en 30 minutos |
| [docs/](docs/) | Documentación técnica completa |
| [CONTRIBUIR.md](CONTRIBUIR.md) | Cómo contribuir |

---

## 💰 Costo Total

- **Zabbix:** $0 (OpenSource)
- **Grafana:** $0 (OpenSource)
- **Wazuh:** $0 (OpenSource)
- **Servidor:** $10-50/mes
- **Total:** ~$10-50/mes (vs. $500+/mes en soluciones comerciales)

---

## 🌟 Casos de Uso

✅ Empresas medianas (50-500 servidores)
✅ Startups sin presupuesto
✅ MSPs (Managed Service Providers)
✅ Labs/Educación

---

## 📞 Soporte

- Documentación: [docs/](docs/)
- Issues: [GitHub Issues](https://github.com/panchoxgrande/monitoring-stack/issues)
- Discusiones: [GitHub Discussions](https://github.com/panchoxgrande/monitoring-stack/discussions)

---

## 📜 Licencia

MIT License — Libre para usar, modificar y distribuir.

---

**Made with ❤️ | 2026**
