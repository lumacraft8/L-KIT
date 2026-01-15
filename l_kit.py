import os
import sys
import time
import json
import platform
import subprocess
import requests
from rich.console import Console
from rich.panel import Panel
from rich.table import Table
from rich.progress import Progress, SpinnerColumn, TextColumn
from rich.prompt import Prompt, IntPrompt, Confirm
from rich import print as rprint
from rich.align import Align

# --- CONFIGURACIÓN DE DISEÑO ---
console = Console()

# Paleta Cyberpunk
STYLE_TITLE = "bold magenta"
STYLE_OPTION = "cyan"
STYLE_SUCCESS = "bold green"
STYLE_WARNING = "bold yellow"
STYLE_ERROR = "bold red"
STYLE_INFO = "blue"

# --- DICCIONARIO DE IDIOMAS ---
LANG = {
    "ES": {
        "welcome": "Bienvenido a L-KIT: The Architect Edition",
        "loading": "Procesando...",
        "select_opt": "Selecciona una opción",
        "invalid": "Opción inválida.",
        "press_enter": "Presiona ENTER para continuar...",
        "menu_main": "MENÚ PRINCIPAL",
        "desc_java": "Java es el motor necesario para correr Minecraft. Sin él, nada funciona.",
        "desc_screen": "Screen permite mantener tu servidor encendido aunque cierres la terminal.",
        "desc_maria": "MariaDB es la base de datos para guardar permisos, auth y datos de plugins.",
        "installing": "Instalando",
        "fetching_ver": "Buscando versiones disponibles en la API oficial...",
        "server_created": "Servidor creado exitosamente en",
        "opt_ram": "¿Cuánta RAM deseas asignar? (GB)",
        "generating_start": "Generando script de inicio optimizado (Aikar's Flags)...",
        "downloading": "Descargando núcleo desde la nube...",
    },
    "EN": {
        "welcome": "Welcome to L-KIT: The Architect Edition",
        "loading": "Processing...",
        "select_opt": "Select an option",
        "invalid": "Invalid option.",
        "press_enter": "Press ENTER to continue...",
        "menu_main": "MAIN MENU",
        # (Se pueden añadir más traducciones aquí)
    }
}
CURRENT_LANG = "ES"

