#!/bin/bash
# ============================================================
# PRUEBA DE CONECTIVIDAD SNMPv3 A FIREWALLS
# ============================================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/env.conf"

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo ""
echo "============================================================"
echo "  PRUEBA SNMPv3 - Firewalls Comfrut"
echo "  Usuario: $SNMP_USER"
echo "  Auth: $SNMP_AUTH_PROTOCOL / Priv: $SNMP_PRIV_PROTOCOL"
echo "============================================================"
echo ""

# Instalar snmp si no está disponible
if ! command -v snmpwalk &> /dev/null; then
    echo "Instalando herramientas SNMP..."
    sudo apt-get install -y snmp snmp-mibs-downloader 2>/dev/null
fi

declare -A FIREWALLS
FIREWALLS=(
    ["DATACENTER"]="$FW_DATACENTER"
    ["MEXICO"]="$FW_MEXICO"
    ["CURICO"]="$FW_CURICO"
    ["SAN_CARLOS"]="$FW_SAN_CARLOS"
    ["VITACURA"]="$FW_VITACURA"
    ["OPNSENSE"]="$FW_OPNSENSE"
)

for NOMBRE in "${!FIREWALLS[@]}"; do
    IP="${FIREWALLS[$NOMBRE]}"
    echo -n "  $NOMBRE ($IP): "
    
    RESULT=$(snmpwalk -v3 -l authPriv \
        -u "$SNMP_USER" \
        -a "$SNMP_AUTH_PROTOCOL" -A "$SNMP_AUTH_PASS" \
        -x "$SNMP_PRIV_PROTOCOL" -X "$SNMP_PRIV_PASS" \
        "$IP" 1.3.6.1.2.1.1.1.0 2>&1)
    
    if echo "$RESULT" | grep -q "STRING"; then
        DEVICE=$(echo "$RESULT" | sed 's/.*STRING: "\(.*\)"/\1/')
        echo -e "${GREEN}✓ CONECTADO${NC} - $DEVICE"
    else
        echo -e "${RED}✗ SIN RESPUESTA${NC} (Timeout o firewall bloqueando)"
    fi
done

echo ""
echo "Si algún firewall no responde, verificar:"
echo "  1. Que SNMP esté habilitado en la interfaz WAN"
echo "  2. Que el usuario SNMPv3 exista en el equipo"
echo "  3. Que el firewall permita SNMP desde $SERVER_IP"
echo ""
