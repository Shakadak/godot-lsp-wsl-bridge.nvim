local map = require("lsp.gdscript.table.addition").map

local Transform = require("lsp.gdscript.transform")

local deep_apply = Transform.deep_apply
local identity = Transform.identity
local textDocument_uri = Transform.textDocument_uri
local toWPath = Transform.toWPath
local onFileUri = Transform.onFileUri
local defaultTransform = Transform.defaultTransform

local initialize = Transform.deep_apply({
  rootPath = toWPath,
  rootUri = onFileUri(toWPath),
  workspaceFolders = map(Transform.deep_apply({
    name = toWPath,
    uri = onFileUri(toWPath),
  })),
})

-- Client ==> LSP
local request_transform = {
  ["completionItem/resolve"] = deep_apply({ data = textDocument_uri(toWPath) }),
  ["shutdown"] = identity,
  ["textDocument/completion"] = textDocument_uri(toWPath),
  ["textDocument/definition"] = textDocument_uri(toWPath),
  ["textDocument/hover"] = textDocument_uri(toWPath),
  ["textDocument/signatureHelp"] = textDocument_uri(toWPath),
  ["textDocument/willSaveWaitUntil"] = textDocument_uri(toWPath),
  ['initialize'] = initialize,
}
setmetatable(request_transform, {__index = defaultTransform('request_transform')})

return request_transform
