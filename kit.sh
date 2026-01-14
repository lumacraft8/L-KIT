#!/bin/bash
# ======================================================
# ██╗           ██╗  ██╗██╗████████╗
# ██║           ██║ ██╔╝██║╚══██╔══╝
# ██║     █████╗█████╔╝ ██║   ██║   
# ██║      ════╝██╔═██╗ ██║   ██║   
# ███████╗      ██║  ██╗██║   ██║   
# ╚══════╝      ╚═╝  ╚═╝╚═╝   ╚═╝   
#      L-KIT: THE ARCHITECT EDITION v3.0
#           BY SrxMateo & Sonic
# ======================================================

# --- COLORES & ESTÉTICA PREMIUM ---
GOLD="\033[1;33m"; BLUE="\033[1;34m"; CYAN="\033[1;36m"; GREEN="\033[1;32m"
RED="\033[1;31m"; WHITE="\033[1;37m"; PURPLE="\033[1;35m"; GRAY="\033[0;90m"
RESET="\033[0m"
LOG_FILE="/var/log/l-kit.log"

# Crear log si no existe
if [ ! -f $LOG_FILE ]; then sudo touch $LOG_FILE && sudo chmod 666 $LOG_FILE; fi

# --- GENERADOR DE SCRIPTS DE INICIO (SIN DESCARGAS) ---
generar_iniciar_sh() {
    # $1 = Tipo (server/proxy), $2 = RAM MB
    cat <<EOF > iniciar.sh
#!/bin/bash
# Generado por L-KIT v3.0
# Tipo: $1 | RAM Asignada: $2 MB

RAM_VAL="-Xms$2M -Xmx$2M"

if [ "$1" == "proxy" ]; then
    echo "🔵 Iniciando Proxy (Velocity/Bungee)..."
    java -Xms512M -Xmx1024M -XX:+UseG1GC -XX:G1HeapRegionSize=4M -XX:+UnlockExperimentalVMOptions -XX:+ParallelRefProcEnabled -XX:+AlwaysPreTouch -jar server.jar nogui
else
    echo "🟢 Iniciando Servidor (Paper/Purpur) con Aikar's Flags..."
    java \$RAM_VAL -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=true -Daikars.new.flags=true -jar server.jar nogui
fi
EOF
    chmod +x iniciar.sh
}

# --- IDIOMA ---
select_lang() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════╗${RESET}"
    echo -e "║    🌐 SELECT LANGUAGE / IDIOMA       ║"
    echo -e "${CYAN}╚══════════════════════════════════════╝${RESET}"
    echo -e "  1) Español 🇪🇸"
    echo -e "  2) English 🇺🇸"
    read -p "  >> " lang_opt
    [[ $lang_opt == "2" ]] && L="en" || L="es"
}

# Diccionario
txt() {
    case $L in
        es) case $1 in
            menu_t) echo "MENÚ PRINCIPAL";;
            op_1) echo "VPS CORE (Doctor, Swap, BBR)";;
            op_2) echo "GAME ENGINE (Instalar Servidor)";;
            op_3) echo "SCREEN MANAGER (Gestión de Consolas)";;
            op_4) echo "BACKUPS (Drive & Cron)";;
            op_5) echo "WIKI & AYUDA (Aprende Comandos)";;
            op_6) echo "LUMAMONITOR (Panel en Vivo)";;
            op_0) echo "SALIR";;
            ask_f) echo "¿Crear nueva carpeta para el servidor?";;
            name_f) echo "Nombre de la carpeta (Ej: Survival):";;
            exist_f) echo "⚠ LA CARPETA YA EXISTE.";;
            sel_s) echo "SELECCIONA SOFTWARE:";;
            sel_v) echo "ESCRIBE LA VERSIÓN (Ej: 1.20.4):";;
            down_msg) echo "📥 Buscando última build y descargando...";;
            proxy_msg) echo "✔ Detectado Proxy: Script ligero generado.";;
            ram_msg) echo "🧠 RAM VPS Detectada:";;
            set_msg) echo "⚙ Asignando al servidor (75%):";;
            done) echo "✨ INSTALACIÓN COMPLETADA ✨";;
            wiki_t) echo "📚 L-KIT WIKI";;
            esac;;
        en) case $1 in
            menu_t) echo "MAIN MENU";;
            op_1) echo "VPS CORE (Doctor, Swap, BBR)";;
            op_2) echo "GAME ENGINE (Install Server)";;
            op_3) echo "SCREEN MANAGER (Console Management)";;
            op_4) echo "BACKUPS (Drive & Cron)";;
            op_5) echo "WIKI & HELP (Learn Commands)";;
            op_6) echo "LUMAMONITOR (Live Panel)";;
            op_0) echo "EXIT";;
            ask_f) echo "Create new folder for server?";;
            name_f) echo "Folder name (Ex: Survival):";;
            exist_f) echo "⚠ FOLDER ALREADY EXISTS.";;
            sel_s) echo "SELECT SOFTWARE:";;
            sel_v) echo "TYPE VERSION (Ex: 1.20.4):";;
            down_msg) echo "📥 Searching latest build and downloading...";;
            proxy_msg) echo "✔ Proxy Detected: Light script generated.";;
            ram_msg) echo "🧠 VPS RAM Detected:";;
            set_msg) echo "⚙ Allocating to server (75%):";;
            done) echo "✨ INSTALLATION COMPLETE ✨";;
            wiki_t) echo "📚 L-KIT WIKI";;
            esac;;
    esac
}

