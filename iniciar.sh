#!/bin/bash
# =========================================
# ██╗      ██╗   ██╗███╗   ███╗ █████╗  ██████╗██████╗  █████╗ ███████╗████████╗
# ██║      ██║   ██║████╗ ████║██╔══██╗██╔════╝██╔══██╗██╔══██╗██╔════╝╚══██╔══╝
# ██║      ██║   ██║██╔████╔██║███████║██║     ██████╔╝███████║█████╗     ██║   
# ██║      ██║   ██║██║╚██╔╝██║██╔══██║██║     ██╔══██╗██╔══██║██╔══╝     ██║   
# ███████╗ ╚██████╔╝██║ ╚═╝ ██║██║  ██║╚██████╗██║  ██║██║  ██║██║        ██║   
# ╚══════╝  ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝        ╚═╝   
#
#            • By SrxMateo •
# =========================================

# --- CONFIGURACIÓN ---
SERVER_JAR="server.jar"
MEM_MIN="1G"
MEM_MAX="3G"
SCREEN_NAME="LumaCraft_Server"

# JVM flags optimizados (Aikar's Flags v2)
JVM_OPTS="-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 \
-XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch \
-XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M \
-XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 \
-XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 \
-XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 \
-XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 \
-Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true"

# Colores
GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
CYAN="\033[1;36m"
WHITE="\033[1;37m"
RESET="\033[0m"

# 1. Detección de Java
JAVA_PATH=$(which java)
if [ -z "$JAVA_PATH" ]; then
    JAVA_PATH="/usr/lib/jvm/temurin-21-jdk-amd64/bin/java"
fi

# 2. Verificación de EULA y Archivo
if [ ! -f "$SERVER_JAR" ]; then
    echo -e "${RED}❌ Archivo $SERVER_JAR no encontrado.${RESET}"
    exit 1
fi
[ ! -f eula.txt ] && echo "eula=true" > eula.txt

# --- BUCLE DE EJECUCIÓN ---
while true; do
    clear
    echo -e "${CYAN}"
    echo " ██╗      ██╗   ██╗███╗   ███╗ █████╗  ██████╗██████╗  █████╗ ███████╗████████╗"
    echo " ██║      ██║   ██║████╗ ████║██╔══██╗██╔════╝██╔══██╗██╔══██╗██╔════╝╚══██╔══╝"
    echo " ██║      ██║   ██║██╔████╔██║███████║██║     ██████╔╝███████║█████╗     ██║   "
    echo " ██║      ██║   ██║██║╚██╔╝██║██╔══██║██║     ██╔══██╗██╔══██║██╔══╝     ██║   "
    echo " ███████╗ ╚██████╔╝██║ ╚═╝ ██║██║  ██║╚██████╗██║  ██║██║  ██║██║        ██║   "
    echo " ╚══════╝  ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝        ╚═╝   "
    echo -e "            ${WHITE}• By SrxMateo •${RESET}"
    echo ""
    echo -e "      ${GREEN}🚀 INICIANDO LUMACRAFT 🚀${RESET}"
    echo -e "      ${WHITE}Sesión:${RESET} ${YELLOW}$SCREEN_NAME${RESET} | ${WHITE}RAM:${RESET} ${YELLOW}$MEM_MAX${RESET}"
    echo -e "${CYAN} ==========================================================================${RESET}"
    echo ""

    # Limpieza de logs antiguos (más de 7 días)
    mkdir -p logs
    find logs/ -name "session_*.log" -mtime +7 -delete > /dev/null 2>&1

    LOG_FILE="logs/session_$(date +%Y-%m-%d_%H-%M).log"
    
    echo -e "${GREEN}🟢 Cargando el motor del servidor...${RESET}"
    echo -e "${WHITE}📝 Registrando log en:${RESET} ${YELLOW}$LOG_FILE${RESET}"
    echo ""

    # Ejecución de Java
    "$JAVA_PATH" -Xms$MEM_MIN -Xmx$MEM_MAX $JVM_OPTS -jar $SERVER_JAR nogui | tee -a "$LOG_FILE"

    echo -e "\n${RED}🛑 El servidor se ha detenido.${RESET}"
    echo -e "${WHITE}⏳ Reinicio automático en:${RESET}"
    
    for i in 5 4 3 2 1; do
        echo -n -e "${YELLOW}$i... ${RESET}"
        sleep 1
    done
    echo -e "\n${GREEN}🔄 Reiniciando ahora...${RESET}"
done
