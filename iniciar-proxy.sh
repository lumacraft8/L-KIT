#!/bin/bash
# =========================================
# ██╗      ██╗   ██╗███╗   ███╗ █████╗  ██████╗██████╗  █████╗ ███████╗████████╗
# ██║      ██║   ██║████╗ ████║██╔══██╗██╔════╝██╔══██╗██╔══██╗██╔════╝╚══██╔══╝
# ██║      ██║   ██║██╔████╔██║███████║██║     ██████╔╝███████║█████╗      ██║   
# ██║      ██║   ██║██║╚██╔╝██║██╔══██║██║     ██╔══██╗██╔══██║██╔══╝      ██║   
# ███████╗╚██████╔╝██║ ╚═╝ ██║██║  ██║╚██████╗██║  ██║██║  ██║██║        ██║   
# ╚══════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝        ╚═╝   
#             • by SrxMateo (Velocity) • Sonic •
# =========================================

# --- CONFIGURACIÓN AUTOMÁTICA ---
# L-KIT descarga todo como server.jar. NO CAMBIES ESTO si usas el instalador.
SERVER_JAR="server.jar"

# Velocity consume muy poco. 1GB es el estándar perfecto.
MEM_MIN="512M"
MEM_MAX="1024M"

# --- FLags OFICIALES PARA VELOCITY ---
# Velocity no necesita Aikar's Flags complejos. Necesita G1GC simple.
JVM_OPTS="-XX:+UseG1GC -XX:G1HeapRegionSize=4M -XX:+UnlockExperimentalVMOptions -XX:+ParallelRefProcEnabled -XX:+AlwaysPreTouch -XX:MaxGCPauseMillis=100"

# Colores
MAGENTA="\033[1;35m"; CYAN="\033[1;36m"; WHITE="\033[1;37m"
GREEN="\033[1;32m"; YELLOW="\033[1;33m"; RED="\033[1;31m"; RESET="\033[0m"

# --- DETECCIÓN DE JAVA INTELIGENTE ---
# Velocity requiere Java 17 o 21. Java 8 NO FUNCIONA.
if [ -f "/usr/lib/jvm/temurin-21-jdk-amd64/bin/java" ]; then
    JAVA_CMD="/usr/lib/jvm/temurin-21-jdk-amd64/bin/java"
elif [ -f "/usr/lib/jvm/temurin-17-jdk-amd64/bin/java" ]; then
    JAVA_CMD="/usr/lib/jvm/temurin-17-jdk-amd64/bin/java"
else
    JAVA_CMD="java"
fi

# Comprobar si existe el archivo .jar
if [ ! -f "$SERVER_JAR" ]; then
    echo -e "${RED}❌ ERROR CRÍTICO: No se encuentra el archivo $SERVER_JAR${RESET}"
    echo -e "${YELLOW}💡 Solución: Asegúrate de que descargaste el jar y se llama 'server.jar'.${RESET}"
    echo -e "Archivos actuales en la carpeta:"
    ls
    exit 1
fi

# --- BUCLE DE EJECUCIÓN (ANTI-CRASH) ---
while true; do
    clear
    echo -e "${MAGENTA}"
    echo " ██╗      ██╗   ██╗███╗   ███╗ █████╗  ██████╗██████╗  █████╗ ███████╗████████╗"
    echo " ██║      ██║   ██║████╗ ████║██╔══██╗██╔════╝██╔══██╗██╔══██╗██╔════╝╚══██╔══╝"
    echo " ██║      ██║   ██║██╔████╔██║███████║██║     ██████╔╝███████║█████╗      ██║   "
    echo " ██║      ██║   ██║██║╚██╔╝██║██╔══██║██║     ██╔══██╗██╔══██║██╔══╝      ██║   "
    echo " ███████╗╚██████╔╝██║ ╚═╝ ██║██║  ██║╚██████╗██║  ██║██║  ██║██║        ██║   "
    echo " ╚══════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝        ╚═╝   "
    echo -e "             ${WHITE}• PROXY OPTIMIZER • SrxMateo EDITION •${RESET}"
    echo ""
    echo -e "      ${CYAN}🌐 INICIANDO VELOCITY PROXY${RESET}"
    echo -e "      ${WHITE}Java:${RESET} ${GREEN}$($JAVA_CMD -version 2>&1 | head -n 1 | awk -F '"' '{print $2}')${RESET} | ${WHITE}RAM:${RESET} ${MAGENTA}$MEM_MAX${RESET}"
    echo -e "${MAGENTA} ==========================================================================${RESET}"
    echo ""

    # Ejecutar el servidor
    $JAVA_CMD -Xms$MEM_MIN -Xmx$MEM_MAX $JVM_OPTS -jar $SERVER_JAR

    # Si el servidor se cierra
    echo -e "\n${RED}⚠️  EL PROXY SE HA DETENIDO.${RESET}"
    echo -e "${WHITE}Presiona ${YELLOW}CTRL + C${WHITE} ahora para detener el reinicio.${RESET}"
    echo -e "${WHITE}Reiniciando en:${RESET}"
    
    for i in 3 2 1; do
        echo -ne "${YELLOW}$i... ${RESET}"
        sleep 1
    done
done
