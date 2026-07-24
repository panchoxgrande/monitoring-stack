# Publicación de LinkedIn

## Texto sugerido

¿Se puede construir un SIEM/SOC útil con herramientas open source y entender realmente lo que ocurre debajo?

Sí. Y decidí documentar el camino completo.

Estoy trabajando en **Monitoring Stack**, un laboratorio reproducible que integra:

🔹 Wazuh para SIEM, FIM, vulnerabilidades y detección  
🔹 OpenSearch para almacenar y consultar eventos  
🔹 Zabbix para infraestructura, disponibilidad y SNMP  
🔹 Grafana para visualización y dashboards  
🔹 PostgreSQL como backend de Zabbix  
🔹 Integración con firewalls, servidores, endpoints y canales de alertamiento

Pero levantar contenedores no convierte automáticamente una plataforma en un SOC.

Durante una recreación controlada aparecieron problemas muy reales:

- deriva entre la imagen declarada y el contenedor activo;
- memoria insuficiente para OpenSearch;
- credenciales internas desalineadas;
- errores 401 entre Filebeat y el indexador;
- un dashboard Wazuh en 503;
- datasources Grafana duplicados;
- backups que no cubrían los índices OpenSearch.

Después de corregir y validar el flujo completo, Grafana volvió a consultar miles de eventos Wazuh, el dashboard quedó operativo y la ingesta dejó de registrar errores de autenticación.

Convertí esas lecciones en un roadmap público:

1️⃣ despliegue reproducible;  
2️⃣ hardening, TLS y gestión de secretos;  
3️⃣ ingesta y normalización;  
4️⃣ casos de uso y dashboards;  
5️⃣ operación SOC y métricas;  
6️⃣ snapshots, backups y DRA;  
7️⃣ automatización responsable.

La idea es que puedas montar el laboratorio, romperlo de forma controlada, entenderlo y mejorarlo tú mismo.

Repositorio y roadmap:

https://github.com/panchoxgrande/monitoring-stack

Importante: el proyecto es una base de laboratorio. No debe exponerse a Internet ni considerarse productivo hasta completar TLS, secretos, backups, snapshots y pruebas de restauración.

Si estás construyendo un SOC open source, trabajando con Wazuh/Zabbix/Grafana o quieres aportar mejoras, conversemos.

#CyberSecurity #SOC #SIEM #Wazuh #Zabbix #Grafana #OpenSearch #Docker #OpenSource #BlueTeam #DevSecOps

## Imagen sugerida

Diagrama limpio, fondo oscuro, con el flujo:

`Endpoints + Firewalls → Wazuh/Zabbix → OpenSearch/PostgreSQL → Grafana → SOC`

Título: **Construye tu propio SIEM/SOC Open Source**  
Subtítulo: **Stack, roadmap, hardening y DRA en GitHub**
