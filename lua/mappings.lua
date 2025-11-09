require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save" })
map("n", "<leader>x", "<cmd>bdelete<CR>", { desc = "Close Buffer" })
map("n", "<leader>q", function()
  local current_buf = vim.api.nvim_get_current_buf()
  local bufs = vim.fn.getbufinfo { buflisted = 1 }

  -- If there's only one listed buffer, we need to handle it specially to keep the window open.
  if #bufs <= 1 then
    if vim.bo[current_buf].modified then
      local choice = vim.fn.confirm("Buffer has unsaved changes. Save?", "&Yes\n&No\n&Cancel")
      if choice == 1 then -- Yes
        vim.cmd "write"
      elseif choice == 3 then -- Cancel
        return -- Abort the operation
      end
    end
    vim.cmd "enew | bdelete#"
    return
  end

  -- If there are multiple listed buffers, we can try to switch to another one.
  local next_buf = -1
  for _, buf_info in ipairs(bufs) do
    if buf_info.bufnr ~= current_buf then
      next_buf = buf_info.bufnr
      break
    end
  end

  if next_buf ~= -1 then
    vim.api.nvim_set_current_buf(next_buf)
    vim.cmd("confirm bdelete " .. current_buf)
  else
    -- Fallback: This case should ideally not be reached if #bufs > 1 and next_buf is found.
    -- But if it is, treat it like the single buffer case.
    if vim.bo[current_buf].modified then
      local choice = vim.fn.confirm("Buffer has unsaved changes. Save?", "&Yes\n&No\n&Cancel")
      if choice == 1 then -- Yes
        vim.cmd "write"
      elseif choice == 3 then -- Cancel
        return -- Abort the operation
      end
    end
    vim.cmd "enew | bdelete#"
  end
end, { desc = "Close Buffer & Keep Window (with prompt)" })
map("n", "<leader>cx", function()
  require("nvchad.tabufline").closeAllBufs()
end, { desc = "Close All Buffers" })

