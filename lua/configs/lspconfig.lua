local configs = require "nvchad.configs.lspconfig"

local on_attach = configs.on_attach
local capabilities = configs.capabilities

local lspconfig = require "lspconfig"
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

local null_ls = require "null-ls"

-- Настройка null-ls для использования ESLint
null_ls.setup {
  sources = {
    null_ls.builtins.diagnostics.eslint_d, -- Быстрая версия ESLint
    null_ls.builtins.code_actions.eslint_d, -- Code actions от ESLint
  },
  on_attach = on_attach,
}

-- if you just want default config for the servers then put them in a table
local servers = {
  "html",
  "cssls",
  "typescript-language-server",
  "clangd",
  "gopls",
  "gradle_ls",
  "emmet-language-server",
  "docker-compose-language-service",
  "dockerfile-language-server",
  "sqlls",
}

local function organize_imports()
  local params = {
    command = "_typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(0) },
  }
  vim.lsp.buf.execute_command(params)
end

for _, lsp in ipairs(servers) do
  -- if lsp == "typescript-language-server" then
  --   lsp = "ts-ls"
  -- end
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

-- Setup for Prisma language server
lspconfig.prismals.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- Setup for Volar (Vue.js) language server
lspconfig.volar.setup {
  on_attach = on_attach,
  filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
  init_options = {
    vue = {
      hybridMode = false,
    },
  },
}
