local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettierd" },
    javascript = { "prettierd" },
    typescript = { "prettierd" },
    typescriptreact = { "prettierd" },
    javascriptreact = { "prettierd" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

require("conform").setup(options)
