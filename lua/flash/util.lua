local M = {}

function M.t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

M.CR = M.t("<cr>")
M.ESC = M.t("<esc>")
M.BS = M.t("<bs>")
M.LUA_CALLBACK = "\x80\253g"
M.CMD = "\x80\253h"

function M.get_char()
  vim.cmd.redraw()
  local ok, ret = pcall(vim.fn.getcharstr)
  return ok and ret ~= M.ESC and ret or nil
end

return M
