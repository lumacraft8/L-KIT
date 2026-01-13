#!/bin/bash
# ======================================================
# ██╗      ██╗      ██╗  ██╗██╗████████╗
# ██║      ██║      ██║ ██╔╝██║╚══██╔══╝
# ██║      ██║█████╗█████╔╝ ██║   ██║   
# ██║      ██║╚════╝██╔═██╗ ██║   ██║   
# ███████╗ ██║      ██║  ██╗██║   ██║   
# ╚══════╝ ╚═╝      ╚═╝  ╚═╝╚═╝   ╚═╝   
#      L-KIT: THE DEFINITIVE EDITION
#           BY LUMACRAFT8
# ======================================================

# --- COLORES & ESTÉTICA ---
GOLD="\033[1;33m"; BLUE="\033[1;34m"; CYAN="\033[1;36m"; GREEN="\033[1;32m"
RED="\033[1;31m"; WHITE="\033[1;37m"; PURPLE="\033[1;35m"; GRAY="\033[0;90m"
RESET="\033[0m"
LOG_FILE="/var/log/l-kit.log"

# Crear log si no existe
if [ ! -f $LOG_FILE ]; then sudo touch $LOG_FILE && sudo chmod 666 $LOG_FILE; fi

# --- TRADUCCIÓN DINÁMICA ---
select_lang() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════╗${RESET}"
    echo -e "║    🌐 SELECT LANGUAGE / IDIOMA       ║"
    echo -e "${CYAN}╚══════════════════════════════════════╝${RESET}"
    echo -e "  1) Español 🇪🇸"
    echo -e "  2) English 🇺🇸"
    echo -e "  3) Français 🇫🇷"
    echo -e "${GRAY}----------------------------------------${RESET}"
    read -p "  >> " lang_opt
    case $lang_opt in
        1) L="es";; 2) L="en";; 3) L="fr";; *) L="es";;
    esac
}

# Diccionario de Textos
txt() {
    case $L in
        es) case $1 in
            menu_title) echo "MENÚ PRINCIPAL";;
            opt_core) echo "VPS CORE (Doctor, Swap, BBR)";;
            opt_game) echo "MOTOR DE JUEGO (Instalar Server)";;
            opt_back) echo "BACKUPS (Drive & Cron)";;
            opt_hist) echo "HISTORIAL & INFO";;
            opt_mon) echo "LUMAMONITOR (Panel en Vivo)";;
            opt_exit) echo "SALIR";;
            ask_folder) echo "¿Crear nueva carpeta para el servidor?";;
            name_folder) echo "Nombre de la carpeta (Ej: Survival):";;
            folder_exist) echo "⚠ LA CARPETA YA EXISTE.";;
            folder_ok) echo "✔ Carpeta creada:";;
            sel_soft) echo "SELECCIONA SOFTWARE:";;
            sel_ver) echo "ESCRIBE LA VERSIÓN EXACTA:";;
            installing) echo "📥 Descargando e Instalando...";;
            ram_detect) echo "🧠 RAM Detectada:";;
            ram_set) echo "⚙ Asignando al servidor:";;
            done_msg) echo "✨ INSTALACIÓN COMPLETADA ✨";;
            esac;;
        en) case $1 in
            menu_title) echo "MAIN MENU";;
            opt_core) echo "VPS CORE (Doctor, Swap, BBR)";;
            opt_game) echo "GAME ENGINE (Install Server)";;
            opt_back) echo "BACKUPS (Drive & Cron)";;
            opt_hist) echo "HISTORY & INFO";;
            opt_mon) echo "LUMAMONITOR (Live Panel)";;
            opt_exit) echo "EXIT";;
            ask_folder) echo "Create new folder for server?";;
            name_folder) echo "Folder name (Ex: Survival):";;
            folder_exist) echo "⚠ FOLDER ALREADY EXISTS.";;
            folder_ok) echo "✔ Folder created:";;
            sel_soft) echo "SELECT SOFTWARE:";;
            sel_ver) echo "TYPE EXACT VERSION:";;
            installing) echo "📥 Downloading & Installing...";;
            ram_detect) echo "🧠 RAM Detected:";;
            ram_set) echo "⚙ Allocating to server:";;
            done_msg) echo "✨ INSTALLATION COMPLETE ✨";;
            esac;;
        fr) # (Versión francesa simplificada para el ejemplo)
            echo "Option not fully translated";;
    esac
}

