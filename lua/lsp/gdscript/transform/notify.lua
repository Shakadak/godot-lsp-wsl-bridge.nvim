local transform = require("lsp.gdscript.transform")

local identity = transform.identity
local textDocument_uri = transform.textDocument_uri
local toWPath = transform.toWPath
local defaultTransform = transform.defaultTransform

-- Client ==> LSP
local notify_transform = {
  ["initialized"] = identity,
  ["textDocument/didChange"] = textDocument_uri(toWPath),
  ["textDocument/didClose"] = textDocument_uri(toWPath),
  ["textDocument/didOpen"] = textDocument_uri(toWPath),
  ["textDocument/didSave"] = textDocument_uri(toWPath),
}
setmetatable(notify_transform, {__index = defaultTransform('notify_transform')})

return notify_transform
