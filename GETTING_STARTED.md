# Getting Started — Monitoring Stack

Guía paso a paso para instalar y configurar en 30 minutos.

## Requisitos

- Ubuntu 22.04 LTS (o Docker Desktop)
- Docker + Docker Compose
- 8 GB RAM mínimo para laboratorio (12–16 GB recomendados), 50 GB de disco

## Instalación Rápida

```bash
# 1. Clonar
git clone https://github.com/panchoxgrande/monitoring-stack.git
cd monitoring-stack

# 2. Configurar credenciales
cp env.conf.example env.conf
nano env.conf  # Editar contraseñas

# 3. Iniciar
docker compose --env-file env.conf config --quiet
docker compose --env-file env.conf up -d

# 4. Verificar
docker compose --env-file env.conf ps
```

## Acceder

- **Zabbix:** http://localhost:8080 (Admin / tu-password)
- **Grafana:** http://localhost:3000 (admin / tu-password)
- **Wazuh:** http://localhost:5601 (admin / tu-password)

## Próximos Pasos

1. Conectar tu primer host/firewall → [docs/06-procedures.md](docs/06-procedures.md)
2. Configurar alertas → [docs/03-detailed-configuration.md](docs/03-detailed-configuration.md)
3. Escalar a múltiples hosts → [docs/07-future-roadmap.md](docs/07-future-roadmap.md)

Para ayuda completa, ver [docs/](docs/)
