local M = {}

local float_win
local float_buf

local function close_tooltip()
  if float_win and vim.api.nvim_win_is_valid(float_win) then
    vim.api.nvim_win_close(float_win, true)
  end
  if float_buf and vim.api.nvim_buf_is_valid(float_buf) then
    vim.api.nvim_buf_delete(float_buf, { force = true })
  end
  float_win, float_buf = nil, nil
end

local function open_tooltip()
  if vim.bo.filetype ~= "NvimTree" then
    close_tooltip()
    return
  end

  local current_line = vim.api.nvim_get_current_line()
  if current_line == "" then
    close_tooltip()
    return
  end

  local win = vim.api.nvim_get_current_win()
  if vim.fn.strdisplaywidth(current_line) <= vim.api.nvim_win_get_width(win) then
    close_tooltip()
    return
  end

  local ok, api = pcall(require, "nvim-tree.api")
  if not ok then
    return
  end

  local node = api.tree.get_node_under_cursor()
  if not node or not node.name then
    close_tooltip()
    return
  end

  local text = node.name
  if node.type == "directory" then
    text = node.name .. "/"
  end

  close_tooltip()

  float_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(float_buf, 0, -1, false, { text })

  local width = math.min(vim.o.columns - 4, vim.fn.strdisplaywidth(text) + 2)

  float_win = vim.api.nvim_open_win(float_buf, false, {
    relative = "cursor",
    row = 0,
    col = 1,
    width = width,
    height = 1,
    anchor = "NW",
    style = "minimal",
    border = "rounded",
    focusable = false,
    noautocmd = true,
  })
end

function M.setup()
  local group = vim.api.nvim_create_augroup("NvimTreeFileTooltip", { clear = true })

  vim.api.nvim_create_autocmd("CursorHold", {
    group = group,
    pattern = "NvimTree*",
    callback = open_tooltip,
  })

  vim.api.nvim_create_autocmd({ "CursorMoved", "BufLeave", "BufWinLeave" }, {
    group = group,
    pattern = "NvimTree*",
    callback = close_tooltip,
  })
end

return M
