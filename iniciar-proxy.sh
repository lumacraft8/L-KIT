#!/bin/bash
# =========================================
# ██╗      ██╗   ██╗███╗   ███╗ █████╗  ██████╗██████╗  █████╗ ███████╗████████╗
# ██║      ██║   ██║████╗ ████║██╔══██╗██╔════╝██╔══██╗██╔══██╗██╔════╝╚══██╔══╝
# ██║      ██║   ██║██╔████╔██║███████║██║     ██████╔╝███████║█████╗     ██║   
# ██║      ██║   ██║██║╚██╔╝██║██╔══██║██║     ██╔══██╗██╔══██║██╔══╝     ██║   
# ███████╗ ╚██████╔╝██║ ╚═╝ ██║██║  ██║╚██████╗██║  ██║██║  ██║██║        ██║   
# ╚══════╝  ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝        ╚═╝   
#
#            • By SrxMateo • (Optimized)
# =========================================

# --- CONFIGURACIÓN ---
SERVER_JAR="server.jar"
MEM_MIN="1G"
MEM_MAX="3G"

# JVM flags optimizados (Aikar's Flags v2 - Ajustados)
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

# 1. Detección Inteligente de Java
# Primero busca en el sistema, si no, busca rutas comunes.
if command -v java >/dev/null 2>&1; then
    JAVA_PATH=$(command -v java)
elif [ -f "/usr/lib/jvm/temurin-21-jdk-amd64/bin/java" ]; then
    JAVA_PATH="/usr/lib/jvm/temurin-21-jdk-amd64/bin/java"
elif [ -f "$PREFIX/bin/java" ]; then
    # Soporte para Termux
    JAVA_PATH="$PREFIX/bin/java"
else
    echo -e "${RED}❌ ERROR CRÍTICO: No se encontró Java instalado.${RESET}"
    echo -e "${YELLOW}Instálalo con: pkg install openjdk-17 (Termux) o apt install openjdk-17-jre (Linux)${RESET}"
    exit 1
fi

# 2. Verificación de Archivos
if [ ! -f "$SERVER_JAR" ]; then
    echo -e "${RED}❌ Archivo $SERVER_JAR no encontrado en esta carpeta.${RESET}"
    echo -e "${YELLOW}Asegúrate de que el nombre del archivo coincida en la configuración.${RESET}"
    exit 1
fi

if [ ! -f eula.txt ]; then
    echo "eula=true" > eula.txt
    echo -e "${GREEN}✅ Archivo eula.txt creado automáticamente.${RESET}"
fi

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
    echo -e "             ${WHITE}• By SrxMateo •${RESET}"
    echo ""
    echo -e "      ${GREEN}🚀 INICIANDO LUMACRAFT 🚀${RESET}"
    echo -e "      ${WHITE}Java:${RESET} ${YELLOW}$JAVA_PATH${RESET} | ${WHITE}RAM:${RESET} ${YELLOW}$MEM_MAX${RESET}"
    echo -e "${CYAN} ==========================================================================${RESET}"
    echo ""

    # Ejecución del Servidor
    # NOTA: Se eliminó "| tee" para permitir escribir comandos en la consola
    "$JAVA_PATH" -Xms$MEM_MIN -Xmx$MEM_MAX $JVM_OPTS -jar "$SERVER_JAR" nogui

    # Código de salida
    EXIT_CODE=$?
    
    echo ""
    echo -e "${RED}🛑 El servidor se ha detenido (Código: $EXIT_CODE).${RESET}"
    echo -e "${WHITE}⏳ Reiniciando en 5 segundos... ${RED}(Presiona CTRL+C para cancelar)${RESET}"
    
    # Cuenta regresiva con opción de cancelar
    for i in 5 4 3 2 1; do
        echo -n -e "${YELLOW}$i... ${RESET}"
        sleep 1
    done
    
    echo -e "\n${GREEN}🔄 Reiniciando ahora...${RESET}"
done
