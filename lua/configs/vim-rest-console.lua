-- Turn off the default key bindings
vim.g.rest_nvim_mappings = 0
-- Set rhe default responce content type to json
vim.g.vrc_response_default_content_type = "application/json"
-- Set the output buffer name
vim.g.vrc_output_buffer_name = "_OUTPUT.json"
-- Run format command on the responce buffer
vim.g.vrc_auto_format_responce_patterns = {
  json = "jq",
}
