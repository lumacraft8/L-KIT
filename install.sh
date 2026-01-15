#!/bin/bash

# ======================================================
# INSTALLER L-KIT: THE ARCHITECT EDITION v3.0
# ======================================================

# Colores
GREEN="\033[1;32m"
CYAN="\033[1;36m"
RED="\033[1;31m"
RESET="\033[0m"

if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}[ERROR] Por favor, ejecuta este instalador como root (sudo).${RESET}"
  exit
fi

echo -e "${CYAN}"
echo "Iniciando instalación de L-KIT..."
echo "================================="
echo -e "${RESET}"

# 1. Instalar Python y PIP si no existen
echo -e "${GREEN}[+] Verificando dependencias del sistema...${RESET}"
apt-get update -qq
apt-get install -y python3 python3-pip git -qq

# 2. Instalar Librerías de Python
echo -e "${GREEN}[+] Instalando librerías visuales (Rich & Requests)...${RESET}"
pip3 install -r requirements.txt --break-system-packages 2>/dev/null || pip3 install -r requirements.txt

# 3. Crear directorio de instalación
INSTALL_DIR="/opt/l-kit"
echo -e "${GREEN}[+] Configurando directorio en $INSTALL_DIR...${RESET}"
mkdir -p $INSTALL_DIR
cp l_kit.py $INSTALL_DIR/
cp requirements.txt $INSTALL_DIR/

# 4. Crear el comando global 'l-kit'
echo -e "${GREEN}[+] Creando acceso directo global 'l-kit'...${RESET}"
cat <<EOF > /usr/bin/l-kit
#!/bin/bash
python3 $INSTALL_DIR/l_kit.py
EOF

chmod +x /usr/bin/l-kit

echo -e "${CYAN}"
echo "================================="
echo "   ¡INSTALACIÓN COMPLETADA! 🚀   "
echo "================================="
echo -e "${RESET}"
echo -e "Ahora puedes escribir el comando ${GREEN}l-kit${RESET} en cualquier lugar para iniciar."
