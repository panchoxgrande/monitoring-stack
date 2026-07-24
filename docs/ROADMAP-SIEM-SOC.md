# Roadmap: de stack de monitoreo a SIEM/SOC

Este roadmap propone una evolución por etapas. El objetivo no es solo levantar contenedores, sino construir una capacidad operativa medible.

## Fase 0 — Alcance y modelo de amenazas

- Inventariar activos, fuentes de logs, responsables y criticidad.
- Definir amenazas prioritarias y requisitos regulatorios.
- Establecer RPO, RTO, retención y presupuesto de almacenamiento.
- Separar laboratorio, preproducción y producción.

**Salida:** arquitectura aprobada, responsables y criterios de aceptación.

## Fase 1 — Base reproducible

- Copiar `env.conf.example` a `env.conf`.
- Reemplazar todos los valores `CHANGE_ME`.
- Validar con `docker compose --env-file env.conf config --quiet`.
- Mantener versiones explícitas y revisar cambios antes de actualizar.
- Confirmar PostgreSQL 16, heap OpenSearch de 2 GB y límite de 4 GB.

**Salida:** stack recreable sin depender de contenedores antiguos.

## Fase 2 — Hardening

- Habilitar OpenSearch Security.
- Generar CA y certificados independientes para indexer, dashboard y administración.
- Activar TLS entre Wazuh Manager, Dashboard y OpenSearch.
- Mover secretos a Docker Secrets, Vault o un gestor equivalente.
- Rotar las credenciales iniciales y eliminar usuarios no utilizados.
- Limitar puertos mediante firewall, VPN o reverse proxy.
- Eliminar privilegios y mounts sensibles que no sean necesarios.

**Salida:** ninguna interfaz administrativa expuesta sin cifrado y autenticación.

## Fase 3 — Ingesta

- Desplegar agentes Wazuh y Zabbix por grupos.
- Integrar syslog/SNMP de firewalls, switches y servidores.
- Normalizar nombres, zonas, propietarios y criticidad.
- Medir EPS, latencia, pérdida de eventos y crecimiento diario.

**Salida:** cobertura conocida y calidad de datos medible.

## Fase 4 — Detección y visualización

- Crear casos de uso: fuerza bruta, cambios críticos, malware, privilegios, VPN y firewall.
- Ajustar reglas para reducir falsos positivos.
- Mantener un solo datasource funcional por backend en Grafana.
- Construir dashboards ejecutivos y operativos.
- Asociar cada alerta con severidad, propietario y procedimiento.

**Salida:** señales accionables, no solo acumulación de logs.

## Fase 5 — Operación SOC

- Definir triage N1/N2/N3.
- Integrar correo, mensajería o ticketing.
- Crear playbooks para contención, adquisición de evidencia y escalamiento.
- Medir MTTD, MTTA, MTTR, falsos positivos y cobertura MITRE ATT&CK.
- Revisar semanalmente detecciones y mensualmente capacidad.

**Salida:** operación repetible y auditable.

## Fase 6 — Continuidad y DRA

- Dump consistente de PostgreSQL.
- Backup de Grafana y configuración.
- Snapshot de índices OpenSearch en un repositorio externo.
- Cifrado, retención e inmutabilidad de respaldos.
- Restauración trimestral en un host vacío.
- Registrar duración, pérdida de datos y evidencias.

**Salida:** RPO/RTO demostrados, no asumidos.

## Fase 7 — Automatización responsable

- Enriquecimiento con threat intelligence.
- Bloqueos temporales con aprobación o condiciones estrictas.
- Rotación automática de secretos.
- Validaciones CI para Compose, scripts y archivos de configuración.
- Promoción controlada entre laboratorio y producción.

## Criterio de “producción”

El stack solo debe etiquetarse como productivo cuando TLS, secretos, backups, snapshots, restauración, monitoreo del propio stack y procedimientos de respuesta hayan sido probados y documentados.
