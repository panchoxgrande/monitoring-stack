#!/bin/bash

###############################################################################
# Monitoring Stack — Script de Instalación Interactivo
#
# Uso:
#   bash install.sh                    # Mostrar menú
#   bash install.sh --auto             # Instalación automática
#   bash install.sh --interactive      # Modo paso a paso (default)
###############################################################################

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variables globales
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
MODE="interactive"
SKIP_PROMPTS=false

###############################################################################
# FUNCIONES HELPER
###############################################################################

print_header() {
  echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
  echo -e "${BLUE}║${NC} $1"
  echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
  echo ""
}

print_step() {
  echo -e "${GREEN}✓${NC} $1"
}

print_info() {
  echo -e "${BLUE}ℹ${NC} $1"
}

print_warn() {
  echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
  echo -e "${RED}✗${NC} $1"
}

pause_if_interactive() {
  if [ "$MODE" == "interactive" ]; then
    read -p "Presiona ENTER para continuar..." -r
  fi
}

###############################################################################
# VERIFICACIONES PREVIAS
###############################################################################

verify_requirements() {
  print_header "Verificando Requisitos"

  local missing=0

  # Verificar Docker
  if ! command -v docker &> /dev/null; then
    print_error "Docker no está instalado"
    echo "  Instala Docker: https://docs.docker.com/get-docker/"
    missing=$((missing+1))
  else
    print_step "Docker instalado"
  fi

  # Verificar Docker Compose
  if ! command -v docker-compose &> /dev/null; then
    print_error "Docker Compose no está instalado"
    echo "  Instala Docker Compose: https://docs.docker.com/compose/install/"
    missing=$((missing+1))
  else
    print_step "Docker Compose instalado"
  fi

  # Verificar Git
  if ! command -v git &> /dev/null; then
    print_error "Git no está instalado"
    missing=$((missing+1))
  else
    print_step "Git instalado"
  fi

  if [ $missing -gt 0 ]; then
    print_error "Faltan $missing requisito(s)"
    echo ""
    echo "Por favor instala los requisitos faltantes y vuelve a ejecutar:"
    echo "  bash install.sh"
    exit 1
  fi

  print_step "Todos los requisitos cumplidos"
  echo ""
  pause_if_interactive
}

###############################################################################
# CONFIGURACIÓN DE CREDENCIALES
###############################################################################

setup_credentials() {
  print_header "Configuración de Credenciales"

  if [ -f "env.conf" ]; then
    print_warn "env.conf ya existe"
    if [ "$SKIP_PROMPTS" == false ]; then
      read -p "¿Usar configuración existente? (s/n) " -n 1 -r
      echo
      if [[ $REPLY =~ ^[Ss]$ ]]; then
        print_step "Usando env.conf existente"
        return 0
      fi
    else
      print_step "Usando env.conf existente (--auto)"
      return 0
    fi
  fi

  # Copiar template
  if [ ! -f "env.conf.example" ]; then
    print_error "env.conf.example no encontrado"
    exit 1
  fi

  cp env.conf.example env.conf
  print_step "Creado env.conf (basado en env.conf.example)"

  if [ "$SKIP_PROMPTS" == true ]; then
    print_info "Modo automático: usando credenciales por defecto"
    print_warn "⚠️  IMPORTANTE: Edita env.conf después de la instalación con tus credenciales"
    echo ""
    return 0
  fi

  # Modo interactivo: permitir edición
  echo ""
  print_info "Ahora configura tus credenciales:"
  echo "  • ZABBIX_ADMIN_PASSWORD"
  echo "  • GF_SECURITY_ADMIN_PASSWORD"
  echo "  • WAZUH_DASHBOARD_PASSWORD"
  echo "  • POSTGRES_PASSWORD"
  echo "  • Opcionales: CALLMEBOT_API_KEY, RCLONE_CONFIG_PATH"
  echo ""

  read -p "¿Abrir editor (nano/vim)? (s/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Ss]$ ]]; then
    ${EDITOR:-nano} env.conf
  fi

  print_step "Credenciales configuradas"
  echo ""
  pause_if_interactive
}

###############################################################################
# INICIAR STACK
###############################################################################

start_stack() {
  print_header "Iniciando Docker Compose Stack"

  print_info "Iniciando 10 contenedores:"
  echo "  • Zabbix Server/Web/Agent/SNMP (monitoreo)"
  echo "  • Grafana (visualización, 7 dashboards)"
  echo "  • PostgreSQL (base de datos)"
  echo "  • Wazuh Manager/Indexer/Dashboard (SIEM)"
  echo ""

  if docker-compose up -d; then
    print_step "Stack iniciado"
  else
    print_error "Fallo al iniciar stack"
    echo "Verifica docker-compose logs:"
    echo "  docker-compose logs"
    exit 1
  fi

  echo ""
  print_info "Esperando a que los contenedores estén listos..."
  echo "  (Esto puede tomar 30-60 segundos)"
  echo ""

  for i in {1..30}; do
    echo -n "."
    sleep 1
  done
  echo ""

  print_step "Contenedores iniciados"
  echo ""
  pause_if_interactive
}

###############################################################################
# VERIFICAR SALUD
###############################################################################

