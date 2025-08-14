vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
    config = function()
      require "options"
    end,
  },

  { import = "plugins" },
}, lazy_config)

require("nvim-web-devicons").set_icon {
  css = {
    icon = "",
    color = "#458588",
    cterm_color = "65",
    name = "Css",
  },
}

require("nvim-web-devicons").set_icon {
  rest = {
    icon = "",
    color = "#458588",
    cterm_color = "65",
    name = "Rest",
  },
}

require("nvim-web-devicons").set_icon {
  ["service.ts"] = {
    icon = "󰢍",
    color = "#458588",
    cterm_color = "65",
    name = "Rest",
  },
}

require("nvim-web-devicons").set_icon {
  ["controller.ts"] = {
    icon = "󰊴",
    color = "#458588",
    cterm_color = "65",
    name = "Rest",
  },
}

require("nvim-web-devicons").set_icon {
  ["config.ts"] = {
    icon = "",
    color = "#458588",
    cterm_color = "65",
    name = "rest",
  },
}

require("nvim-web-devicons").set_icon {
  ["guard.ts"] = {
    icon = "󰒃",
    color = "#458588",
    cterm_color = "65",
    name = "rest",
  },
}

require("render-markdown").setup {
  completions = { lsp = { enabled = true } },
}

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)

vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    vim.opt_local.winfixbuf = false
  end,
})
