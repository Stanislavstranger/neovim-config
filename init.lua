-- Pick the base46 cache that actually exists (some installs write to data/base46)
local base46_default = vim.fn.stdpath "data" .. "/nvchad/base46/"
local base46_fallback = vim.fn.stdpath "data" .. "/base46/"
vim.g.base46_cache = vim.fn.isdirectory(base46_default) == 1 and base46_default or base46_fallback
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
    name = "guard",
  },
}

require("nvim-web-devicons").set_icon {
  ["sentry.client.config.ts"] = {
    icon = "",
    color = "#e1567c",
    cterm_color = "65",
    name = "sentry",
  },
  ["sentry.server.config.ts"] = {
    icon = "",
    color = "#e1567c",
    cterm_color = "65",
    name = "sentry",
  },
  ["sentry.edge.config.ts"] = {
    icon = "",
    color = "#e1567c",
    cterm_color = "65",
    name = "sentry",
  },
}

require("nvim-web-devicons").set_icon {
  ["playwright.config.ts"] = {
    icon = "",
    color = "#2ead33",
    cterm_color = "65",
    name = "playwright",
  },
}

require("nvim-web-devicons").set_icon {
  ["postcss.config.js"] = {
    icon = "",
    color = "#d6380a",
    cterm_color = "65",
    name = "postcss",
  },
}

require("nvim-web-devicons").set_icon {
  ["jest.config.ts"] = {
    icon = "",
    color = "#c03b13",
    cterm_color = "65",
    name = "jest",
  },
  ["jest.setup.ts"] = {
    icon = "",
    color = "#c03b13",
    cterm_color = "65",
    name = "jest",
  },
}

require("nvim-web-devicons").set_icon {
  [".env.example"] = {
    icon = "",
    color = "#fabd2f",
    cterm_color = "65",
    name = "env",
  },
}

require("nvim-web-devicons").set_icon {
  ["route.ts"] = {
    icon = "󰑪",
    color = "#b8bb26",
    cterm_color = "65",
    name = "route",
  },
  ["route.js"] = {
    icon = "󰑪",
    color = "#b8bb26",
    cterm_color = "65",
    name = "route",
  },
}

require("nvim-web-devicons").set_icon {
  ["error.tsx"] = {
    icon = "",
    color = "#c03b13",
    cterm_color = "65",
    name = "error",
  },
}

require("nvim-web-devicons").set_icon {
  ["cypress.config.ts"] = {
    icon = "",
    color = "#458588",
    cterm_color = "65",
    name = "sypress",
  },
}

require("nvim-web-devicons").set_icon {
  ["vite.config.ts"] = {
    icon = "",
    color = "#458588",
    cterm_color = "65",
    name = "vite",
  },
}

require("nvim-web-devicons").set_icon {
  ["webpack.config.ts"] = {
    icon = "",
    color = "#458588",
    cterm_color = "65",
    name = "webpack",
  },
}

require("nvim-web-devicons").set_icon {
  ["stylelintrc"] = {
    icon = "",
    color = "#FFFFFF",
    cterm_color = "65",
    name = "stylelint",
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