# --- LUMAMONITOR (lbot) ---
luma_monitor() {
    while true; do
        clear
        # Datos en tiempo real
        ram_u=$(free -m | awk '/Mem:/ { print $3 }'); ram_t=$(free -m | awk '/Mem:/ { print $2 }')
        cpu_l=$(uptime | awk -F'load average:' '{ print $2 }')
        scr_c=$(screen -ls | grep -c "tached")
        disk_u=$(df -h / | awk 'NR==2 {print $5}')
        
        echo -e "${CYAN}╔══════════════════════════════════════════════════╗${RESET}"
        echo -e "║         💎 ${GOLD}LUMAMONITOR - LIVE STATUS${RESET} 💎        ║"
        echo -e "${CYAN}╠═════════════════════════╦════════════════════════╣${RESET}"
        echo -e "║ ${WHITE}RAM USAGE:${RESET} ${BLUE}$ram_u / $ram_t MB${RESET} ║ ${WHITE}CPU LOAD:${RESET} ${YELLOW}$cpu_l${RESET}"
        echo -e "║ ${WHITE}SWAP:${RESET}      $(free -m | awk '/Swap:/ { print $2" MB" }')      ║ ${WHITE}DISK:${RESET}     $disk_u Used     "
        echo -e "║ ${WHITE}SCREENS:${RESET}   ${PURPLE}$scr_c Active${RESET}    ║ ${WHITE}UPTIME:${RESET}   $(uptime -p | cut -d " " -f2-)"
        echo -e "${CYAN}╠═════════════════════════╩════════════════════════╣${RESET}"
        echo -e "║  ${GRAY}Puertos:${RESET} 22 [$(sudo ufw status | grep -q "22" && echo "${GREEN}ON${RESET}" || echo "${RED}OFF${RESET}")] | 25565 [$(sudo ufw status | grep -q "25565" && echo "${GREEN}ON${RESET}" || echo "${RED}OFF${RESET}")]         ║"
        echo -e "${CYAN}╚══════════════════════════════════════════════════╝${RESET}"
        echo -e "  ${GRAY}Presiona [Q] para salir...${RESET}"
        read -t 2 -n 1 k && [[ $k == "q" || $k == "Q" ]] && break
    done
}

# --- ENGINE: INSTALADOR ---
game_engine() {
    header
    echo -e "${WHITE}$(txt ask_folder) (y/n)${RESET}"
    read -p ">> " cf
    if [[ $cf == "y" ]]; then
        echo -e "${WHITE}$(txt name_folder)${RESET}"
        read -p ">> " fname
        if [ -d "$fname" ]; then echo -e "${RED}$(txt folder_exist)${RESET}"; sleep 2; return; fi
        mkdir -p "$fname"; cd "$fname" || exit
        echo -e "${GREEN}$(txt folder_ok) $fname${RESET}"
    fi

    echo -e "\n${GOLD}$(txt sel_soft)${RESET}"
    echo -e "1) ${PURPLE}Purpur${RESET} (Recomendado) | 2) ${BLUE}Paper${RESET} | 3) ${CYAN}Velocity${RESET} | 4) ${WHITE}Bungeecord${RESET}"
    read -p ">> " soft
    
    case $soft in
        1) s_name="purpur"; v_rec="1.21.1, 1.20.4, 1.19.4"; url_base="https://api.purpurmc.org/v2/purpur";;
        2) s_name="paper"; v_rec="1.21.1, 1.20.4, 1.16.5";; # Requiere lógica API compleja, simplificado para ejemplo
        3) s_name="velocity"; v_rec="3.3.0-SNAPSHOT";;
        *) s_name="purpur";;
    esac

    echo -e "\n${WHITE}Versiones populares: ${GRAY}$v_rec${RESET}"
    echo -e "${GOLD}$(txt sel_ver)${RESET}"
    read -p ">> " ver

    echo -e "${YELLOW}$(txt installing)${RESET}"
    
    # Descarga (Lógica Purpur Directa)
    if [[ $s_name == "purpur" ]]; then
        wget -q --show-progress "$url_base/$ver/latest/download" -O server.jar
    elif [[ $s_name == "velocity" ]]; then
        # URL Fija para ejemplo Velocity
        wget -q --show-progress "https://api.papermc.io/v2/projects/velocity/versions/$ver/builds/418/downloads/velocity-$ver-418.jar" -O server.jar
    else
        echo "Software en desarrollo..."; sleep 2; return
    fi

    # Configuración Automática
    echo "eula=true" > eula.txt
    wget -q "https://raw.githubusercontent.com/lumacraft8/L-KIT/main/iniciar.sh" -O iniciar.sh
    chmod +x iniciar.sh

    # RAM INTELIGENTE
    ram_total=$(free -m | awk '/Mem:/ { print $2 }')
    ram_target=$(( ram_total * 75 / 100 )) # Usa el 75%
    sed -i "s/-Xms1G/-Xms${ram_target}M/g" iniciar.sh
    sed -i "s/-Xmx1G/-Xmx${ram_target}M/g" iniciar.sh

    # Log y Final
    echo "[$(date)] INSTALLED: $s_name $ver in $(pwd)" >> $LOG_FILE
    echo -e "\n${GREEN}$(txt done_msg)${RESET}"
    echo -e "${WHITE}$(txt ram_detect) ${BLUE}${ram_total}MB${RESET} -> $(txt ram_set) ${GREEN}${ram_target}MB${RESET}"
    echo -e "${GRAY}Escribe: cd $fname && ./iniciar.sh${RESET}"
    read -p "Enter..."
}