# --- CLASE PRINCIPAL DEL SISTEMA ---
class LKitSystem:
    def __init__(self):
        self.os_type = platform.system()
        self.user_os = "linux" if self.os_type == "Linux" else "other"

    def clear(self):
        os.system('clear' if self.os_type == 'Linux' else 'cls')

    def print_logo(self):
        self.clear()
        logo = """
 ██╗            ██╗  ██╗██╗████████╗
 ██║            ██║  ██╔╝██║╚══██╔══╝
 ██║      █████╗█████╔╝ ██║   ██║    
 ██║      ════╝██╔═██╗  ██║   ██║    
 ███████╗       ██║  ██╗██║   ██║    
 ╚══════╝       ╚═╝  ╚═╝╚═╝   ╚═╝    
      THE ARCHITECT EDITION v3.0     
        Python API Integration       
        """
        console.print(Panel(Align.center(logo, vertical="middle"), style=STYLE_TITLE, subtitle="By SrxMateo & Sonic"))

    def pause(self):
        console.input(f"\n[{STYLE_INFO}]{LANG[CURRENT_LANG]['press_enter']}[/]")

    def run_command(self, command, description):
        """Ejecuta comandos de sistema con barra de carga visual"""
        with Progress(
            SpinnerColumn("dots", style="magenta"),
            TextColumn("[progress.description]{task.description}"),
            transient=True,
        ) as progress:
            progress.add_task(description=description, total=None)
            try:
                subprocess.run(command, shell=True, check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
                console.print(f"[{STYLE_SUCCESS}] ✔ Hecho: {description}")
            except subprocess.CalledProcessError:
                console.print(f"[{STYLE_ERROR}] ✘ Error al ejecutar: {description}")

# --- GESTOR DE APIS DE MINECRAFT ---
class MinecraftAPIManager:
    def get_paper_versions(self, project="paper"):
        """Consulta la API V2 de PaperMC (Paper, Velocity, Waterfall)"""
        url = f"https://api.papermc.io/v2/projects/{project}"
        try:
            r = requests.get(url)
            if r.status_code == 200:
                return r.json()["versions"]
            return []
        except:
            return []

    def get_latest_build(self, project, version):
        url = f"https://api.papermc.io/v2/projects/{project}/versions/{version}"
        try:
            r = requests.get(url)
            if r.status_code == 200:
                # Obtener la última build disponible (usualmente la última de la lista)
                builds = r.json()["builds"]
                return builds[-1]
            return None
        except:
            return None

    def get_purpur_versions(self):
        """Consulta la API de Purpur"""
        url = "https://api.purpurmc.org/v2/purpur"
        try:
            r = requests.get(url)
            if r.status_code == 200:
                return r.json()["versions"]
            return []
        except:
            return []

    def download_file(self, url, dest_path):
        """Descarga archivo con barra de progreso real"""
        try:
            with requests.get(url, stream=True) as r:
                r.raise_for_status()
                total_length = int(r.headers.get('content-length', 0))
                with open(dest_path, 'wb') as f:
                    with Progress() as progress:
                        task = progress.add_task(f"[cyan]Descargando...", total=total_length)
                        for chunk in r.iter_content(chunk_size=8192):
                            f.write(chunk)
                            progress.update(task, advance=len(chunk))
            return True
        except Exception as e:
            console.print(f"[{STYLE_ERROR}] Error de descarga: {e}")
            return False

# --- MÓDULOS DE MENU ---

def module_vps_tools(sys_core):
    while True:
        sys_core.print_logo()
        console.print(Panel(f"[{STYLE_TITLE}]HERRAMIENTAS BÁSICAS VPS (LINUX)[/]"))
        
        table = Table(show_header=True, header_style="bold magenta")
        table.add_column("#", style="dim")
        table.add_column("Herramienta")
        table.add_column("Descripción")
        
        table.add_row("1", "UFW Firewall", "Seguridad de puertos (22, 25565, 3306)")
        table.add_row("2", "MariaDB", LANG[CURRENT_LANG]['desc_maria'])
        table.add_row("3", "Java JDK", LANG[CURRENT_LANG]['desc_java'])
        table.add_row("4", "Screen", LANG[CURRENT_LANG]['desc_screen'])
        table.add_row("5", "Volver", "")
        
        console.print(table)
        opt = IntPrompt.ask(f"[{STYLE_OPTION}]Elige[/]", choices=["1", "2", "3", "4", "5"])

        if opt == 1:
            console.print(f"[{STYLE_INFO}]Configurando Firewall...[/]")
            sys_core.run_command("apt install ufw -y", "Instalando UFW")
            if Confirm.ask("¿Abrir puertos estándar (SSH, Minecraft, SQL)?"):
                sys_core.run_command("ufw allow 22", "Abriendo puerto 22")
                sys_core.run_command("ufw allow 25565", "Abriendo puerto 25565")
                sys_core.run_command("ufw allow 3306", "Abriendo puerto 3306")
                sys_core.run_command("ufw enable", "Activando Firewall")
            sys_core.pause()
        
        elif opt == 2:
            console.print(f"[{STYLE_INFO}]Instalando Base de Datos...[/]")
            sys_core.run_command("apt install mariadb-server -y", "Instalando MariaDB")
            console.print(f"[{STYLE_WARNING}]Nota: Ejecuta 'mysql_secure_installation' manualmente para configurar root.[/]")
            sys_core.pause()

        elif opt == 3:
            console.print(f"[{STYLE_INFO}]Selecciona versión de Java:[/]")
            console.print("1) Java 21 (MC 1.20.5+)\n2) Java 17 (MC 1.17-1.20.4)\n3) Java 8 (Legacy)")
            j_opt = IntPrompt.ask("Opción", choices=["1", "2", "3"])
            pkg = "openjdk-21-jdk" if j_opt == 1 else "openjdk-17-jdk" if j_opt == 2 else "openjdk-8-jdk"
            sys_core.run_command("apt update", "Actualizando repositorios")
            sys_core.run_command(f"apt install {pkg} -y", f"Instalando {pkg}")
            sys_core.pause()

        elif opt == 4:
            sys_core.run_command("apt install screen -y", "Instalando Screen")
            sys_core.pause()

        elif opt == 5:
            break

def module_server_creator(sys_core):
    api_man = MinecraftAPIManager()
    
    sys_core.print_logo()
    console.print(Panel(f"[{STYLE_TITLE}]CREADOR DE SERVIDORES AUTOMATIZADO (API MODE)[/]"))
    
    server_name = Prompt.ask("Nombre de la carpeta del servidor")
    full_path = f"/home/minecraft/{server_name}"
    
    if os.path.exists(full_path):
        console.print(f"[{STYLE_ERROR}]La carpeta ya existe.[/]")
        sys_core.pause()
        return

    # Selección de Software
    console.print(f"\n[{STYLE_INFO}]Selecciona el Software (Conexión API):[/]")
    console.print("1) [green]Paper[/] (Survival Standard)")
    console.print("2) [magenta]Purpur[/] (Survival Optimizado/Gameplay)")
    console.print("3) [cyan]Velocity[/] (Proxy Network)")
    console.print("4) [blue]Waterfall[/] (Proxy Legacy)")
    
    soft_opt = IntPrompt.ask("Opción", choices=["1", "2", "3", "4"])
    
    project_id = ""
    api_type = "" # paper or purpur
    is_proxy = False
    
    if soft_opt == 1: project_id, api_type = "paper", "paper"
    elif soft_opt == 2: project_id, api_type = "purpur", "purpur"
    elif soft_opt == 3: project_id, api_type, is_proxy = "velocity", "paper", True
    elif soft_opt == 4: project_id, api_type, is_proxy = "waterfall", "paper", True

    # Obtener Versiones Reales
    with console.status(f"[bold magenta]{LANG[CURRENT_LANG]['fetching_ver']}"):
        versions = []
        if api_type == "paper":
            versions = api_man.get_paper_versions(project_id)
        elif api_type == "purpur":
            versions = api_man.get_purpur_versions()
            
    # Mostrar Versiones (Últimas 10 para no saturar)
    display_versions = versions[-10:] # Get last 10
    versions_table = Table(title=f"Versiones Disponibles para {project_id.capitalize()}")
    versions_table.add_column("Versión", justify="center", style="cyan")
    
    for v in display_versions:
        versions_table.add_row(v)
    
    console.print(versions_table)
    selected_ver = Prompt.ask("Escribe la versión EXACTA que deseas instalar", choices=versions)

    # Construir URL de Descarga
    download_url = ""
    build_num = ""
    
    with console.status("[bold magenta]Obteniendo última build estable..."):
        if api_type == "paper":
            build_num = api_man.get_latest_build(project_id, selected_ver)
            download_url = f"https://api.papermc.io/v2/projects/{project_id}/versions/{selected_ver}/builds/{build_num}/downloads/{project_id}-{selected_ver}-{build_num}.jar"
        elif api_type == "purpur":
            download_url = f"https://api.purpurmc.org/v2/purpur/{selected_ver}/latest/download"

    # Crear carpeta y descargar
    os.makedirs(full_path, exist_ok=True)
    console.print(f"[{STYLE_INFO}]Descargando en: {full_path}...[/]")
    
    success = api_man.download_file(download_url, f"{full_path}/server.jar")
    
    if success:
        console.print(f"[{STYLE_SUCCESS}]✔ Núcleo instalado correctamente.[/]")
        
        # Generar Start.sh con Flags
        ram = IntPrompt.ask(f"[{STYLE_OPTION}]GB de RAM a asignar[/]")
        
        aikar_flags = ""
        if is_proxy:
            aikar_flags = "-XX:+UseG1GC -XX:G1HeapRegionSize=4M -XX:+UnlockExperimentalVMOptions -XX:+ParallelRefProcEnabled -XX:+AlwaysPreTouch"
        else:
            aikar_flags = "-Dterminal.jline=false -Dterminal.ansi=true -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1"

        start_content = f"""#!/bin/bash
# Generado por L-KIT v3.0
java -Xms{ram}G -Xmx{ram}G {aikar_flags} -jar server.jar --nogui
"""
        with open(f"{full_path}/start.sh", "w") as f:
            f.write(start_content)
        
        # EULA
        if not is_proxy:
            with open(f"{full_path}/eula.txt", "w") as f:
                f.write("eula=true")

        os.system(f"chmod +x {full_path}/start.sh")
        console.print(f"[{STYLE_SUCCESS}]✔ Todo listo. Ejecuta './start.sh' dentro de la carpeta.[/]")
    
    sys_core.pause()

def module_info(sys_core):
    sys_core.print_logo()
    
    grid = Table.grid(expand=True)
    grid.add_column()
    grid.add_column(justify="right")
    grid.add_row(f"[{STYLE_TITLE}]L-KIT INFO[/]", f"[{STYLE_INFO}]v3.0 Python Edition[/]")
    
    console.print(Panel(grid, title="Sobre Nosotros"))
    
    console.print(f"[{STYLE_OPTION}]Desarrolladores:[/] SrxMateo & SonicTheGames")
    console.print(f"[{STYLE_OPTION}]Misión:[/] Automatizar infraestructuras de Minecraft con código profesional.")
    console.print(f"\n[{STYLE_SUCCESS}]Detectando entorno...[/]")
    console.print(f"- OS: {platform.platform()}")
    console.print(f"- Python: {platform.python_version()}")
    
    sys_core.pause()

# --- ARRANQUE ---

def main():
    sys_core = LKitSystem()
    
    # Selector de Idioma Simple
    sys_core.print_logo()
    console.print("[yellow]1) Español  2) English[/]")
    l_opt = IntPrompt.ask("Language/Idioma", choices=["1", "2"], default=1)
    global CURRENT_LANG
    CURRENT_LANG = "ES" if l_opt == 1 else "EN"

    while True:
        sys_core.print_logo()
        
        # Menú Principal Bonito
        menu_table = Table(show_header=False, box=None)
        menu_table.add_column("Icon", style="bold magenta", width=4)
        menu_table.add_column("Option", style="bold white")
        
        menu_table.add_row("1.", "Herramientas VPS (Setup)")
        menu_table.add_row("2.", "Limpieza y Seguridad")
        menu_table.add_row("3.", "Diseño de VPS")
        menu_table.add_row("4.", "Creador de Servidores (API)")
        menu_table.add_row("5.", "Gemini CLI")
        menu_table.add_row("6.", "Información")
        menu_table.add_row("7.", "Salir")
        
        console.print(Panel(menu_table, title=LANG[CURRENT_LANG]['menu_main'], border_style="blue"))
        
        opcion = IntPrompt.ask(f"[{STYLE_OPTION}]➜[/]", choices=["1", "2", "3", "4", "5", "6", "7"])
        
        if opcion == 1: module_vps_tools(sys_core)
        elif opcion == 2: console.print("[dim]Módulo en desarrollo (lógica similar al anterior)...[/]"); sys_core.pause()
        elif opcion == 3: console.print("[dim]Módulo en desarrollo...[/]"); sys_core.pause()
        elif opcion == 4: module_server_creator(sys_core)
        elif opcion == 5: console.print("[dim]Instalador Gemini Node en proceso...[/]"); sys_core.pause()
        elif opcion == 6: module_info(sys_core)
        elif opcion == 7: 
            console.print("[bold red]Apagando sistemas...[/]")
            sys.exit()

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        console.print("\n[bold red]Interrupción forzada. Saliendo...[/]")
