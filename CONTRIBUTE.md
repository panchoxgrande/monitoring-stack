# Contributing to Monitoring Stack

Gracias por querer contribuir a este proyecto OpenSource. 🙏

---

## Código de Conducta

- Sé respetuoso con otros contribuidores
- No publicar secretos ni credenciales
- Documentar cambios claramente
- Probar antes de hacer PR

---

## Cómo Contribuir

### 1. Reportar un Bug

Abre un [GitHub Issue](https://github.com/panchoxgrande/monitoring-stack/issues) con:

- **Título claro:** "Zabbix no conecta a PostgreSQL"
- **Descripción:** Qué quisiste hacer, qué pasó, logs relevantes
- **Reproduceabilidad:** Pasos exactos para reproducir
- **Ambiente:** Tu SO, versión Docker, config

### 2. Sugerir una Mejora

Abre un [GitHub Discussion](https://github.com/panchoxgrande/monitoring-stack/discussions) con:

- **Problema que resuelve:** Por qué necesitamos esto
- **Solución propuesta:** Cómo lo implementarías
- **Alternativas:** Otros enfoques considerados

### 3. Escribir Código

#### Fork y Clone
```bash
# Fork en GitHub (botón "Fork")
git clone https://github.com/tu-usuario/monitoring-stack.git
cd monitoring-stack
git remote add upstream https://github.com/panchoxgrande/monitoring-stack.git
```

#### Crear Rama
```bash
git checkout -b feature/tu-feature
# O para fixes: git checkout -b fix/tu-fix
```

#### Cambios
```bash
# Editar archivos
nano config/zabbix/zabbix_server.conf
nano docker-compose.yml
nano docs/

# Commit con mensaje claro
git commit -m "Agrego soporte para Elasticsearch como backend"
```

#### Push y PR
```bash
# Push a tu fork
git push origin feature/tu-feature

# Abre PR en GitHub (verás un botón)
# Describe qué cambió y por qué
```

---

## Tipos de Contribuciones Bienvenidas

✅ **Bugfixes:** Correcciones de errores  
✅ **Features:** Nuevas características  
✅ **Documentation:** Mejoras a docs  
✅ **Dashboards:** Nuevos dashboards Grafana  
✅ **Reglas Wazuh:** Nuevas reglas de detección  
✅ **Procedimientos:** Howtos para tareas comunes  
✅ **Traducciones:** Docs en otros idiomas  
✅ **Ejemplos:** Casos de uso reales  

---

## Checklist para PR

Antes de hacer submit:

- [ ] Testeaste tu cambio localmente
- [ ] Documentaste la modificación
- [ ] Sin secretos en el código
- [ ] Mensaje de commit claro
- [ ] Rama actualizada con `main`
- [ ] Agregaste referencias a Issues relacionados

---

## Estructura del Proyecto

```
monitoring-stack/
├── docker-compose.yml          # Stack principal
├── env.conf.example            # Template de credenciales
├── .gitignore                  # (env.conf, secrets no se suben)
├── config/                     # Configuraciones
│   ├── zabbix/                 # Zabbix server + web
│   ├── grafana/                # Grafana + datasources
│   ├── wazuh/                  # Wazuh manager + dashboard
│   └── fail2ban/               # fail2ban rules
├── dashboards/                 # Dashboards Grafana (JSON)
├── docs/                       # Documentación
│   ├── 01-system-architecture.md
│   ├── 02-installation-deployment.md
│   ├── 03-detailed-configuration.md
│   ├── 04-operations-runbook.md
│   ├── 05-troubleshooting-guide.md
│   ├── 06-procedures.md
│   ├── 07-future-roadmap.md
│   └── 08-quick-reference.md
├── scripts/                    # Scripts de automatización
│   ├── backup.sh
│   ├── restore.sh
│   └── update.sh
├── README.md                   # Archivo principal
├── GETTING_STARTED.md          # Guía de inicio
├── CONTRIBUTE.md               # Este archivo
├── LICENSE                     # MIT License
└── CHANGELOG.md                # Historial de cambios
```

---

## Áreas Activas para Contribuir

### 1. Dashboards Grafana
Crear dashboards nuevos para:
- Monitoring de Kubernetes
- Análisis de costos en cloud
- Compliance reports
- Security metrics avanzadas

**Cómo:** Crear dashboard en Grafana → Export JSON → PR con archivo

### 2. Reglas Wazuh
Nuevas reglas de detección para:
- Ataques específicos de industria
- Patrones de malware nuevo
- Anomalías de red
- Cambios de configuración riesgosos

**Cómo:** Editar `/config/wazuh/rules/` → PR

### 3. Procedimientos
Documentar cómo:
- Conectar nuevos tipos de firewall
- Integrar con CMDB
- Escalar a 1000+ hosts
- Implementar en Kubernetes

**Cómo:** Crear `.md` en `docs/procedures/` → PR

### 4. Integraciones
Agregar soporte para:
- Slack, Teams, Discord (alertas)
- PagerDuty (on-call escalation)
- Jira (ticketing)
- ServiceNow (ITSM)

**Cómo:** Crear script en `scripts/integrations/` → PR

### 5. Documentación
- Traducir a otros idiomas
- Mejorar diagramas
- Agregar videos tutoriales
- Escribir casos de uso reales

---

## Testing

Antes de hacer PR, testea localmente:

```bash
# Iniciar stack
docker-compose up -d

# Verificar estado
docker-compose ps

# Ver logs
docker-compose logs -f

# Acceder a paneles
# Zabbix: http://localhost:8080
# Grafana: http://localhost:3000
# Wazuh: https://localhost:5601
```

---

## Commitmessage Guidelines

Usa formato claro:

```
[Tipo] Descripción corta

Descripción detallada de qué y por qué cambió.

Relacionado a: #123 (numero de issue)
```

**Tipos:** `[Feature]`, `[Fix]`, `[Docs]`, `[Test]`, `[Refactor]`

**Ejemplos:**
```
[Feature] Agregar soporte para alertas por Slack

Implementé el webhook de Slack para recibir alertas críticas.
Usa la API de Slack Webhooks. Documentado en docs/procedures.

Relacionado a: #42
```

```
[Fix] Corregir conexión OpenSearch fallida

El contenedor wazuh-indexer no iniciaba por certificados. 
Regeneré los certs y actualicé docker-compose.yml.

Relacionado a: #18
```

---

## Revisión de PR

Un mantenedor revisará tu PR y podrá:
- ✅ Merguear (aprobado)
- 📝 Pedir cambios
- ❌ Rechazar (si no encaja con el proyecto)

---

## Preguntas?

- **Duda sobre contribución:** Abre [GitHub Discussion](https://github.com/panchoxgrande/monitoring-stack/discussions)
- **Bug encontrado:** [GitHub Issue](https://github.com/panchoxgrande/monitoring-stack/issues)
- **Código no funciona:** Tag a mantenedor en PR

---

## Reconocimiento

Todos los contribuidores serán listados en [CONTRIBUTORS.md](CONTRIBUTORS.md) y en releases.

---

**¡Gracias por contribuir! 🙏**

*Monitoring Stack es mejor gracias a gente como tú.*
