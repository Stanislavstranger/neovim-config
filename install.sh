#!/bin/bash

set -e

NVIM_CONFIG_DIR="$HOME/.config/nvim"
BACKUP_DIR="$HOME/.config/nvim.backup"
REPO_URL="https://github.com/Stanislavstranger/neovim-config.git"

detect_package_manager() {
    if command -v apt-get &> /dev/null; then
        echo "apt"
    elif command -v dnf &> /dev/null; then
        echo "dnf"
    elif command -v pacman &> /dev/null; then
        echo "pacman"
    elif command -v brew &> /dev/null; then
        echo "brew"
    else
        echo "unknown"
    fi
}

install_dependencies() {
    echo "🔍 Checking dependencies..."
    
    local pkg_manager=$(detect_package_manager)
    local missing_deps=()
    
    command -v node &> /dev/null || missing_deps+=("nodejs")
    command -v npm &> /dev/null || missing_deps+=("npm")
    command -v python3 &> /dev/null || missing_deps+=("python3")
    command -v rg &> /dev/null || missing_deps+=("ripgrep")
    command -v fd &> /dev/null || missing_deps+=("fd-find")
    
    if [ ${#missing_deps[@]} -eq 0 ]; then
        echo "✅ All dependencies are installed"
        return 0
    fi
    
    echo "📦 Installing missing dependencies: ${missing_deps[*]}"
    
    case $pkg_manager in
        apt)
            sudo apt-get update
            sudo apt-get install -y ${missing_deps[*]}
            ;;
        dnf)
            sudo dnf install -y ${missing_deps[*]}
            ;;
        pacman)
            sudo pacman -S --noconfirm ${missing_deps[*]}
            ;;
        brew)
            brew install ${missing_deps[*]}
            ;;
        *)
            echo "⚠️  Unknown package manager. Please install manually: ${missing_deps[*]}"
            return 1
            ;;
    esac
}

echo "🚀 Installing Neovim config..."
install_dependencies

if [ -d "$NVIM_CONFIG_DIR" ]; then
    echo "📦 Backing up existing nvim config..."
    rm -rf "$BACKUP_DIR"
    mv "$NVIM_CONFIG_DIR" "$BACKUP_DIR"
fi

echo "📥 Cloning repository..."
git clone "$REPO_URL" "$NVIM_CONFIG_DIR"

echo "🔧 Installing LSP servers and tools..."
nvim --headless "+Lazy! sync" +qa
nvim --headless "+MasonInstallAll" +qa

echo "✅ Installation complete! Run 'nvim' to start."
