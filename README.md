# Monitoring Stack — SIEM + SOC Open Source

![Status](https://img.shields.io/badge/status-lab%20%2F%20hardening-orange)
![License](https://img.shields.io/badge/license-MIT-blue)
![Docker](https://img.shields.io/badge/docker-compose-blue?logo=docker)
![OpenSource](https://img.shields.io/badge/open%20source-yes-green)

Un laboratorio reproducible para construir capacidades de monitoreo, observabilidad y SIEM con componentes open source.

> Este repositorio entrega una base técnica y un roadmap. No debe exponerse a Internet ni considerarse listo para producción sin completar el hardening, TLS, gestión de secretos, backups y pruebas de restauración.

## Componentes

- **Zabbix 7.0**: monitoreo de infraestructura, SNMP y disponibilidad.
- **Grafana 11.4**: visualización y dashboards.
- **Wazuh 4.9.2**: SIEM, FIM, vulnerabilidades y respuesta.
- **OpenSearch**: almacenamiento y consulta de eventos Wazuh.
- **PostgreSQL 16**: base de datos de Zabbix.
- Integración posible con OPNsense, FortiGate y canales de alertamiento.

## Arquitectura

```text
Endpoints / servidores / firewalls
            |
       Wazuh + Zabbix
         /       \
 OpenSearch     PostgreSQL
         \       /
           Grafana
```

## Requisitos recomendados

- Linux con Docker Engine y Docker Compose v2.
- **8 GB RAM como mínimo para laboratorio**; 12–16 GB recomendados para operar todos los servicios con margen.
- 4 vCPU.
- 50 GB de almacenamiento inicial, ampliable según la retención.
- Puertos protegidos por firewall o reverse proxy; no publicar servicios administrativos directamente en Internet.

El indexador usa un heap Java de 2 GB y un límite de contenedor de 4 GB, configuración validada durante una recreación controlada.

## Inicio rápido

```bash
git clone https://github.com/panchoxgrande/monitoring-stack.git
cd monitoring-stack

cp env.conf.example env.conf
# Reemplaza todos los CHANGE_ME y usa contraseñas únicas.
nano env.conf

docker compose --env-file env.conf config --quiet
docker compose --env-file env.conf up -d
docker compose --env-file env.conf ps
```

Accesos locales por defecto:

- Zabbix: <http://localhost:8080>
- Grafana: <http://localhost:3000>
- Wazuh Dashboard: <http://localhost:5601>

El esquema HTTP corresponde al laboratorio actual. Para producción, termina primero la fase TLS descrita en el roadmap.

## Validación

```bash
docker compose --env-file env.conf ps
curl -fsS http://127.0.0.1:3000/api/health
curl -fsS http://127.0.0.1:8080
```

Consulta [docs/VALIDATION.md](docs/VALIDATION.md) para validar el flujo Wazuh → OpenSearch → Grafana y revisar señales de deriva.

## Roadmap para convertirlo en un SOC

1. Despliegue reproducible y variables sanitizadas.
2. TLS interno y externo.
3. Gestión de secretos y rotación de credenciales.
4. Ingesta de endpoints, servidores y firewalls.
5. Dashboards, reglas, casos de uso y alertamiento.
6. Backups de PostgreSQL, Grafana y snapshots OpenSearch.
7. Ejercicio DRA en un host vacío con medición de RPO/RTO.
8. Automatización de respuesta e integración con ticketing.

Detalle: [docs/ROADMAP-SIEM-SOC.md](docs/ROADMAP-SIEM-SOC.md).

## Estado de seguridad conocido

La configuración pública actual de OpenSearch conserva un modo de laboratorio con la seguridad desactivada. Antes de un despliegue productivo se deben habilitar el plugin de seguridad, certificados TLS y credenciales persistentes. Esto se mantiene explícito para evitar una falsa sensación de seguridad.

No subas:

- `env.conf`
- llaves privadas
- certificados privados
- tokens de APIs
- exports de producción
- archivos `internal_users.yml` con hashes reales del entorno

## Documentación

- [Getting Started](GETTING_STARTED.md)
- [Roadmap SIEM/SOC](docs/ROADMAP-SIEM-SOC.md)
- [Validación del stack](docs/VALIDATION.md)
- [Runbook DRA](docs/DRA-RUNBOOK.md)
- [Documentación técnica](docs/)
- [Contribuir](CONTRIBUIR.md)

## Licencia

MIT. Puedes usar, estudiar y adaptar el proyecto, respetando las licencias individuales de cada componente.

---

Construido para aprender, validar y mejorar de forma abierta. Las contribuciones y reportes de seguridad son bienvenidos.