verify_health() {
  print_header "Verificando Salud del Stack"

  echo ""
  docker-compose ps
  echo ""

  # Verificar conectividad
  print_info "Verificando conectividad de servicios..."

  local failures=0

  if curl -s http://localhost:8080 > /dev/null 2>&1; then
    print_step "Zabbix Web (http://localhost:8080)"
  else
    print_warn "Zabbix Web no accesible aún (normal en primeros 60 seg)"
    failures=$((failures+1))
  fi

  if curl -s http://localhost:3000 > /dev/null 2>&1; then
    print_step "Grafana (http://localhost:3000)"
  else
    print_warn "Grafana no accesible aún"
    failures=$((failures+1))
  fi

  if curl -sk https://localhost:5601 > /dev/null 2>&1; then
    print_step "Wazuh Dashboard (https://localhost:5601)"
  else
    print_warn "Wazuh no accesible aún"
    failures=$((failures+1))
  fi

  echo ""
  if [ $failures -eq 0 ]; then
    print_step "Todos los servicios accesibles ✓"
  else
    print_warn "Algunos servicios aún están iniciando (normal)"
    print_info "Espera 1-2 minutos más e intenta acceder"
  fi

  echo ""
  pause_if_interactive
}

###############################################################################
# MOSTRAR INFORMACIÓN DE ACCESO
###############################################################################

show_access_info() {
  print_header "Información de Acceso"

  echo ""
  echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
  echo -e "${GREEN}  ✓ Stack iniciado correctamente${NC}"
  echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
  echo ""
  echo "Accede a los dashboards:"
  echo ""
  echo -e "  ${BLUE}Zabbix:${NC}        http://localhost:8080"
  echo -e "  ${BLUE}Usuario:${NC}        Admin"
  echo -e "  ${BLUE}Contraseña:${NC}     (la que configuraste en env.conf)"
  echo ""
  echo -e "  ${BLUE}Grafana:${NC}       http://localhost:3000"
  echo -e "  ${BLUE}Usuario:${NC}        admin"
  echo -e "  ${BLUE}Contraseña:${NC}     (la que configuraste en env.conf)"
  echo ""
  echo -e "  ${BLUE}Wazuh:${NC}         https://localhost:5601"
  echo -e "  ${BLUE}Usuario:${NC}        admin"
  echo -e "  ${BLUE}Contraseña:${NC}     (la que configuraste en env.conf)"
  echo ""
  echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
  echo ""

  echo "Comandos útiles:"
  echo ""
  echo "  Ver logs de un servicio:"
  echo "    docker-compose logs -f zabbix-server"
  echo "    docker-compose logs -f wazuh-manager"
  echo "    docker-compose logs -f grafana"
  echo ""
  echo "  Ver estado de todos los contenedores:"
  echo "    docker-compose ps"
  echo ""
  echo "  Detener el stack:"
  echo "    docker-compose down"
  echo ""
  echo "  Reiniciar un servicio:"
  echo "    docker-compose restart zabbix-server"
  echo ""

  echo "📚 Documentación:"
  echo "  • Guía de inicio:     GETTING_STARTED.md"
  echo "  • Procedures:         docs/06-procedures.md"
  echo "  • Troubleshooting:    docs/05-troubleshooting-guide.md"
  echo "  • Quick Reference:    docs/08-quick-reference.md"
  echo "  • Documentación:      README.md"
  echo ""
}

###############################################################################
# MOSTRAR MENÚ
###############################################################################

show_menu() {
  print_header "Monitoring Stack - Instalador"

  echo ""
  echo "Selecciona modo de instalación:"
  echo ""
  echo "  1) Automático (rápido, credenciales por defecto)"
  echo "  2) Interactivo (paso a paso, con control total)"
  echo "  3) Salir"
  echo ""
  read -p "Opción (1-3): " -n 1 -r
  echo
  echo ""
}

###############################################################################
# MAIN
###############################################################################

main() {
  # Parsear argumentos
  if [ "$1" == "--auto" ]; then
    MODE="automatic"
    SKIP_PROMPTS=true
  elif [ "$1" == "--interactive" ]; then
    MODE="interactive"
    SKIP_PROMPTS=false
  fi

  # Si no hay argumentos, mostrar menú
  if [ "$1" != "--auto" ] && [ "$1" != "--interactive" ]; then
    show_menu
    case $REPLY in
      1)
        MODE="automatic"
        SKIP_PROMPTS=true
        ;;
      2)
        MODE="interactive"
        SKIP_PROMPTS=false
        ;;
      *)
        print_info "Instalación cancelada"
        exit 0
        ;;
    esac
  fi

  # Mostrar modo seleccionado
  echo ""
  if [ "$MODE" == "automatic" ]; then
    print_header "MODO: AUTOMÁTICO"
    print_info "Instalación rápida (sin preguntas)"
  else
    print_header "MODO: INTERACTIVO"
    print_info "Instalación paso a paso (con explicaciones)"
  fi
  echo ""

  # Ejecutar pasos de instalación
  verify_requirements
  setup_credentials
  start_stack
  verify_health
  show_access_info

  print_header "¡Instalación Completa!"
  echo ""
  echo -e "${GREEN}✓ Monitoring Stack está listo para usar${NC}"
  echo ""
  echo "Próximos pasos:"
  echo "  1. Accede a Zabbix: http://localhost:8080"
  echo "  2. Conecta tu primer host/firewall (ver docs/06-procedures.md)"
  echo "  3. Verifica los dashboards en Grafana"
  echo ""
  echo "¿Problemas? Lee docs/05-troubleshooting-guide.md"
  echo ""
}

# Ejecutar main
main "$@"