# --- WIKI INTERACTIVA ---
wiki_menu() {
    while true; do
        clear
        echo -e "${CYAN}╔══════════════════════════════════════════════════╗${RESET}"
        echo -e "║            $(txt wiki_t)               ║"
        echo -e "${CYAN}╠══════════════════════════════════════════════════╣${RESET}"
        echo -e "║ 1) ${GOLD}SCREEN${RESET} (Cómo dejar servers abiertos)         ║"
        echo -e "║ 2) ${GOLD}LBOT${RESET} (Cómo usar el monitor)                  ║"
        echo -e "║ 3) ${GOLD}JAVA${RESET} (Versiones y compatibilidad)            ║"
        echo -e "║ 0) ${RED}Volver${RESET}                                     ║"
        echo -e "${CYAN}╚══════════════════════════════════════════════════╝${RESET}"
        read -p ">> " w
        case $w in
            1) clear; echo -e "${GOLD}TUTORIAL DE SCREEN:${RESET}"
               echo -e "Para mantener tu servidor encendido al cerrar la consola:"
               echo -e "1. Crear sesión: ${GREEN}screen -S nombre${RESET} (Ej: screen -S survival)"
               echo -e "2. Iniciar server: ${GREEN}./iniciar.sh${RESET}"
               echo -e "3. Salir sin apagar: Presiona ${CYAN}CTRL + A${RESET}, suelta, y luego ${CYAN}D${RESET}."
               echo -e "4. Volver a entrar: ${GREEN}screen -r nombre${RESET}"
               read -p "Enter para volver..." ;;
            2) clear; echo -e "${GOLD}COMANDO LBOT:${RESET}"
               echo -e "L-KIT instala un comando rápido llamado 'lbot'."
               echo -e "Solo escribe ${GREEN}lbot${RESET} en cualquier momento para ver RAM y CPU."
               read -p "Enter para volver..." ;;
            3) clear; echo -e "${GOLD}VERSIONES JAVA:${RESET}"
               echo -e "Java 21 -> Minecraft 1.20.5+"
               echo -e "Java 17 -> Minecraft 1.17 - 1.20.4"
               echo -e "Java 8  -> Minecraft 1.8 - 1.16.5"
               read -p "Enter para volver..." ;;
            0) break ;;
        esac
    done
}

# --- GESTOR DE SCREEN ---
screen_manager() {
    clear
    echo -e "${GOLD}📺 SCREEN MANAGER${RESET}"
    echo -e "---------------------------------"
    echo -e "Sesiones Activas:"
    screen -ls
    echo -e "---------------------------------"
    echo -e "${GRAY}Para entrar a una: screen -r <id>${RESET}"
    read -p "Presiona Enter para volver..."
}

