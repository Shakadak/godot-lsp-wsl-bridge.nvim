-- https://neovim.io/doc/user/usr_41/#_not-loading
if vim.g.gdscript ~= nil then
  return
end
vim.g.gdscript = 1

require("lsp.gdscript")
