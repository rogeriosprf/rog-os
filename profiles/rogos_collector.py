import psutil
import subprocess
import json

def check_security():
    try:
        status = subprocess.check_output("sudo ufw status", shell=True).decode()
        fw = "Ativo" if "active" in status else "Inativo"
    except:
        fw = "Erro"
    
    # Verifica Microcode
    pkgs = subprocess.check_output("pacman -Qq", shell=True).decode()
    ucode = "OK" if "intel-ucode" in pkgs else "MISSING"
    return fw, ucode

def collect_system_info():
    mem = psutil.virtual_memory()
    fw, ucode = check_security() # Chama a função de segurança
    
    # Lista de manuais e órfãos
    explicit = subprocess.check_output("pacman -Qe", shell=True).decode().splitlines()
    try:
        orphans = subprocess.check_output("pacman -Qdtq", shell=True).decode().split()
    except:
        orphans = []

    data = {
        "cpu_usage_percent": psutil.cpu_percent(interval=1),
        "ram_used_mb": mem.used // 1024**2,
        "ram_total_mb": mem.total // 1024**2,
        "packages": {
            "explicit_count": len(explicit),
            "orphans_count": len(orphans),
            "is_clean": len(orphans) == 0
        },
        "security": {
            "firewall": fw,
            "cpu_patch": ucode
        }
    }
    
    with open("/tmp/rogos_status.json", "w") as f:
        json.dump(data, f, indent=4)

if __name__ == "__main__":
    collect_system_info()
    print("✔ Dados atualizados.")