# --- LUMAMONITOR ---
luma_monitor() {
    while true; do
        clear
        ram_u=$(free -m | awk '/Mem:/ { print $3 }'); ram_t=$(free -m | awk '/Mem:/ { print $2 }')
        cpu=$(uptime | awk -F'load average:' '{ print $2 }')
        scr=$(screen -ls | grep -c "tached")
        
        echo -e "${CYAN}╔══════════════════════════════════════════════════╗${RESET}"
        echo -e "║         💎 ${GOLD}LUMAMONITOR - LIVE STATUS${RESET} 💎        ║"
        echo -e "${CYAN}╠═════════════════════════╦════════════════════════╣${RESET}"
        echo -e "║ ${WHITE}RAM:${RESET} $ram_u / $ram_t MB      ║ ${WHITE}CPU:${RESET} $cpu      "
        echo -e "║ ${WHITE}SWAP:${RESET} $(free -m | awk '/Swap:/ { print $2" MB" }')      ║ ${WHITE}SCREENS:${RESET} ${PURPLE}$scr Active${RESET}   "
        echo -e "${CYAN}╠═════════════════════════╩════════════════════════╣${RESET}"
        echo -e "║  ${GRAY}Port 25565:${RESET} [$(sudo ufw status | grep -q "25565" && echo "${GREEN}OPEN${RESET}" || echo "${RED}OFF${RESET}")]  |  ${GRAY}Port 22:${RESET} [$(sudo ufw status | grep -q "22" && echo "${GREEN}OPEN${RESET}" || echo "${RED}OFF${RESET}")]  ║"
        echo -e "${CYAN}╚══════════════════════════════════════════════════╝${RESET}"
        echo -e "  ${GRAY}Presiona [Q] para salir...${RESET}"
        read -t 2 -n 1 k && [[ $k == "q" || $k == "Q" ]] && break
    done
}

# --- ENGINE: INSTALADOR DEFINITIVO ---
game_engine() {
    header
    echo -e "${WHITE}$(txt ask_f) (y/n)${RESET}"
    read -p ">> " cf
    if [[ $cf == "y" ]]; then
        echo -e "${WHITE}$(txt name_f)${RESET}"
        read -p ">> " fname
        if [ -d "$fname" ]; then echo -e "${RED}$(txt exist_f)${RESET}"; sleep 2; return; fi
        mkdir -p "$fname"; cd "$fname" || exit
    fi

    echo -e "\n${GOLD}$(txt sel_s)${RESET}"
    echo -e "1) ${PURPLE}Purpur${RESET} (Recomendado) 1.16 - 1.21"
    echo -e "2) ${BLUE}Paper${RESET} (Estándar) 1.8 - 1.21"
    echo -e "3) ${CYAN}Velocity${RESET} (Proxy Moderno)"
    echo -e "4) ${WHITE}BungeeCord${RESET} (Proxy Clásico)"
    read -p ">> " soft
    
    echo -e "${GOLD}$(txt sel_v)${RESET}"
    read -p ">> " ver
    
    echo -e "${YELLOW}$(txt down_msg)${RESET}"

    # --- LÓGICA DE DESCARGA ROBUSTA ---
    case $soft in
        1) # PURPUR
           wget -q --show-progress "https://api.purpurmc.org/v2/purpur/$ver/latest/download" -O server.jar ;;
        2) # PAPER (API FETCH)
           echo -e "${GRAY}Consultando PaperMC API...${RESET}"
           BUILD=$(curl -s "https://api.papermc.io/v2/projects/paper/versions/$ver/builds" | grep -oE '"build":[0-9]+' | tail -1 | grep -oE '[0-9]+')
           if [ -z "$BUILD" ]; then echo -e "${RED}Error: Versión no encontrada.${RESET}"; return; fi
           wget -q --show-progress "https://api.papermc.io/v2/projects/paper/versions/$ver/builds/$BUILD/downloads/paper-$ver-$BUILD.jar" -O server.jar ;;
        3) # VELOCITY
           echo -e "${GRAY}Consultando Velocity API...${RESET}"
           BUILD=$(curl -s "https://api.papermc.io/v2/projects/velocity/versions/$ver/builds" | grep -oE '"build":[0-9]+' | tail -1 | grep -oE '[0-9]+')
           wget -q --show-progress "https://api.papermc.io/v2/projects/velocity/versions/$ver/builds/$BUILD/downloads/velocity-$ver-$BUILD.jar" -O server.jar ;;
        4) # BUNGEE
           wget -q --show-progress "https://ci.md-5.net/job/BungeeCord/lastSuccessfulBuild/artifact/bootstrap/target/BungeeCord.jar" -O server.jar ;;
    esac

    # Validar descarga
    if [ ! -s server.jar ]; then
        echo -e "${RED}❌ ERROR: El archivo server.jar no se descargó correctamente.${RESET}"
        return
    fi

    echo "eula=true" > eula.txt
    
    # Generar script de inicio automáticamente
    ram_total=$(free -m | awk '/Mem:/ { print $2 }')
    ram_target=$(( ram_total * 75 / 100 ))

    if [[ $soft == "3" || $soft == "4" ]]; then
        generar_iniciar_sh "proxy" "1024"
        echo -e "${GREEN}$(txt proxy_msg)${RESET}"
    else
        generar_iniciar_sh "server" "$ram_target"
        echo -e "${WHITE}$(txt ram_msg) ${BLUE}${ram_total}MB${RESET}"
        echo -e "${WHITE}$(txt set_msg) ${GREEN}${ram_target}MB${RESET}"
    fi

    echo "[$(date)] INSTALLED: Opt $soft Ver $ver" >> $LOG_FILE
    echo -e "\n${GREEN}$(txt done)${RESET}"
    
    # INSTRUCCIONES FINALES
    echo -e "${CYAN}------------------------------------------------${RESET}"
    echo -e "🛠️  PASOS SIGUIENTES:"
    echo -e "1. Escribe: ${GOLD}cd $fname${RESET}"
    echo -e "2. Escribe: ${GOLD}screen -S $fname${RESET} (Para crear sesión)"
    echo -e "3. Escribe: ${GOLD}./iniciar.sh${RESET} (Para encender)"
    echo -e "${CYAN}------------------------------------------------${RESET}"
    echo -e "¿Quieres ver la WIKI para aprender más? (y/n)"
    read -p ">> " ow
    if [[ $ow == "y" ]]; then wiki_menu; fi
}

