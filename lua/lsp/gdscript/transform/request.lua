local map = require("lsp.gdscript.table.addition").map

local transform = require("lsp.gdscript.transform")

local onParams = transform.onParams
local onKey = transform.onKey
local identity = transform.identity
local textDocument_uri = transform.textDocument_uri
local toWPath = transform.toWPath
local onFileUri = transform.onFileUri
local defaultTransform = transform.defaultTransform

local function initialize(params)
  -- local log = require('lsp.gdscript.log')
  -- log:write('dbg.initialize', params)
  params.rootPath = toWPath(params.rootPath)
  params.rootUri = onFileUri(toWPath, params.rootUri)

  params.workspaceFolders = map(params.workspaceFolders, function (folder)
    folder.name = toWPath(folder.name)
    folder.uri = onFileUri(toWPath, folder.uri)
    return folder
  end)

  return params
end

-- Client ==> LSP
local request_transform = {
  ["completionItem/resolve"] = onParams(onKey("data", textDocument_uri(toWPath))),
  ["shutdown"] = identity,
  ["textDocument/completion"] = textDocument_uri(toWPath),
  ["textDocument/definition"] = textDocument_uri(toWPath),
  ["textDocument/hover"] = textDocument_uri(toWPath),
  ["textDocument/signatureHelp"] = textDocument_uri(toWPath),
  ["textDocument/willSaveWaitUntil"] = textDocument_uri(toWPath),
  ['initialize'] = onParams(initialize),
}
setmetatable(request_transform, {__index = defaultTransform('request_transform')})

return request_transform