# --- UTILS (Core, Backup, Info) ---
core_menu() {
    header
    echo -e "${BLUE}1) DOCTOR VPS:${RESET} Verificar SWAP y RAM."
    echo -e "${BLUE}2) TCP BBR:${RESET} Activar optimización de red Google."
    echo -e "${BLUE}3) SWAP CREATE:${RESET} Crear archivo de intercambio (4GB)."
    read -p ">> " co
    case $co in
        1) free -h; read -p "Enter...";;
        2) echo "net.core.default_qdisc=fq" | sudo tee -a /etc/sysctl.conf; echo "net.ipv4.tcp_congestion_control=bbr" | sudo tee -a /etc/sysctl.conf; sudo sysctl -p; echo "${GREEN}BBR ON${RESET}"; sleep 2;;
        3) sudo fallocate -l 4G /swapfile && sudo chmod 600 /swapfile && sudo mkswap /swapfile && sudo swapon /swapfile; echo "${GREEN}SWAP 4GB ON${RESET}"; sleep 2;;
    esac
}

backup_menu() {
    header
    echo -e "${GOLD}OPCIÓN 1: Rclone (Google Drive)${RESET}"
    echo -e "Instala Rclone para conectar tu cuenta de Google."
    echo -e "Comando manual: ${CYAN}rclone config${RESET}\n"
    
    echo -e "${GOLD}OPCIÓN 2: Cronjobs (Automático)${RESET}"
    echo -e "Programa tareas diarias."
    echo -e "Ejemplo: ${CYAN}0 4 * * * tar -czf backup.tar.gz /home/server${RESET}\n"
    
    read -p "1) Instalar Rclone  2) Editar Cron  0) Volver >> " bo
    case $bo in
        1) sudo apt install -y rclone; rclone config;;
        2) crontab -e;;
    esac
}

info_menu() {
    header
    echo -e "${WHITE}HISTORIAL RECIENTE (/var/log/l-kit.log):${RESET}"
    tail -n 5 $LOG_FILE
    echo -e "\n${PURPLE}ℹ INFORMACIÓN:${RESET}"
    echo -e "- ${CYAN}LumaMonitor:${RESET} Usa el comando 'lbot' para ver el panel."
    echo -e "- ${CYAN}Optimización:${RESET} L-KIT ajusta la RAM al 75% del total disponible."
    echo -e "- ${CYAN}Doctor VPS:${RESET} Diagnostica si tu servidor necesita Swap."
    read -p "Enter..."
}

# --- HEADER & MAIN LOOP ---
header() {
    clear
    echo -e "${CYAN} ██╗      ██╗  ██╗██╗████████╗"
    echo " ██║      ██║ ██╔╝██║╚══██╔══╝"
    echo " ██║      █████╔╝ ██║   ██║   "
    echo " ██║      ██╔═██╗ ██║   ██║   "
    echo -e " ███████╗ ██║  ██╗██║   ██║   ${RESET}"
    echo -e " ╚══════╝ ╚═╝  ╚═╝╚═╝   ╚═╝   ${GOLD}ARCHITECT v2.0${RESET}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
}

# Inicio del Script
if [[ "$1" == "--monitor" ]]; then
    luma_monitor
else
    select_lang
    while true; do
        header
        echo -e "  ${BLUE}[1]${RESET} $(txt opt_core)"
        echo -e "  ${GREEN}[2]${RESET} $(txt opt_game)"
        echo -e "  ${CYAN}[3]${RESET} $(txt opt_back)"
        echo -e "  ${GOLD}[4]${RESET} $(txt opt_hist)"
        echo -e "  ${PURPLE}[5]${RESET} $(txt opt_mon)"
        echo -e "  ${RED}[0]${RESET} $(txt opt_exit)"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
        read -p " >> " opt
        case $opt in
            1) core_menu ;;
            2) game_engine ;;
            3) backup_menu ;;
            4) info_menu ;;
            5) luma_monitor ;;
            0) exit 0 ;;
            *) ;;
        esac
    done
fi