# --- UTILS ---
core_menu() {
    header
    echo -e "${BLUE}1) DOCTOR VPS:${RESET} Verificar si necesitas SWAP."
    echo -e "${BLUE}2) TCP BBR:${RESET} Optimizar Ping (Google Algorithm)."
    echo -e "${BLUE}3) SWAP CREATE:${RESET} Crear archivo de intercambio (4GB)."
    read -p ">> " c
    case $c in
        1) free -h; read -p "Enter...";;
        2) echo "net.core.default_qdisc=fq" | sudo tee -a /etc/sysctl.conf; echo "net.ipv4.tcp_congestion_control=bbr" | sudo tee -a /etc/sysctl.conf; sudo sysctl -p; echo "BBR ON"; sleep 2;;
        3) sudo fallocate -l 4G /swapfile && sudo chmod 600 /swapfile && sudo mkswap /swapfile && sudo swapon /swapfile; echo "SWAP ON"; sleep 2;;
    esac
}

backup_menu() {
    header
    echo -e "1) Instalar Rclone (Google Drive)"
    echo -e "2) Editar CronJobs (Programar)"
    read -p ">> " b
    case $b in
        1) sudo apt install -y rclone; rclone config;;
        2) crontab -e;;
    esac
}

header() {
    clear
    echo -e "${CYAN} ██╗      ██╗  ██╗██╗████████╗"
    echo " ██║      ██║ ██╔╝██║╚══██╔══╝"
    echo " ██║      █████╔╝ ██║   ██║   "
    echo " ██║      ██╔═██╗ ██║   ██║   "
    echo -e " ███████╗ ██║  ██╗██║   ██║   ${RESET}"
    echo -e " ╚══════╝ ╚═╝  ╚═╝╚═╝   ╚═╝   ${GOLD}SrxMateo v3.0${RESET}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
}

# --- INIT ---
# Instalar dependencias básicas si faltan
if ! command -v jq &> /dev/null; then sudo apt-get update && sudo apt-get install -y jq curl screen > /dev/null; fi

if [[ "$1" == "--monitor" ]]; then
    luma_monitor
else
    select_lang
    while true; do
        header
        echo -e "  ${BLUE}[1]${RESET} $(txt op_1)"
        echo -e "  ${GREEN}[2]${RESET} $(txt op_2)"
        echo -e "  ${GOLD}[3]${RESET} $(txt op_3)"
        echo -e "  ${CYAN}[4]${RESET} $(txt op_4)"
        echo -e "  ${PURPLE}[5]${RESET} $(txt op_5)"
        echo -e "  ${WHITE}[6]${RESET} $(txt op_6)"
        echo -e "  ${RED}[0]${RESET} $(txt op_0)"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
        read -p " >> " op
        case $op in
            1) core_menu ;;
            2) game_engine ;;
            3) screen_manager ;;
            4) backup_menu ;;
            5) wiki_menu ;;
            6) luma_monitor ;;
            0) exit 0 ;;
        esac
    done
fi
