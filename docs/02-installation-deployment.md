# 2. Installation & Deployment

Complete step-by-step installation guide from zero to production.

## 2.1 Requisitos

- Ubuntu 22.04 LTS o superior
- Docker 20.10+
- Docker Compose 2.0+
- 4GB RAM mínimo (8GB recomendado)
- 20GB disco mínimo (50GB para producción)

## 2.2 Instalación de Docker

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install -y docker.io docker-compose

# Iniciar servicio
sudo systemctl start docker
sudo systemctl enable docker

# Verificar
docker --version
docker-compose --version
```

## 2.3 Clonar Repositorio

```bash
git clone https://github.com/panchoxgrande/zabbix-monitoring-stack.git
cd zabbix-monitoring-stack
```

## 2.4 Configurar Credenciales

```bash
# Copiar template
cp env.conf.example env.conf

# Editar con credenciales
nano env.conf
```

**Campos obligatorios:**
- ZABBIX_ADMIN_PASSWORD
- GF_SECURITY_ADMIN_PASSWORD
- WAZUH_DASHBOARD_PASSWORD
- POSTGRES_PASSWORD

## 2.5 Iniciar Stack

```bash
# Iniciar en background
docker-compose up -d

# Esperar a que inicie (60 segundos)
sleep 60

# Verificar estado
docker-compose ps

# Ver logs
docker-compose logs -f zabbix-server
```

## 2.6 Verificar Salud

```bash
# Todos los contenedores deben estar healthy
docker-compose ps

# Verificar conectividad
curl http://localhost:8080      # Zabbix
curl http://localhost:3000      # Grafana
curl -k https://localhost:5601  # Wazuh (ignorar SSL)
```

## 2.7 Acceso Inicial

- **Zabbix:** http://localhost:8080 (Admin / password)
- **Grafana:** http://localhost:3000 (admin / password)
- **Wazuh:** https://localhost:5601 (admin / password)

## 2.8 Post-Installation

1. Cambiar contraseñas por defecto
2. Conectar primer host (firewall o servidor)
3. Habilitar dashboards Grafana
4. Configurar alertas WhatsApp (opcional)
5. Configurar backups (opcional)
