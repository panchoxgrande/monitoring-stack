#!/bin/bash
# ============================================================
# ESTADO DE TODOS LOS SERVICIOS
# ============================================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$SCRIPT_DIR"

source "$SCRIPT_DIR/env.conf"

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo ""
echo "============================================================"
echo "  ESTADO DEL STACK DE MONITOREO"
echo "  Servidor: $SERVER_IP"
echo "  Fecha: $(date '+%Y-%m-%d %H:%M:%S')"
echo "============================================================"
echo ""

# Estado de contenedores
docker compose --env-file env.conf ps --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}"
echo ""

# Verificar conectividad
echo "─── Verificación de servicios ───"

check_service() {
    local name="$1"
    local url="$2"
    if curl -s -o /dev/null -w "%{http_code}" "$url" 2>/dev/null | grep -qE "200|302|301"; then
        echo -e "  ${GREEN}✓${NC} $name"
    else
        echo -e "  ${RED}✗${NC} $name"
    fi
}

check_service "Zabbix Web    (http://localhost:8080)" "http://localhost:8080"
check_service "Grafana       (http://localhost:3000)" "http://localhost:3000"
check_service "Wazuh Dash    (http://localhost:5601)" "http://localhost:5601"
check_service "Wazuh API     (https://localhost:55000)" "https://localhost:55000" 2>/dev/null

echo ""
echo "─── Uso de recursos ───"
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}" 2>/dev/null | head -20

echo ""
echo "─── Espacio en disco (datos) ───"
du -sh "$SCRIPT_DIR/data"/* 2>/dev/null
echo ""

echo "─── Backups disponibles ───"
ls -lh "$SCRIPT_DIR/backups/"*.tar.gz 2>/dev/null || echo "  (ninguno)"
echo ""
