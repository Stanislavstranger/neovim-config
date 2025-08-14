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

local lspconfig = require "lspconfig"

lspconfig.ts_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
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
}

lspconfig.eslint.setup {
  on_attach = on_attach,
  capabilities = capabilities,
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
}

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

local servers = {
  "html",
  "cssls",
  "ts_ls",
  "clangd",
  "gopls",
  "gradle_ls",
  "emmet_ls",
  "docker_compose_language_service",
  "dockerls",
  "sqlls",
  "angularls",
  "svelte",
}

local function organize_imports()
  local params = {
    command = "_typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(0) },
  }
  vim.lsp.buf.execute_command(params)
end

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
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
  }
end

lspconfig.tailwindcss.setup {
  on_attach = on_attach,
  capabilities = capabilities,
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
}

-- Setup for Prisma language server
lspconfig.prismals.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- Setup for Volar (Vue.js) language server
lspconfig.volar.setup {
  on_attach = on_attach,
  filetypes = { "vue" },
  init_options = {
    vue = {
      hybridMode = false,
    },
  },
}

lspconfig.docker_compose_language_service.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "yaml" },
  settings = {
    dockerComposeLanguageService = {
      enable = true,
    },
  },
}
