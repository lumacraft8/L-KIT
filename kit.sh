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

# --- COLORES & CONFIGURACIÓN ---
GOLD="\033[1;33m"; BLUE="\033[1;34m"; CYAN="\033[1;36m"; GREEN="\033[1;32m"
RED="\033[1;31m"; WHITE="\033[1;37m"; PURPLE="\033[1;35m"; GRAY="\033[0;90m"
RESET="\033[0m"
LOG_FILE="/var/log/l-kit.log"

# Crear log si no existe
if [ ! -f $LOG_FILE ]; then sudo touch $LOG_FILE && sudo chmod 666 $LOG_FILE; fi

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

# Textos
txt() {
    case $L in
        es) case $1 in
            menu_t) echo "MENÚ PRINCIPAL";;
            op_1) echo "VPS CORE (Doctor, Swap, BBR)";;
            op_2) echo "GAME ENGINE (Instalar Server)";;
            op_3) echo "BACKUPS (Drive & Cron)";;
            op_4) echo "HISTORIAL & INFO";;
            op_5) echo "LUMAMONITOR (Panel en Vivo)";;
            op_0) echo "SALIR";;
            ask_f) echo "¿Crear nueva carpeta para el servidor?";;
            name_f) echo "Nombre de la carpeta (Ej: Survival):";;
            exist_f) echo "⚠ LA CARPETA YA EXISTE.";;
            sel_s) echo "SELECCIONA SOFTWARE:";;
            sel_v) echo "ESCRIBE LA VERSIÓN EXACTA:";;
            down_msg) echo "📥 Descargando e Instalando...";;
            proxy_msg) echo "✔ Detectado Proxy: Usando script ligero (1GB RAM).";;
            ram_msg) echo "🧠 RAM VPS Detectada:";;
            set_msg) echo "⚙ Asignando al servidor (75%):";;
            done) echo "✨ INSTALACIÓN COMPLETADA ✨";;
            esac;;
        en) case $1 in
            menu_t) echo "MAIN MENU";;
            op_1) echo "VPS CORE (Doctor, Swap, BBR)";;
            op_2) echo "GAME ENGINE (Install Server)";;
            op_3) echo "BACKUPS (Drive & Cron)";;
            op_4) echo "HISTORY & INFO";;
            op_5) echo "LUMAMONITOR (Live Panel)";;
            op_0) echo "EXIT";;
            ask_f) echo "Create new folder for server?";;
            name_f) echo "Folder name (Ex: Survival):";;
            exist_f) echo "⚠ FOLDER ALREADY EXISTS.";;
            sel_s) echo "SELECT SOFTWARE:";;
            sel_v) echo "TYPE EXACT VERSION:";;
            down_msg) echo "📥 Downloading & Installing...";;
            proxy_msg) echo "✔ Proxy Detected: Using light script (1GB RAM).";;
            ram_msg) echo "🧠 VPS RAM Detected:";;
            set_msg) echo "⚙ Allocating to server (75%):";;
            done) echo "✨ INSTALLATION COMPLETE ✨";;
            esac;;
    esac
}

# --- LUMAMONITOR (lbot) ---
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

# --- ENGINE: INSTALADOR INTELIGENTE ---
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
    echo -e "1) ${PURPLE}Purpur${RESET} | 2) ${BLUE}Paper${RESET} | 3) ${CYAN}Velocity${RESET} | 4) ${WHITE}Bungeecord${RESET}"
    read -p ">> " soft
    
    case $soft in
        1) s_name="purpur"; v_rec="1.21.1, 1.20.4, 1.16.5";;
        2) s_name="paper"; v_rec="1.21.1, 1.20.4, 1.8.8";;
        3) s_name="velocity"; v_rec="3.3.0-SNAPSHOT";;
        4) s_name="bungeecord"; v_rec="latest";;
        *) s_name="purpur";;
    esac

    echo -e "\n${WHITE}Recomendadas: ${GRAY}$v_rec${RESET}"
    echo -e "${GOLD}$(txt sel_v)${RESET}"
    read -p ">> " ver

    echo -e "${YELLOW}$(txt down_msg)${RESET}"
    
    # Descarga del Server.jar
    if [[ $s_name == "purpur" ]]; then
        wget -q --show-progress "https://api.purpurmc.org/v2/purpur/$ver/latest/download" -O server.jar
    elif [[ $s_name == "velocity" ]]; then
        # Nota: Velocity URL puede cambiar, usamos una fija para ejemplo o API
        wget -q --show-progress "https://api.papermc.io/v2/projects/velocity/versions/$ver/builds/418/downloads/velocity-$ver-418.jar" -O server.jar
    elif [[ $s_name == "paper" ]]; then
         # Nota: Paper requiere API compleja, usando URL genérica para ejemplo
         wget -q --show-progress "https://api.papermc.io/v2/projects/paper/versions/$ver/builds/latest/downloads/paper-$ver-latest.jar" -O server.jar
    fi

    # --- AQUÍ ESTÁ LA INTELIGENCIA ARTIFICIAL ---
    echo "eula=true" > eula.txt
    
    if [[ $s_name == "velocity" || $s_name == "bungeecord" ]]; then
        # ES PROXY: Descargar script ligero
        wget -q "https://raw.githubusercontent.com/lumacraft8/L-KIT/main/iniciar-proxy.sh" -O iniciar.sh
        chmod +x iniciar.sh
        echo -e "${GREEN}$(txt proxy_msg)${RESET}"
    else
        # ES SERVIDOR: Descargar script potente y ajustar RAM
        wget -q "https://raw.githubusercontent.com/lumacraft8/L-KIT/main/iniciar.sh" -O iniciar.sh
        chmod +x iniciar.sh
        
        ram_total=$(free -m | awk '/Mem:/ { print $2 }')
        ram_target=$(( ram_total * 75 / 100 ))
        
        sed -i "s/-Xms1G/-Xms${ram_target}M/g" iniciar.sh
        sed -i "s/-Xmx1G/-Xmx${ram_target}M/g" iniciar.sh
        
        echo -e "${WHITE}$(txt ram_msg) ${BLUE}${ram_total}MB${RESET}"
        echo -e "${WHITE}$(txt set_msg) ${GREEN}${ram_target}MB${RESET}"
    fi

    echo "[$(date)] INSTALLED: $s_name $ver" >> $LOG_FILE
    echo -e "\n${GREEN}$(txt done)${RESET}"
    echo -e "${GRAY}Start: cd $fname && ./iniciar.sh${RESET}"
    read -p "Enter..."
}

# --- MENÚS UTILIDADES ---
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
    echo -e " ╚══════╝ ╚═╝  ╚═╝╚═╝   ╚═╝   ${GOLD}SrxMateo 6 Sonic v2.0${RESET}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
}

# START
if [[ "$1" == "--monitor" ]]; then
    luma_monitor
else
    select_lang
    while true; do
        header
        echo -e "  ${BLUE}[1]${RESET} $(txt op_1)"
        echo -e "  ${GREEN}[2]${RESET} $(txt op_2)"
        echo -e "  ${CYAN}[3]${RESET} $(txt op_3)"
        echo -e "  ${GOLD}[4]${RESET} $(txt op_4)"
        echo -e "  ${PURPLE}[5]${RESET} $(txt op_5)"
        echo -e "  ${RED}[0]${RESET} $(txt op_0)"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
        read -p " >> " op
        case $op in
            1) core_menu ;;
            2) game_engine ;;
            3) backup_menu ;;
            4) header; tail -n 10 $LOG_FILE; read -p "Enter..." ;;
            5) luma_monitor ;;
            0) exit 0 ;;
        esac
    done
fi
