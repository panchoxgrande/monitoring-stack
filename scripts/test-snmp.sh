#!/bin/bash
# ============================================================
# Script de Prueba SNMPv3 para FortiGate y OPNsense
# ============================================================

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Cargar credenciales desde env.conf
source /home/ubuntu/zabbix-monitoring-stack/env.conf

echo -e "${YELLOW}======================================${NC}"
echo -e "${YELLOW}  Prueba de Conectividad SNMPv3${NC}"
echo -e "${YELLOW}======================================${NC}"
echo ""

# Array de firewalls
declare -A FIREWALLS=(
    ["DATACENTER"]="$FW_DATACENTER"
    ["MÉXICO"]="$FW_MEXICO"
    ["CURICÓ"]="$FW_CURICO"
    ["SAN CARLOS"]="$FW_SAN_CARLOS"
    ["VITACURA"]="$FW_VITACURA"
    ["OPNsense DC"]="$FW_OPNSENSE"
)

# Probar cada firewall
for NAME in "${!FIREWALLS[@]}"; do
    IP="${FIREWALLS[$NAME]}"
    echo -e "${YELLOW}► Probando $NAME ($IP)...${NC}"
    
    RESULT=$(snmpwalk -v3 -l authPriv -u "$SNMP_USER" -a "$SNMP_AUTH_PROTOCOL" -A "$SNMP_AUTH_PASS" -x "$SNMP_PRIV_PROTOCOL" -X "$SNMP_PRIV_PASS" "$IP" 1.3.6.1.2.1.1.1.0 2>&1)
    
    if echo "$RESULT" | grep -q "iso.3.6.1.2.1.1.1.0"; then
        DEVICE_INFO=$(echo "$RESULT" | cut -d'"' -f2)
        echo -e "  ${GREEN}✓ Conectado:${NC} $DEVICE_INFO"
    elif echo "$RESULT" | grep -q "Timeout"; then
        echo -e "  ${RED}✗ Timeout - No hay respuesta${NC}"
    else
        echo -e "  ${RED}✗ Error:${NC} $RESULT"
    fi
    echo ""
done

echo -e "${YELLOW}======================================${NC}"
echo -e "${YELLOW}  Prueba Completada${NC}"
echo -e "${YELLOW}======================================${NC}"
