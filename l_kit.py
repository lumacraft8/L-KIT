import os
import sys
import time
import platform
import subprocess
import requests
from rich.console import Console
from rich.panel import Panel
from rich.table import Table
from rich.progress import Progress, SpinnerColumn, TextColumn, BarColumn
from rich.prompt import Prompt, IntPrompt, Confirm
from rich import print as rprint
from rich.align import Align
from rich.layout import Layout
from rich.text import Text

# --- [ CONFIGURACIÓN VISUAL (TEMA CELESTE) ] ---
console = Console()

# Nueva Paleta "Ice Blue"
C_MAIN = "bold cyan"       # Celeste Brillante (Principal)
C_SEC = "bold blue"        # Azul Oscuro (Secundario)
C_OK = "bold green"        # Éxito
C_WARN = "bold yellow"     # Advertencia
C_ERR = "bold red"         # Error
C_TEXT = "white"           # Texto general

# --- [ CLASE CORE DEL SISTEMA ] ---
class LKitSystem:
    def __init__(self):
        self.os_type = platform.system()

    def clear(self):
        os.system('clear' if self.os_type == 'Linux' else 'cls')

    def print_header(self, title, icon="💠"):
        self.clear()
        grid = Table.grid(expand=True)
        grid.add_column(justify="center", ratio=1)
        grid.add_row(f"[{C_SEC}] # ========================================== #[/]")
        grid.add_row(f"[{C_MAIN}] {icon}  {title.upper()}  {icon} [/]")
        grid.add_row(f"[{C_SEC}] # ========================================== #[/]")
        # --- CORRECCIÓN AQUÍ: Se eliminó el estilo inválido ---
        console.print(Panel(grid, border_style="cyan"))
        print("")

    def print_logo(self):
        self.clear()
        logo = """
 ██╗            ██╗  ██╗██╗████████╗
 ██║            ██║  ██╔╝██║╚══██╔══╝
 ██║      █████╗█████╔╝ ██║   ██║    
 ██║      ════╝██╔═██╗  ██║   ██║    
 ███████╗       ██║  ██╗██║   ██║    
 ╚══════╝       ╚═╝  ╚═╝╚═╝   ╚═╝    
      THE ARCHITECT EDITION v3.2     
        """
        console.print(Align.center(f"[{C_MAIN}]{logo}[/]"))
        console.print(Align.center(f"[{C_TEXT}]Automatización de Networks & VPS - By SrxMateo & Sonic[/]\n"))

    def pause(self):
        console.print(f"\n[{C_SEC}]Presiona [ENTER] para continuar...[/]")
        input()

    def run_command(self, command, description):
        """Ejecuta comandos con spinner estético en azul"""
        with Progress(
            SpinnerColumn("dots", style="cyan"),
            TextColumn("[bold blue]{task.description}"),
            BarColumn(bar_width=None, style="blue", complete_style="cyan"),
            transient=True,
        ) as progress:
            task = progress.add_task(description, total=None)
            try:
                time.sleep(0.5)
                subprocess.run(command, shell=True, check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
                console.print(f"[{C_OK}] ✔ EXITO:[/] {description}")
            except subprocess.CalledProcessError:
                console.print(f"[{C_ERR}] ✘ ERROR:[/] Falló: {description}")

    def success_box(self, msg):
        console.print(Panel(Align.center(f"[{C_MAIN}]{msg}[/]"), border_style="green"))

# --- [ MÓDULO 1: HERRAMIENTAS VPS ] ---
def module_vps_tools(sys_core):
    while True:
        sys_core.print_header("Herramientas Básicas VPS", "🛠️")
        
        table = Table(show_header=True, header_style=C_SEC, box=None)
        table.add_column("ID", style="dim", width=4)
        table.add_column("Herramienta", style=C_MAIN)
        table.add_column("Descripción", style=C_TEXT)
        
        table.add_row("1", "🔥 UFW Firewall", "Gestión de puertos (Seguridad)")
        table.add_row("2", "🐬 MariaDB SQL", "Base de datos para plugins")
        table.add_row("3", "☕ Java JDK Kit", "Motores 8, 17 y 21")
        table.add_row("4", "📺 Screen", "Multitarea en terminal")
        table.add_row("5", "🔙 Volver", "")
        
        console.print(Panel(table, title="[bold cyan]Selecciona instalación[/]", border_style="blue"))
        opt = IntPrompt.ask(f"[{C_WARN}]➜[/]", choices=["1", "2", "3", "4", "5"])

        if opt == 1:
            if Confirm.ask("[cyan]¿Instalar UFW y abrir puertos 22/25565/3306?[/]"):
                sys_core.run_command("apt install ufw -y", "Instalando binarios UFW")
                sys_core.run_command("ufw allow 22", "Abriendo SSH (22)")
                sys_core.run_command("ufw allow 25565", "Abriendo Minecraft (25565)")
                sys_core.run_command("ufw allow 3306", "Abriendo MySQL (3306)")
                sys_core.run_command("echo 'y' | ufw enable", "Activando Firewall")
                sys_core.success_box("Firewall Activo y Seguro")
                sys_core.pause()
        
        elif opt == 2:
            sys_core.run_command("apt install mariadb-server -y", "Descargando MariaDB")
            sys_core.success_box("MariaDB Instalado. Ejecuta 'mysql_secure_installation' después.")
            sys_core.pause()

        elif opt == 3:
            console.print(f"\n[{C_MAIN}]Versiones disponibles:[/]")
            console.print("1. Java 21 (Recomendado 1.20.5+)\n2. Java 17 (Estándar)\n3. Java 8 (Legacy)")
            j = IntPrompt.ask("Opción", choices=["1", "2", "3"])
            ver = "openjdk-21-jdk" if j == 1 else "openjdk-17-jdk" if j == 2 else "openjdk-8-jdk"
            sys_core.run_command("apt update", "Actualizando repositorios")
            sys_core.run_command(f"apt install {ver} -y", f"Instalando {ver}")
            sys_core.pause()

        elif opt == 4:
            sys_core.run_command("apt install screen -y", "Instalando Screen")
            sys_core.pause()
        elif opt == 5: break

# --- [ MÓDULO 2: SEGURIDAD Y LIMPIEZA ] ---
def module_security(sys_core):
    sys_core.print_header("Limpieza y Seguridad", "🛡️")
    
    table = Table(box=None)
    table.add_column("Opción", style=C_MAIN)
    table.add_column("Acción", style=C_TEXT)
    
    table.add_row("1. ☁️  Rclone", "Conectar Google Drive/Mega (Backups)")
    table.add_row("2. 📊 Btop++", "Monitor de recursos estilo Cyberpunk")
    table.add_row("3. 🧹 System Clean", "Borrar logs, apt cache y basura")
    table.add_row("4. 🚫 Fail2Ban", "Bloquear hackers (Anti-Bruteforce)")
    table.add_row("5. 🔙 Volver", "")
    
    console.print(Panel(table, border_style="cyan"))
    opt = IntPrompt.ask(f"[{C_WARN}]Elige una opción[/]", choices=["1", "2", "3", "4", "5"])
    
    if opt == 1:
        sys_core.run_command("apt install rclone -y", "Instalando Rclone")
        console.print(f"[{C_OK}]Para configurar escribe: rclone config[/]")
    elif opt == 2:
        sys_core.run_command("apt install btop -y", "Instalando Monitor Btop")
    elif opt == 3:
        with console.status("[bold blue]Eliminando basura del sistema..."):
            sys_core.run_command("journalctl --vacuum-time=1d", "Purgando Logs antiguos")
            sys_core.run_command("apt autoremove -y", "Removiendo dependencias huerfanas")
            sys_core.run_command("apt clean", "Limpiando caché de apt")
        sys_core.success_box("Sistema Limpio y Optimizado")
    elif opt == 4:
        sys_core.run_command("apt install fail2ban -y", "Instalando Fail2Ban")
        sys_core.success_box("Protección contra fuerza bruta activada")
    
    if opt != 5: sys_core.pause()

# --- [ MÓDULO 3: DISEÑO VPS ] ---
def module_design(sys_core):
    sys_core.print_header("Diseño & Personalización", "🎨")
    
    console.print(f"[{C_MAIN}]Dale un toque único a tu terminal[/]")
    console.print("1. 🐚 Instalar ZSH + OhMyZsh (Terminal Pro)")
    console.print("2. 📝 Personalizar Mensaje de Bienvenida (MOTD)")
    console.print("3. 🔙 Volver")
    
    opt = IntPrompt.ask("Opción", choices=["1", "2", "3"])
    
    if opt == 1:
        console.print(f"[{C_WARN}]⚠️  Nota: Esto requiere reiniciar la sesión al finalizar.[/]")
        sys_core.run_command("apt install zsh git fonts-powerline -y", "Instalando Zsh Base")
        console.print(f"[{C_MAIN}]Ejecutando instalador oficial de OhMyZsh...[/]")
        os.system('sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"')
    
    elif opt == 2:
        txt = Prompt.ask(f"[{C_SEC}]Escribe el nombre de tu Network para el banner[/]")
        sys_core.run_command("apt install update-motd -y", "Instalando gestor MOTD")
        with open("/etc/motd", "w") as f:
            f.write(f"\n Welcome to {txt} Network \n Powered by L-KIT \n")
        sys_core.success_box("Mensaje MOTD Actualizado")
        sys_core.pause()

# --- [ MÓDULO 4: CREADOR DE SERVIDORES (API) ] ---
class MinecraftAPIManager:
    def get_paper_versions(self):
        try: return requests.get("https://api.papermc.io/v2/projects/paper").json()["versions"]
        except: return []
    
    def get_latest_build(self, ver):
        try: return requests.get(f"https://api.papermc.io/v2/projects/paper/versions/{ver}").json()["builds"][-1]
        except: return None

    def download(self, url, path):
        with requests.get(url, stream=True) as r:
            total = int(r.headers.get('content-length', 0))
            with open(path, 'wb') as f, Progress() as progress:
                task = progress.add_task("[cyan]Descargando...", total=total)
                for chunk in r.iter_content(8192):
                    f.write(chunk)
                    progress.update(task, advance=len(chunk))

def module_server_creator(sys_core):
    api = MinecraftAPIManager()
    sys_core.print_header("Server Architect API", "🏗️")
    
    name = Prompt.ask(f"[{C_MAIN}]Nombre de la carpeta del servidor[/]")
    path = f"/home/minecraft/{name}"
    
    if os.path.exists(path):
        console.print(f"[{C_ERR}]Error: La carpeta ya existe.[/]"); sys_core.pause(); return

    console.print(Panel("1. Paper (Survival)\n2. Velocity (Proxy)\n3. Purpur (Custom)", title="Software", border_style="blue"))
    soft = IntPrompt.ask("Selecciona", choices=["1", "2", "3"])
    
    if soft == 1:
        with console.status("[bold cyan]Consultando API de PaperMC..."):
            vers = api.get_paper_versions()
        
        console.print(f"[{C_OK}]Versiones Recientes: {', '.join(vers[-5:])}[/]")
        ver = Prompt.ask("Escribe la versión exacta", choices=vers)
        
        build = api.get_latest_build(ver)
        url = f"https://api.papermc.io/v2/projects/paper/versions/{ver}/builds/{build}/downloads/paper-{ver}-{build}.jar"
        
        os.makedirs(path, exist_ok=True)
        console.print(f"[{C_MAIN}]Descargando núcleo en {path}...[/]")
        api.download(url, f"{path}/server.jar")
        
        ram = IntPrompt.ask("GB de RAM")
        flags = "-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1"
        
        with open(f"{path}/start.sh", "w") as f:
            f.write(f"#!/bin/bash\njava -Xms{ram}G -Xmx{ram}G {flags} -jar server.jar --nogui")
        with open(f"{path}/eula.txt", "w") as f: f.write("eula=true")
        
        os.system(f"chmod +x {path}/start.sh")
        sys_core.success_box(f"Servidor creado en {path}")
        sys_core.pause()
    else:
        console.print("[dim]Otras opciones de API en construcción para v3.2[/]")
        sys_core.pause()

# --- [ MÓDULO 5: GEMINI CLI & NODE ] ---
def module_gemini(sys_core):
    sys_core.print_header("Gemini AI Installer", "🤖")
    
    console.print(f"[{C_MAIN}]Este módulo prepara tu entorno para ejecutar IAs basadas en Node.js[/]")
    console.print("1. 📥 Instalar Node.js LTS (Motor)")
    console.print("2. 🧠 Instalar Gemini CLI (Paquete NPM)")
    console.print("3. 🔙 Volver")
    
    opt = IntPrompt.ask("Opción", choices=["1", "2", "3"])
    
    if opt == 1:
        console.print(f"[{C_WARN}]Descargando script de NodeSource...[/]")
        os.system("curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -")
        sys_core.run_command("apt install nodejs -y", "Instalando Node.js & NPM")
        sys_core.success_box("Node.js Instalado Correctamente")
    
    elif opt == 2:
        sys_core.run_command("npm install -g gemini-chat-cli", "Instalando paquete global Gemini")
        console.print(f"[{C_OK}]Ahora puedes usar el comando 'gemini-chat'[/]")
    
    if opt != 3: sys_core.pause()

# --- [ MENÚ PRINCIPAL ] ---
def main():
    sys_core = LKitSystem()
    
    while True:
        sys_core.print_logo()
        
        menu = Table.grid(expand=True, padding=(0, 2))
        menu.add_column(justify="right", style=C_SEC)
        menu.add_column(justify="left", style="bold white")
        
        menu.add_row("1.", "🛠️  Herramientas VPS")
        menu.add_row("2.", "🛡️  Limpieza y Seguridad")
        menu.add_row("3.", "🎨  Diseño de VPS")
        menu.add_row("4.", "🏗️  Creador de Servidores (API)")
        menu.add_row("5.", "🤖  Gemini CLI & Node")
        menu.add_row("6.", "ℹ️  Información")
        menu.add_row("7.", "❌  Salir")
        
        console.print(Panel(Align.center(menu), title="[bold cyan]MAIN MENU[/]", border_style="blue", padding=(1, 5)))
        
        opt = IntPrompt.ask(f"[{C_WARN}]Selecciona una opción[/]", choices=["1", "2", "3", "4", "5", "6", "7"])
        
        if opt == 1: module_vps_tools(sys_core)
        elif opt == 2: module_security(sys_core)
        elif opt == 3: module_design(sys_core)
        elif opt == 4: module_server_creator(sys_core)
        elif opt == 5: module_gemini(sys_core)
        elif opt == 6: 
            sys_core.print_header("Información", "ℹ️")
            console.print(Panel("Desarrollado por SrxMateo & SonicTheGames\nVersión: 3.2 Stable\nLicencia: MIT", title="Credits", border_style="cyan"))
            sys_core.pause()
        elif opt == 7:
            console.print(f"\n[{C_ERR}]Apagando L-KIT... ¡Hasta pronto Arquitecto![/]")
            sys.exit()

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\nSaliendo...")
