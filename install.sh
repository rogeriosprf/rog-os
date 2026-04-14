#!/bin/bash

# --- ROG-OS Core v1.0 - Bootstrap Script ---
echo "🚀 Iniciando a restauração do ROG-OS Core..."

# 1. Atualização e Preparação
echo "📦 Atualizando repositórios..."
sudo pacman -Syu --noconfirm

# 2. Instalação da Base
echo "📦 Instalando pacotes do manifesto..."
if [ -f "packages.txt" ]; then
    sudo pacman -S --needed --noconfirm - < packages.txt
else
    echo "❌ Erro: packages.txt não encontrado!"
    exit 1
fi

# 3. Segurança (Ativação Imediata)
echo "🛡️ Configurando e ativando Firewall (UFW)..."
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw --force enable

# 4. Restauração de Configurações (Dotfiles)
echo "🎨 Restaurando configurações de interface..."
mkdir -p ~/.config/openbox
mkdir -p ~/.config/lxpanel/LXDE/panels
cp configs/openbox/lxde-rc.xml ~/.config/openbox/
cp configs/lxpanel/panel ~/.config/lxpanel/LXDE/panels/

# 5. Instalação dos Scripts de Saúde (Profiles)
echo "🧠 Configurando scripts de monitoramento..."
mkdir -p ~/bin
cp profiles/rogos_collector.py ~/bin/
cp profiles/rogos_dash.py ~/bin/
chmod +x ~/bin/rogos_*.py

# 6. Serviços de Sistema (Apenas o Vital)
echo "⚙️ Habilitando serviços essenciais..."
sudo systemctl enable NetworkManager
sudo systemctl enable sddm
# Bluetooth e CUPS ficam instalados, mas 'disabled' por padrão (Filosofia Minimalista)

echo "---"
echo "✅ ROG-OS Core v1.0 instalado com sucesso!"
echo "💡 Dica: Reinicie para entrar no ambiente limpo."