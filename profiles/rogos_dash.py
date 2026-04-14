import json
import subprocess
import os

def load_data():
    path = "/tmp/rogos_status.json"
    if not os.path.exists(path): return None
    with open(path, "r") as f: return json.load(f)

def run_interface():
    data = load_data()
    if not data:
        subprocess.run(['zenity', '--error', '--text=Rode o coletor primeiro!'])
        return

    status_color = "green" if data['packages']['is_clean'] else "red"
    
    # Montando o texto da janela com os novos dados de segurança
    output = (
        f"<b><big>ROG-OS Dashboard</big></b>\n"
        f"<i>Status: <span foreground='{status_color}'>" + 
        ("SISTEMA ELITE" if data['packages']['is_clean'] else "LIMPEZA PENDENTE") + "</span></i>\n\n"
        
        f"<b>💻 HARDWARE</b>\n"
        f"  CPU: {data['cpu_usage_percent']}% | RAM: {data['ram_used_mb']}MB\n\n"
        
        f"<b>🛡️ SEGURANÇA</b>\n"
        f"  Firewall: {data['security']['firewall']}\n"
        f"  Microcode: {data['security']['cpu_patch']}\n\n"
        
        f"<b>📦 SOFTWARE</b>\n"
        f"  Manuais: {data['packages']['explicit_count']} | Órfãos: {data['packages']['orphans_count']}"
    )

    subprocess.run(['zenity', '--info', '--title=ROG-OS v6.2', '--text=' + output, '--width=350'])

if __name__ == "__main__":
    run_interface()