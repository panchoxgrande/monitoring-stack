# Getting Started — Monitoring Stack

Guía paso a paso para instalar y configurar en 30 minutos.

## Requisitos

- Ubuntu 22.04 LTS (o Docker Desktop)
- Docker + Docker Compose
- 4GB RAM mínimo, 20GB disco

## Instalación Rápida

```bash
# 1. Clonar
git clone https://github.com/panchoxgrande/monitoring-stack.git
cd zabbix-monitoring-stack

# 2. Configurar credenciales
cp env.conf.example env.conf
nano env.conf  # Editar contraseñas

# 3. Iniciar
docker-compose up -d
sleep 60

# 4. Verificar
docker-compose ps
```

## Acceder

- **Zabbix:** http://localhost:8080 (Admin / tu-password)
- **Grafana:** http://localhost:3000 (admin / tu-password)
- **Wazuh:** https://localhost:5601 (admin / tu-password)

## Próximos Pasos

1. Conectar tu primer host/firewall → [docs/06-procedures.md](docs/06-procedures.md)
2. Configurar alertas → [docs/03-detailed-configuration.md](docs/03-detailed-configuration.md)
3. Escalar a múltiples hosts → [docs/07-future-roadmap.md](docs/07-future-roadmap.md)

Para ayuda completa, ver [docs/](docs/)
