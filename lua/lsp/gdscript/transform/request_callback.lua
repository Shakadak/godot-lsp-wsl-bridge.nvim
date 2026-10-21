-- Client <== Server

local transform = require("lsp.gdscript.transform")

local onKey = transform.onKey
local textDocument_uri = transform.textDocument_uri
local toUPath = transform.toUPath
local onFileUri = transform.onFileUri
local biIdentity = transform.biIdentity
local defaultCallbackTransform = transform.defaultCallbackTransform
local onResult = transform.onResult
local onResults = transform.onResults


local request_callback_transform = {
  ["completionItem/resolve"] = onResult(onKey("data", textDocument_uri(toUPath))),
  ["initialize"] = biIdentity,
  ["textDocument/completion"] = onResults(onKey("data", textDocument_uri(toUPath))),
  ["textDocument/definition"] = onResults(onKey("uri", onFileUri(toUPath))),
  ["textDocument/hover"] = biIdentity,
  ["textDocument/signatureHelp"] = biIdentity,
  ["textDocument/willSaveWaitUntil"] = biIdentity,
}
setmetatable(request_callback_transform, {__index = defaultCallbackTransform('request_callback_transform')})

return request_callback_transform