map("n", "<leader>ft", "<cmd>TodoTelescope<CR>", { desc = "Find Todo" })
map("n", "\\", "<cmd>:vsplit <CR>", { desc = "Vertical Split" })
map("n", "<leader>-", "<cmd>split<CR>", { desc = "Horizontal Split" })
map("n", "<c-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "Tmux Right", silent = true })
map("n", "<c-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Tmux Left", silent = true })
map("n", "<c-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "Tmux Up", silent = true })
map("n", "<c-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "Tmux Down", silent = true })

-- Trouble

map("n", "<leader>qx", "<cmd>TroubleToggle<CR>", { desc = "Open Trouble" })
map("n", "<leader>qw", "<cmd>TroubleToggle workspace_diagnostics<CR>", { desc = "Open Workspace Trouble" })
map("n", "<leader>qd", "<cmd>TroubleToggle document_diagnostics<CR>", { desc = "Open Document Trouble" })
map("n", "<leader>qq", "<cmd>TroubleToggle quickfix<CR>", { desc = "Open Quickfix" })
map("n", "<leader>ql", "<cmd>TroubleToggle loclist<CR>", { desc = "Open Location List" })
map("n", "<leader>qt", "<cmd>TodoTrouble<CR>", { desc = "Open Todo Trouble" })

-- Tests
map("n", "<leader>tt", function()
  require("neotest").run.run()
end, { desc = "Run nearest test" })
map("n", "<leader>tf", function()
  require("neotest").run.run(vim.fn.expand "%")
end, { desc = "Run file test" })
map("n", "<leader>to", ":Neotest output<CR>", { desc = "Show test output" })
map("n", "<leader>ts", ":Neotest summary<CR>", { desc = "Show test summary" })

-- Debug
map("n", "<leader>du", function()
  require("dapui").toggle()
end, { desc = "Toggle Debug UI" })
map("n", "<leader>dbp", function()
  require("dap").toggle_breakpoint()
end, { desc = "Toggle Breakpoint" })
map("n", "<leader>ds", function()
  require("dap").continue()
end, { desc = "Start" })
map("n", "<leader>dn", function()
  require("dap").step_over()
end, { desc = "Step Over" })

-- Git
map("n", "<leader>gl", ":Flog<CR>", { desc = "Git Log" })
map("n", "<leader>gf", ":DiffviewFileHistory<CR>", { desc = "Git File History" })
map("n", "<leader>gc", ":DiffviewOpen HEAD~1<CR>", { desc = "Git Last Commit" })
map("n", "<leader>gt", ":DiffviewToggleFile<CR>", { desc = "Git File History" })
map("n", "<leader>gp", ":Gitsigns preview_hunk_inline<CR>", { desc = "Gitsigns priview hunk inline" })
map("n", "<leader>gr", ":Gitsigns reset_hunk<CR>", { desc = "Gitsigns reset hunk" })
map("n", "<leader>lg", ":LazyGit<CR>", { desc = "LazyGit" })
map("n", "<leader>gf", ":Git diff<CR>", { desc = "Git diff" })
map("n", "<leader>gbl", ":Gitsigns blame_line<CR>", { desc = "Gitsigns blame line" })
map("n", "<leader>gbf", ":Gitsigns blame<CR>", { desc = "Gitsigns blame" })

--Edit
map("n", "<leader>pe", ":Telescope emoji<CR>", { desc = "Paste emoji" })

-- Terminal
map("n", "<C-]>", function()
  require("nvchad.term").toggle { pos = "vsp", size = 0.4 }
end, { desc = "Toogle Terminal Vertical" })
map("n", "<C-\\>", function()
  require("nvchad.term").toggle { pos = "sp", size = 0.4 }
end, { desc = "Toogle Terminal Horizontal" })
map("n", "<C-f>", function()
  require("nvchad.term").toggle { pos = "float" }
end, { desc = "Toogle Terminal Float" })
map("t", "<C-]>", function()
  require("nvchad.term").toggle { pos = "vsp" }
end, { desc = "Toogle Terminal Vertical" })
map("t", "<C->", function()
  require("nvchad.term").toggle { pos = "sp" }
end, { desc = "Toogle Terminal Horizontal" })
map("t", "<C-f>", function()
  require("nvchad.term").toggle { pos = "float" }
end, { desc = "Toogle Terminal Float" })

-- Basic

map("i", "jj", "<ESC>")
map("i", "<C-g>", function()
  return vim.fn["codeium#Accept"]()
end, { expr = true })

--LSP Restart
map("n", "<leader>lr", ":LspRestart<CR>", { desc = "LSP Restart" })

-- REST
map("n", "<leader>rr", ":call VrcQuery()<CR>", { desc = "Rest Request" })
map("n", "<leader>at", ":Atac<CR>", { desc = "Atac" })

-- DBUI
map("n", "<leader>dbb", ":DBUI<CR>", { desc = "DBUI" })

map("n", "<leader>ft", ":NvimTreeFindFile<CR>", { desc = "NvimTreeFindFile" })

map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", { desc = "Code Action" })

-- Terminal mode mappings to pass Ctrl+h/j/k/l to the shell
map("t", "<c-l>", "<C-l>", { desc = "Clear terminal screen" })
map("t", "<c-h>", "<C-h>", { desc = "Terminal backspace" })
map("t", "<c-j>", "<C-j>", { desc = "Terminal newline" })
map("t", "<c-k>", "<C-k>", { desc = "Terminal up" })

map("t", "<C-]>", function()
  require("nvchad.term").toggle { pos = "vsp" }
end, { desc = "Toogle Terminal Vertical" })
map("t", "<C->", function()
  require("nvchad.term").toggle { pos = "sp" }
end, { desc = "Toogle Terminal Horizontal" })
map("t", "<C-f>", function()
  require("nvchad.term").toggle { pos = "float" }
end, { desc = "Toogle Terminal Float" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Tabs
map("n", "<leader>tn", "<cmd>tabnext<CR>", { desc = "Next tab" })
map("n", "<leader>tp", "<cmd>tabprevious<CR>", { desc = "Previous tab" })

-- Move
map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move down" })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move up" })
