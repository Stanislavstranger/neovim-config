local configs = require "nvchad.configs.lspconfig"

local on_attach = configs.on_attach
local capabilities = configs.capabilities

local lspconfig = require "lspconfig"

vim.diagnostic.config {
  virtual_text = true, -- Отображение ошибок непосредственно в коде
  signs = true, -- Показ иконок в гуттере (слева от номеров строк)
  underline = true, -- Подчеркивание ошибок в коде
  update_in_insert = false, -- Обновление ошибок только вне режима вставки
  severity_sort = true, -- Сортировка диагностик по уровню серьезности
}

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
local servers = { "html", "cssls", "tsserver", "clangd", "gopls", "gradle_ls", "emmet-language-server" }

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
