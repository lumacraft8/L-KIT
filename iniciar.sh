#!/usr/bin/env bash
# =========================================
# ██╗      ██╗   ██╗███╗   ███╗ █████╗  ██████╗██████╗  █████╗ ███████╗████████╗
# ██║      ██║   ██║████╗ ████║██╔══██╗██╔════╝██╔══██╗██╔══██╗██╔════╝╚══██╔══╝
# ██║      ██║   ██║██╔████╔██║███████║██║     ██████╔╝███████║█████╗      ██║   
# ██║      ██║   ██║██║╚██╔╝██║██╔══██║██║     ██╔══██╗██╔══██║██╔══╝      ██║   
# ███████╗╚██████╔╝██║ ╚═╝ ██║██║  ██║╚██████╗██║  ██║██║  ██║██║        ██║   
# ╚══════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝        ╚═╝   
#
#             • SERVER ENGINE • By SrxMateo •
# =========================================

# --- CONFIGURACIÓN L-KIT ---
SERVER_JAR="server.jar"

# ⚠️ IMPORTANTE: No cambies estos valores manualmente si usas L-KIT.
# El instalador busca exactamente "-Xms1G" y "-Xmx1G" para reemplazarlos por tu RAM real.
RAM_MIN="-Xms1G"
RAM_MAX="-Xmx1G"

# --- AIKAR'S FLAGS (Optimizados 2025) ---
JVM_OPTS="-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 \
-XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch \
-XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M \
-XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 \
-XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 \
-XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 \
-XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 \
-Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true"

# Colores
GREEN="\033[1;32m"; RED="\033[1;31m"; YELLOW="\033[1;33m"
CYAN="\033[1;36m"; WHITE="\033[1;37m"; RESET="\033[0m"

# 1. Detección Inteligente de Java
# (Busca Java instalado, luego Temurin 21, luego Termux)
if command -v java >/dev/null 2>&1; then
    JAVA_PATH=$(command -v java)
elif [ -f "/usr/lib/jvm/temurin-21-jdk-amd64/bin/java" ]; then
    JAVA_PATH="/usr/lib/jvm/temurin-21-jdk-amd64/bin/java"
elif [ -f "$PREFIX/bin/java" ]; then
    JAVA_PATH="$PREFIX/bin/java"
else
    echo -e "${RED}❌ ERROR CRÍTICO: No se encontró Java instalado.${RESET}"
    exit 1
fi

# 2. Verificación de Archivos
if [ ! -f "$SERVER_JAR" ]; then
    echo -e "${RED}❌ Archivo $SERVER_JAR no encontrado.${RESET}"
    echo -e "${YELLOW}💡 Asegúrate de haber instalado el servidor correctamente.${RESET}"
    exit 1
fi

# Auto-Eula
if [ ! -f eula.txt ]; then
    echo "eula=true" > eula.txt
fi

# --- BUCLE DE EJECUCIÓN (ANTI-CRASH) ---
while true; do
    clear
    echo -e "${CYAN}"
    echo " ██╗      ██╗   ██╗███╗   ███╗ █████╗  ██████╗██████╗  █████╗ ███████╗████████╗"
    echo " ██║      ██║   ██║████╗ ████║██╔══██╗██╔════╝██╔══██╗██╔══██╗██╔════╝╚══██╔══╝"
    echo " ██║      ██║   ██║██╔████╔██║███████║██║     ██████╔╝███████║█████╗      ██║   "
    echo " ██║      ██║   ██║██║╚██╔╝██║██╔══██║██║     ██╔══██╗██╔══██║██╔══╝      ██║   "
    echo " ███████╗╚██████╔╝██║ ╚═╝ ██║██║  ██║╚██████╗██║  ██║██║  ██║██║        ██║   "
    echo " ╚══════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝        ╚═╝   "
    echo -e "             ${WHITE}• SERVER ENGINE • By SrxMateo •${RESET}"
    echo ""
    echo -e "      ${GREEN}🚀 INICIANDO LUMACRAFT SERVER 🚀${RESET}"
    echo -e "      ${WHITE}Java:${RESET} ${YELLOW}$JAVA_PATH${RESET} | ${WHITE}RAM:${RESET} ${YELLOW}$RAM_MAX${RESET}"
    echo -e "${CYAN} ==========================================================================${RESET}"
    echo ""
    
    # Ejecución del Servidor (Sin 'tee' para permitir comandos en consola)
    "$JAVA_PATH" $RAM_MIN $RAM_MAX $JVM_OPTS -jar "$SERVER_JAR" nogui

    # Mensaje de Crash / Parada
    echo -e "\n${RED}🛑 El servidor se ha detenido.${RESET}"
    echo -e "${WHITE}⏳ Reinicio automático en:${RESET}"
    
    # Cuenta regresiva
    for i in 5 4 3 2 1; do
        echo -ne "${YELLOW} $i...${RESET}"
        sleep 1
    done
    echo -e "\n${GREEN}🔄 Reiniciando ahora...${RESET}"
done
