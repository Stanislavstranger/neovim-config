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

do
  local query = require "vim.treesitter.query"
  local opts = vim.fn.has "nvim-0.10" == 1 and { force = true, all = false } or true
  local non_filetype_match_injection_language_aliases = {
    ex = "elixir",
    pl = "perl",
    sh = "bash",
    uxn = "uxntal",
    ts = "typescript",
  }
  local html_script_type_languages = {
    ["importmap"] = "json",
    ["module"] = "javascript",
    ["application/ecmascript"] = "javascript",
    ["text/ecmascript"] = "javascript",
  }

  local function get_parser_from_markdown_info_string(injection_alias)
    local match = vim.filetype.match { filename = "a." .. injection_alias }
    return match or non_filetype_match_injection_language_aliases[injection_alias] or injection_alias
  end

  local function normalize_match_node(node)
    if type(node) == "table" then
      return node[#node] or node[1]
    end

    return node
  end

  query.add_predicate("nth?", function(match, _pattern, _bufnr, pred)
    local node = normalize_match_node(match[pred[2]])
    local n = tonumber(pred[3])
    if node and node:parent() and node:parent():named_child_count() > n then
      return node:parent():named_child(n) == node
    end

    return false
  end, opts)

  query.add_predicate("is?", function(match, _pattern, bufnr, pred)
    local locals = require "nvim-treesitter.locals"
    local node = normalize_match_node(match[pred[2]])
    local types = { unpack(pred, 3) }

    if not node then
      return true
    end

    local _, _, kind = locals.find_definition(node, bufnr)
    return vim.tbl_contains(types, kind)
  end, opts)

  query.add_predicate("kind-eq?", function(match, _pattern, _bufnr, pred)
    local node = normalize_match_node(match[pred[2]])
    local types = { unpack(pred, 3) }

    if not node then
      return true
    end

    return vim.tbl_contains(types, node:type())
  end, opts)

  query.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
    local node = normalize_match_node(match[pred[2]])
    if not node then
      return
    end

    local type_attr_value = vim.treesitter.get_node_text(node, bufnr)
    local configured = html_script_type_languages[type_attr_value]
    if configured then
      metadata["injection.language"] = configured
    else
      local parts = vim.split(type_attr_value, "/", {})
      metadata["injection.language"] = parts[#parts]
    end
  end, opts)

  query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
    local node = normalize_match_node(match[pred[2]])
    if not node then
      return
    end

    local injection_alias = vim.treesitter.get_node_text(node, bufnr):lower()
    metadata["injection.language"] = get_parser_from_markdown_info_string(injection_alias)
  end, opts)

  query.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
    local id = pred[2]
    local node = normalize_match_node(match[id])
    if not node then
      return
    end

    local text = vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[id] }) or ""
    metadata[id] = metadata[id] or {}
    metadata[id].text = string.lower(text)
  end, opts)
end

local function sanitize_markdown_undo_ftplugin(bufnr)
  local undo = vim.b[bufnr].undo_ftplugin
  if type(undo) ~= "string" or undo == "" then
    return
  end

  local filtered = {}
  for _, line in ipairs(vim.split(undo, "\n", { plain = true })) do
    if not line:match('^%s*sil! exe "nunmap <buffer> gO"$')
      and not line:match('^%s*sil! exe "nunmap <buffer> %]%]" | sil! exe "nunmap <buffer> %[%["$') then
      table.insert(filtered, line)
    end
  end

  vim.b[bufnr].undo_ftplugin = table.concat(filtered, "\n")
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function(args)
    sanitize_markdown_undo_ftplugin(args.buf)
  end,
})

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
