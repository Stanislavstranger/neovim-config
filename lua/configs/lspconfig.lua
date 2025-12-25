local configs = require "nvchad.configs.lspconfig"

local on_attach = function(client, bufnr)
  configs.on_attach(client, bufnr)
  vim.api.nvim_buf_set_keymap(
    bufnr,
    "n",
    "<leader>ca",
    "<cmd>lua vim.lsp.buf.code_action()<CR>",
    { noremap = true, silent = true }
  )
  vim.api.nvim_buf_set_keymap(
    bufnr,
    "n",
    "<S-K>",
    "<cmd>lua vim.lsp.buf.hover({ border = 'rounded' })<CR>",
    { noremap = true, silent = true }
  )
end

local capabilities = configs.capabilities
capabilities.textDocument.codeAction = {
  dynamicRegistration = true,
  codeActionLiteralSupport = {
    codeActionKind = {
      valueSet = {
        "",
        "quickfix",
        "refactor",
        "refactor.extract",
        "refactor.inline",
        "refactor.rewrite",
        "source",
        "source.organizeImports",
      },
    },
  },
}

local util = require "lspconfig.util"

local function get_python_path(workspace)
  if vim.env.VIRTUAL_ENV and vim.env.VIRTUAL_ENV ~= "" then
    local venv_python = util.path.join(vim.env.VIRTUAL_ENV, "bin", "python")
    if vim.fn.executable(venv_python) == 1 then
      return venv_python
    end
  end

  for _, pattern in ipairs { ".venv", "venv", "env" } do
    local python = util.path.join(workspace, pattern, "bin", "python")
    if vim.fn.executable(python) == 1 then
      return python
    end
  end

  return vim.fn.exepath "python" or "python"
end

local function db_completion()
  require("cmp").setup.buffer { sources = { { name = "vim-dadbod-completion" } } }
end

vim.diagnostic.config {
  virtual_text = true, -- Отображение ошибок непосредственно в коде
  signs = true, -- Показ иконок в гуттере (слева от номеров строк)
  underline = true, -- Подчеркивание ошибок в коде
  update_in_insert = false, -- Обновление ошибок только вне режима вставки
  severity_sort = true, -- Сортировка диагностик по уровню серьезности
}

vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focusable = true })
  end,
})

vim.g.db_ui_save_location = vim.fn.stdpath "config" .. require("plenary.path").path.sep .. "db_ui"
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "sql",
  },
  command = [[setlocal omnifunc=vim_dadbod_completion#omni]],
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "sql",
    "mysql",
    "plsql",
  },
  callback = function()
    vim.schedule(db_completion)
  end,
})

local function organize_imports()
  local params = {
    command = "_typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(0) },
  }
  vim.lsp.buf.execute_command(params)
end

local base_config = {
  on_attach = on_attach,
  capabilities = capabilities,
}

local function with_base(extra)
  return vim.tbl_deep_extend("force", {}, base_config, extra or {})
end

local function with_generic(extra)
  return vim.tbl_deep_extend("force", {}, base_config, {
    commands = {
      OrganizeImports = {
        organize_imports,
        description = "Organize Imports",
      },
    },
    settings = {
      gopls = {
        completeUnimported = true,
        usePlaceholders = true,
        analyses = {
          unusedparams = true,
        },
      },
    },
  }, extra or {})
end

local configs_by_server = {
  html = with_generic(),
  cssls = with_generic(),
  ts_ls = with_generic({
    settings = {
      typescript = {
        inlayHints = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
      javascript = {
        inlayHints = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
    },
  }),
  clangd = with_generic(),
  gopls = with_generic(),
  gradle_ls = with_generic(),
  emmet_ls = with_generic(),
  dockerls = with_generic(),
  sqlls = with_generic(),
  angularls = with_generic(),
  svelte = with_generic(),
  yamlls = with_generic(),
  jsonls = with_generic(),
  eslint = with_base({
    settings = {
      codeAction = {
        disableRuleComment = {
          enable = true,
          location = "separateLine",
        },
        showDocumentation = {
          enable = true,
        },
      },
      codeActionOnSave = {
        enable = false,
        mode = "all",
      },
    },
  }),
  pyright = with_base({
    before_init = function(_, config)
      config.settings = config.settings or {}
      config.settings.python = config.settings.python or {}
      config.settings.python.pythonPath = get_python_path(config.root_dir)
    end,
    settings = {
      python = {
        analysis = {
          autoImportCompletions = true,
          autoSearchPaths = true,
          diagnosticMode = "workspace",
          typeCheckingMode = "basic",
          useLibraryCodeForTypes = true,
        },
      },
    },
  }),
  ruff = with_base({
    on_attach = function(client, bufnr)
      client.server_capabilities.hoverProvider = false
      on_attach(client, bufnr)
    end,
  }),
  graphql = with_base({
    filetypes = {
      "graphql",
      "gql",
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "vue",
      "svelte",
    },
    root_dir = function(bufnr, on_dir)
      local fname = vim.api.nvim_buf_get_name(bufnr)
      on_dir(util.root_pattern(
        ".git",
        "package.json",
        "graphql.config.json",
        "graphql.config.js",
        "graphql.config.ts",
        "graphql.config.yaml",
        "graphql.config.yml"
      )(fname))
    end,
  }),
  tailwindcss = with_base({
    filetypes = {
      "angular",
      "css",
      "html",
      "javascript",
      "javascriptreact",
      "scss",
      "typescript",
      "typescriptreact",
      "vue",
      "svelte",
    },
  }),
  prismals = with_base(),
  vue_ls = with_base({
    filetypes = { "vue" },
    init_options = {
      vue = {
        hybridMode = false,
      },
    },
  }),
  docker_compose_language_service = with_base({
    filetypes = { "yaml" },
    settings = {
      dockerComposeLanguageService = {
        enable = true,
      },
    },
  }),
}

local enabled_servers = {
  "html",
  "cssls",
  "ts_ls",
  "clangd",
  "gopls",
  "gradle_ls",
  "emmet_ls",
  "dockerls",
  "sqlls",
  "angularls",
  "svelte",
  "yamlls",
  "jsonls",
  "eslint",
  "pyright",
  "ruff",
  "graphql",
  "tailwindcss",
  "prismals",
  "vue_ls",
  "docker_compose_language_service",
}

for _, server in ipairs(enabled_servers) do
  local config = configs_by_server[server]
  if config then
    vim.lsp.config(server, config)
  end
end

vim.lsp.enable(enabled_servers)
