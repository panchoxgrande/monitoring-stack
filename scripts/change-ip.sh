#!/bin/bash
# ============================================================
# CAMBIAR IP DEL SERVIDOR
# Uso: ./scripts/change-ip.sh <NUEVA_IP>
# ============================================================
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$SCRIPT_DIR"

if [ -z "$1" ]; then
    echo "Uso: $0 <NUEVA_IP>"
    echo "Ejemplo: $0 192.168.1.100"
    exit 1
fi

NEW_IP="$1"
OLD_IP=$(grep "^SERVER_IP=" env.conf | cut -d= -f2)

echo "============================================================"
echo "  CAMBIO DE IP DEL SERVIDOR"
echo "  IP anterior: $OLD_IP"
echo "  IP nueva:    $NEW_IP"
echo "============================================================"
echo ""

# Actualizar env.conf
sed -i "s/^SERVER_IP=.*/SERVER_IP=$NEW_IP/" "$SCRIPT_DIR/env.conf"
echo "[OK] env.conf actualizado"

# Reiniciar servicios
echo ""
echo "Reiniciando servicios con nueva configuración..."
docker compose --env-file env.conf down
docker compose --env-file env.conf up -d

echo ""
echo "============================================================"
echo "  ¡IP actualizada correctamente!"
echo ""
echo "  Nuevos accesos:"
echo "  Zabbix:  http://${NEW_IP}:8080"
echo "  Grafana: http://${NEW_IP}:3000"
echo "  Wazuh:   http://${NEW_IP}:5601"
echo ""
echo "  IMPORTANTE: Actualizar en los agentes/firewalls:"
echo "  - Zabbix Agent: ServerActive=$NEW_IP"
echo "  - FortiGate SNMP: notify-hosts $NEW_IP"
echo "  - Wazuh Agent: MANAGER_IP=$NEW_IP"
echo "============================================================"
