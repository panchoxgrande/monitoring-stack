#!/usr/bin/env bash
# Validación estática del stack antes de desplegar.
set -u

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

ERRORS=0
WARNINGS=0

ok()   { printf '[OK] %s\n' "$1"; }
warn() { printf '[WARN] %s\n' "$1"; WARNINGS=$((WARNINGS + 1)); }
fail() { printf '[ERROR] %s\n' "$1"; ERRORS=$((ERRORS + 1)); }

printf '%s\n' '=== Validación estática del stack ==='

# 1. Archivos esenciales
required_files=(
  docker-compose.yml
  env.conf.example
  deploy.sh
  start.sh
  stop.sh
  backup.sh
  restore.sh
  config/zabbix-server/zabbix_server.conf
  config/grafana/provisioning/datasources/zabbix.yml
  config/wazuh/wazuh-indexer/opensearch.yml
  config/wazuh/wazuh-manager/ossec.conf
  config/wazuh/wazuh-dashboard/opensearch_dashboards.yml
)

for file in "${required_files[@]}"; do
  if [[ -f "$file" ]]; then
    ok "Existe $file"
  else
    fail "Falta $file"
  fi
done

# 2. Sintaxis Bash
while IFS= read -r -d '' script; do
  if bash -n "$script"; then
    ok "Sintaxis Bash: ${script#./}"
  else
    fail "Sintaxis Bash inválida: ${script#./}"
  fi
done < <(find . -path './.git' -prune -o -name '*.sh' -type f -print0)

# 3. Variables usadas por Compose frente a la plantilla
compose_vars="$(grep -oE '\$\{[A-Za-z_][A-Za-z0-9_]*\}' docker-compose.yml | tr -d '${}' | sort -u)"
example_vars="$(grep -oE '^[A-Za-z_][A-Za-z0-9_]*=' env.conf.example | cut -d= -f1 | sort -u)"

while IFS= read -r var; do
  [[ -z "$var" || "$var" == 'PWD' ]] && continue
  if grep -qx "$var" <<< "$example_vars"; then
    ok "Variable documentada: $var"
  else
    fail "Variable usada por Compose y ausente en env.conf.example: $var"
  fi
done <<< "$compose_vars"

# 4. Validación nativa de Docker Compose cuando está disponible
if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
  temp_env="$(mktemp)"
  cp env.conf.example "$temp_env"
  if PWD="$ROOT_DIR" docker compose --env-file "$temp_env" config --quiet; then
    ok 'docker compose config'
  else
    fail 'docker compose config detectó errores'
  fi
  rm -f "$temp_env"
else
  warn 'Docker Compose no está disponible; se omite la validación nativa del esquema'
fi

# 5. Secretos y archivos que no deben estar versionados
if git ls-files --error-unmatch env.conf >/dev/null 2>&1; then
  fail 'env.conf está versionado'
else
  ok 'env.conf no está versionado'
fi

if git ls-files | grep -Eq '(^|/)(certs|data|backups)/|\.(pem|key|p12|pfx|dump|sql|tar\.gz)$'; then
  fail 'Se detectaron certificados, datos o backups versionados'
else
  ok 'No hay certificados, datos ni backups versionados'
fi

if grep -RInE --exclude-dir=.git --exclude='*.pdf' --exclude='*.md' --exclude='env.conf.example' \
  '(password|passwd|secret|token|api[_-]?key)[[:space:]]*[:=]' . \
  | grep -v '\${' >/tmp/monitoring-stack-secrets.txt; then
  warn 'Se encontraron posibles secretos; revisar /tmp/monitoring-stack-secrets.txt'
else
  ok 'No se detectaron secretos literales evidentes'
fi

printf '\nResultado: %d error(es), %d advertencia(s).\n' "$ERRORS" "$WARNINGS"
[[ "$ERRORS" -eq 0 ]]
