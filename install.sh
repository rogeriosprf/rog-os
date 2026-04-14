#!/bin/bash

# --- ROG-OS Core v1.0 - Bootstrap Script ---
echo "🚀 Iniciando a restauração do ROG-OS Core..."

# 1. Atualização do Sistema
echo "📦 Atualizando repositórios..."
sudo pacman -Syu --noconfirm

# 2. Instalação da Base (Lendo o seu manifesto)
echo "📦 Instalando pacotes da base..."
if [ -f "packages.txt" ]; then
    sudo pacman -S --needed --noconfirm - < packages.txt
else
    echo "❌ Erro: packages.txt não encontrado!"
    exit 1
fi

# 3. Configuração de Segurança
echo "🛡️ Configurando o Firewall (UFW)..."
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable

# 4. Restauração de Configurações (Dotfiles)
echo "🎨 Restaurando configurações de interface..."
mkdir -p ~/.config/openbox
mkdir -p ~/.config/lxpanel/LXDE/panels

cp configs/openbox/lxde-rc.xml ~/.config/openbox/
cp configs/lxpanel/panel ~/.config/lxpanel/LXDE/panels/

# 5. Instalação dos Scripts de Saúde
echo "🧠 Configurando scripts de monitoramento..."
mkdir -p ~/bin
cp profiles/rogos_collector.py ~/bin/
cp profiles/rogos_dash.py ~/bin/
chmod +x ~/bin/rogos_*.py

echo "---"
echo "✅ ROG-OS Core v1.0 instalado com sucesso!"
echo "💡 Dica: Reinicie o Openbox para aplicar as configurações de interface."
