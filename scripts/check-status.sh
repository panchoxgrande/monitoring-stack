#!/bin/bash
# ============================================================
# Script de Verificación de Estado del Stack
# ============================================================

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Cargar configuración
source /home/ubuntu/zabbix-monitoring-stack/env.conf

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   ESTADO DEL STACK DE MONITOREO${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Función para verificar contenedor
check_container() {
    local name=$1
    local port=$2
    local service=$3
    
    if docker ps --format '{{.Names}}' | grep -q "^${name}$"; then
        echo -e "${GREEN}✓${NC} $service está corriendo"
        if [ ! -z "$port" ]; then
            echo -e "  ${BLUE}→${NC} URL: http://${SERVER_IP}${port}"
        fi
        
        # Mostrar uso de recursos
        local stats=$(docker stats --no-stream --format "{{.CPUPerc}} {{.MemUsage}}" $name)
        echo -e "  ${YELLOW}→${NC} Recursos: $stats"
    else
        echo -e "${RED}✗${NC} $service NO está corriendo"
    fi
    echo ""
}

# Verificar PostgreSQL
echo -e "${YELLOW}► BASE DE DATOS${NC}"
check_container "postgres" ":5432" "PostgreSQL"

# Verificar Zabbix
echo -e "${YELLOW}► ZABBIX${NC}"
check_container "zabbix-server" "" "Zabbix Server"
check_container "zabbix-web-nginx" "" "Zabbix Web Frontend"

# Verificar Grafana
echo -e "${YELLOW}► GRAFANA${NC}"
check_container "grafana" ":3000" "Grafana"

# Verificar Wazuh
echo -e "${YELLOW}► WAZUH${NC}"
check_container "wazuh-manager" "" "Wazuh Manager"
check_container "wazuh-indexer" ":9200" "Wazuh Indexer"
check_container "wazuh-dashboard" ":5601" "Wazuh Dashboard"

# Resumen
echo -e "${BLUE}========================================${NC}"
RUNNING=$(docker ps --format '{{.Names}}' | wc -l)
TOTAL=$(docker ps -a --format '{{.Names}}' | wc -l)
echo -e "${GREEN}Contenedores activos: $RUNNING / $TOTAL${NC}"

# Espacio en disco
echo ""
echo -e "${YELLOW}► ESPACIO EN DISCO${NC}"
df -h /home/ubuntu/zabbix-monitoring-stack/ | tail -1 | awk '{print "  Disponible: "$4" ("$5" usado)"}'

# Backups disponibles
echo ""
echo -e "${YELLOW}► BACKUPS DISPONIBLES${NC}"
BACKUP_COUNT=$(ls -1 /home/ubuntu/zabbix-monitoring-stack/backups/backup-*.tar.gz 2>/dev/null | wc -l)
if [ $BACKUP_COUNT -gt 0 ]; then
    echo -e "  ${GREEN}$BACKUP_COUNT backup(s) encontrado(s)${NC}"
    ls -lht /home/ubuntu/zabbix-monitoring-stack/backups/backup-*.tar.gz | head -3 | awk '{print "  → "$9" ("$5")"}'
else
    echo -e "  ${RED}No hay backups disponibles${NC}"
    echo -e "  ${YELLOW}Ejecuta: ./backup.sh${NC}"
fi

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}Accesos Web:${NC}"
echo -e "  Zabbix:  http://${SERVER_IP}"
echo -e "  Grafana: http://${SERVER_IP}:3000"
echo -e "  Wazuh:   https://${SERVER_IP}:5601"
echo -e "${BLUE}========================================${NC}"
