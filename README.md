This repo is an NvChad-based Neovim configuration.

# Installation

## Prerequisites

- Neovim >= 0.9
- Git
- Node.js & npm (for some LSP features)
- Python (for some LSP features)
- Ripgrep (for telescope search)
- fd (for telescope file finding)

## Install

### One-line install:

```bash
curl -fsSL https://raw.githubusercontent.com/Stanislavstranger/neovim-config/main/install.sh | bash
```

### Manual install:

1. Backup your current nvim config:
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   ```

2. Clone this repo:
   ```bash
   git clone https://github.com/Stanislavstranger/neovim-config.git ~/.config/nvim
   ```

3. Open Neovim:
   ```bash
   nvim
   ```

4. Lazy.nvim will automatically install all plugins.

5. Install LSP servers and tools:
   ```vim
   :MasonInstallAll
   ```

# Credits

1) NvChad https://github.com/NvChad/NvChad - The main nvchad repo (NvChad/NvChad) is used as a plugin by this repo.
2) Lazyvim starter https://github.com/LazyVim/starter as nvchad's starter was inspired by Lazyvim's. It made a lot of things easier!
